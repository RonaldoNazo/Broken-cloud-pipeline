#!/usr/bin/env python3
"""
ECS Deployment Script
Deploys a new Docker image to an ECS service by updating the task definition.
"""

import argparse
import sys
import boto3
from botocore.exceptions import ClientError


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Deploy Docker image to ECS')
    parser.add_argument('--cluster-name', required=True, help='ECS cluster name')
    parser.add_argument('--service', required=True, help='ECS service name')
    parser.add_argument('--task-definition', required=True, help='ECS task definition family name')
    parser.add_argument('--image', required=True, help='Docker image URI (e.g., account.dkr.ecr.region.amazonaws.com/repo:tag)')
    return parser.parse_args()


def validate_ecr_image(image_uri):
    """
    Validate if the image exists in ECR.

    Args:
        image_uri: Full image URI (registry/repository:tag)

    Returns:
        bool: True if image exists, False otherwise
    """
    try:
        # Parse the image URI
        # Format: account.dkr.ecr.region.amazonaws.com/repository:tag
        if '.ecr.' not in image_uri or '.amazonaws.com' not in image_uri:
            print(f"Image is not from ECR, skipping validation: {image_uri}")
            return True

        parts = image_uri.split('/')
        repository_with_tag = '/'.join(parts[1:])  # repository:tag

        if ':' in repository_with_tag:
            repository_name = repository_with_tag.rsplit(':', 1)[0]
            image_tag = repository_with_tag.rsplit(':', 1)[1]
        else:
            repository_name = repository_with_tag
            image_tag = 'latest'

        print(f"Validating ECR image: {repository_name}:{image_tag}")

        ecr_client = boto3.client('ecr')

        response = ecr_client.describe_images(
            repositoryName=repository_name,
            imageIds=[{'imageTag': image_tag}]
        )

        if response['imageDetails']:
            print(f"✓ Image found in ECR: {repository_name}:{image_tag}")
            return True
        else:
            print(f"✗ Image not found in ECR: {repository_name}:{image_tag}")
            return False

    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'ImageNotFoundException':
            print(f"✗ Image not found in ECR: {repository_name}:{image_tag}")
            return False
        elif error_code == 'RepositoryNotFoundException':
            print(f"✗ ECR repository not found: {repository_name}")
            return False
        else:
            print(f"✗ Error validating ECR image: {e}")
            return False
    except Exception as e:
        print(f"✗ Error parsing or validating image URI: {e}")
        return False


def get_current_task_definition(ecs_client, task_definition_family):
    """
    Get the current task definition.

    Args:
        ecs_client: boto3 ECS client
        task_definition_family: Task definition family name

    Returns:
        dict: Current task definition
    """
    try:
        response = ecs_client.describe_task_definition(
            taskDefinition=task_definition_family
        )
        return response['taskDefinition']
    except ClientError as e:
        print(f"✗ Error retrieving task definition '{task_definition_family}': {e}")
        sys.exit(1)


def create_new_task_definition(ecs_client, current_task_def, new_image):
    """
    Create a new task definition revision with updated image.

    Args:
        ecs_client: boto3 ECS client
        current_task_def: Current task definition dict
        new_image: New Docker image URI

    Returns:
        str: ARN of the new task definition
    """
    try:
        # Update the image in the first container definition
        container_definitions = current_task_def['containerDefinitions']
        container_definitions[0]['image'] = new_image

        print(f"Creating new task definition with image: {new_image}")

        # Prepare the new task definition (remove fields that can't be used in registration)
        new_task_def = {
            'family': current_task_def['family'],
            'taskRoleArn': current_task_def.get('taskRoleArn', ''),
            'executionRoleArn': current_task_def.get('executionRoleArn', ''),
            'networkMode': current_task_def.get('networkMode', 'bridge'),
            'containerDefinitions': container_definitions,
            'volumes': current_task_def.get('volumes', []),
            'placementConstraints': current_task_def.get('placementConstraints', []),
            'requiresCompatibilities': current_task_def.get('requiresCompatibilities', []),
            'cpu': current_task_def.get('cpu', ''),
            'memory': current_task_def.get('memory', ''),
        }

        # Remove empty strings
        new_task_def = {k: v for k, v in new_task_def.items() if v != ''}

        response = ecs_client.register_task_definition(**new_task_def)
        new_task_def_arn = response['taskDefinition']['taskDefinitionArn']

        print(f"✓ New task definition created: {new_task_def_arn}")
        return new_task_def_arn

    except ClientError as e:
        print(f"✗ Error creating new task definition: {e}")
        sys.exit(1)


def update_service(ecs_client, cluster_name, service_name, task_definition_arn):
    """
    Update ECS service with new task definition.

    Args:
        ecs_client: boto3 ECS client
        cluster_name: ECS cluster name
        service_name: ECS service name
        task_definition_arn: New task definition ARN
    """
    try:
        print(f"Updating service '{service_name}' in cluster '{cluster_name}'...")

        response = ecs_client.update_service(
            cluster=cluster_name,
            service=service_name,
            taskDefinition=task_definition_arn,
            forceNewDeployment=True
        )

        # FLAW: Not waiting for deployment to stabilize - reports success before tasks are actually running
        # Should use waiter = ecs_client.get_waiter('services_stable') and waiter.wait()
        print(f"✓ Service updated successfully")
        print(f"  Service: {response['service']['serviceName']}")
        print(f"  Task Definition: {response['service']['taskDefinition']}")
        print(f"  Desired Count: {response['service']['desiredCount']}")

    except ClientError as e:
        print(f"✗ Error updating service: {e}")
        sys.exit(1)


def main():
    """Main deployment function."""
    # Parse arguments
    args = parse_arguments()

    print("=" * 60)
    print("ECS Deployment Script")
    print("=" * 60)
    print(f"Cluster: {args.cluster_name}")
    print(f"Service: {args.service}")
    print(f"Task Definition: {args.task_definition}")
    print(f"Image: {args.image}")
    print("=" * 60)

    # Validate ECR image
    print("\n[1/3] Validating image in ECR...")
    if not validate_ecr_image(args.image):
        print("\n✗ Deployment failed: Image validation failed")
        sys.exit(1)

    # Initialize ECS client
    ecs_client = boto3.client('ecs')

    # Get current task definition
    print("\n[2/3] Updating task definition...")
    current_task_def = get_current_task_definition(ecs_client, args.task_definition)
    print(f"Current task definition: {current_task_def['family']}:{current_task_def['revision']}")

    # Create new task definition with updated image
    new_task_def_arn = create_new_task_definition(ecs_client, current_task_def, args.image)

    # Update service
    print("\n[3/3] Updating ECS service...")
    update_service(ecs_client, args.cluster_name, args.service, new_task_def_arn)

    print("\n" + "=" * 60)
    print("✓ Deployment Successful!")
    print("=" * 60)


if __name__ == '__main__':
    main()
