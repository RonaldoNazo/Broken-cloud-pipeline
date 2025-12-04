# Pre-Commit Hooks Setup Guide

This repository uses pre-commit hooks to ensure code quality, security, and consistency.

## Prerequisites

- Python 3.7+
- Terraform >= 1.0
- Git

## Installation

### 1. Install pre-commit

```bash
pip install pre-commit
```

Or using Homebrew (macOS):

```bash
brew install pre-commit
```

### 2. Install Required Tools

#### TFLint (Terraform Linter)

```bash
# macOS
brew install tflint

# Linux
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Windows (Chocolatey)
choco install tflint
```

#### TFSec (Terraform Security Scanner)

```bash
# macOS
brew install tfsec

# Linux
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Windows (Chocolatey)
choco install tfsec
```

#### Checkov (Security Scanner)

```bash
pip install checkov
```

#### terraform-docs (Documentation Generator)

```bash
# macOS
brew install terraform-docs

# Linux
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0-linux-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/
```

### 3. Install Pre-Commit Hooks

Navigate to the repository root and run:

```bash
pre-commit install
```

This will install the git hook scripts that run automatically on `git commit`.

## Usage

### Automatic Execution

Once installed, the hooks will run automatically when you commit:

```bash
git add .
git commit -m "your commit message"
```

### Manual Execution

Run on all files:

```bash
pre-commit run --all-files
```

Run on specific files:

```bash
pre-commit run --files terraform/*.tf
```

Run a specific hook:

```bash
pre-commit run terraform_fmt --all-files
pre-commit run checkov --all-files
```

### Skip Hooks (Use Sparingly)

To skip all hooks (not recommended):

```bash
git commit --no-verify -m "your commit message"
```

To skip specific hooks:

```bash
SKIP=checkov git commit -m "your commit message"
```

## Configured Hooks

### 1. Pre-Commit Basic Hooks

- **trailing-whitespace**: Remove trailing whitespace
- **end-of-file-fixer**: Ensure files end with newline
- **check-yaml**: Validate YAML syntax
- **check-json**: Validate JSON syntax
- **check-added-large-files**: Prevent large files (>500KB)
- **check-case-conflict**: Check for case-sensitive filename conflicts
- **check-merge-conflict**: Detect merge conflict markers
- **detect-private-key**: Prevent committing private keys
- **mixed-line-ending**: Check for mixed line endings

### 2. Terraform Hooks

- **terraform_fmt**: Auto-format Terraform files
- **terraform_validate**: Validate Terraform configuration
- **terraform_docs**: Auto-generate documentation
- **terraform_tflint**: Lint Terraform code
- **terraform_tfsec**: Security scanning with tfsec

### 3. Security Scanning

- **checkov**: Comprehensive security and compliance scanning
  - Scans for security misconfigurations
  - Checks compliance with best practices
  - Skips certain checks that may not apply

## Troubleshooting

### Hook Fails on First Run

If hooks fail on the first run, they may need to download/install dependencies:

```bash
pre-commit clean
pre-commit install --install-hooks
```

### Update Hooks

To update to the latest versions:

```bash
pre-commit autoupdate
```

### Clear Cache

If you encounter issues:

```bash
pre-commit clean
pre-commit gc
```

### Terraform Init Required

If `terraform_validate` fails, ensure Terraform is initialized:

```bash
cd terraform/
terraform init
```

## Configuration Files

- `.pre-commit-config.yaml`: Main pre-commit configuration
- `.tflint.hcl`: TFLint configuration for Terraform linting rules

## Skipped Checkov Checks

The following Checkov checks are skipped (configured in `.pre-commit-config.yaml`):

- `CKV_AWS_79`: S3 bucket logging
- `CKV_AWS_144`: S3 bucket cross-region replication
- `CKV_AWS_145`: S3 bucket KMS encryption
- `CKV2_AWS_5`: Security group description

These can be reviewed and adjusted based on your security requirements.

## Customization

### Modify Pre-Commit Configuration

Edit `.pre-commit-config.yaml` to:
- Add/remove hooks
- Change hook versions
- Modify hook arguments

### Modify TFLint Rules

Edit `.tflint.hcl` to enable/disable specific linting rules.

### Modify Checkov Checks

Edit the `checkov` hook args in `.pre-commit-config.yaml` to skip different checks:

```yaml
args:
  - --skip-check=CKV_AWS_123,CKV_AWS_456
```

## CI/CD Integration

These hooks can also run in CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Run pre-commit
  run: |
    pip install pre-commit
    pre-commit run --all-files
```

## Resources

- [Pre-Commit Documentation](https://pre-commit.com/)
- [Terraform Pre-Commit Hooks](https://github.com/antonbabenko/pre-commit-terraform)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [TFSec Documentation](https://aquasecurity.github.io/tfsec/)
