# Terraform Modules Template

## Description

This repository provides a template and management utilities for handling Terraform modules. It includes a CLI script to automate the initialization, validation, updating, and cleanup of modules, as well as configuration versioning and documentation generation.

The modules are managed as flattened directory copies (not git submodules) with version tracking via a `modules.lock` file.

## Script Installation

1. **Install Python dependencies** (preferably in a virtual environment):

   ```sh
   pip install -r requirements.txt
   ```

   Required packages include: `click`, `PyYAML`, `GitPython`, `rich`, `semver`, `requests`.

2. **Make the script executable**:

   ```sh
   chmod +x scripts/tfmodules.py
   ```

3. **(Optional) Add to your PATH**:

   ```sh
   export PATH="$PATH:$(pwd)/scripts"
   ```

4. **Set up GitHub authentication** (required for `analyze` command):

   ```sh
   export GITHUB_TOKEN="your_github_personal_access_token"
   ```

   The token needs `repo` scope to access repository information and list organization repositories.

   To create a token:
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token with `repo` scope
   - Copy and export it in your terminal or add to your shell profile

## Usage Flow

This section walks you through the complete workflow from creating a new repository to managing modules.

### 1. Create Repository from Template

**Option A: Using GitHub's Template Feature**
1. Click "Use this template" on GitHub
2. Choose a name for your new repository
3. Clone your new repository:
   ```sh
   git clone <your-repo-url>
   cd <your-repo-name>
   ```

**Option B: Manual Clone**
```sh
git clone https://github.com/your-org/terraform-modules-template.git my-terraform-modules
cd my-terraform-modules
rm -rf .git
git init
git remote add origin <your-new-repo-url>
```

### 2. Configure Your Modules

**Option A: Automatic Discovery with Analyze Command**

If you have existing Terraform repositories that you want to analyze for module usage:

1. Add the repositories to analyze in `config.yaml` (can be from any GitHub organization):
   ```yaml
   version: 1.0.0
   team: your-team-name
   repositories:
     - your-org/terraform-infrastructure-main
     - your-org/terraform-platform-services
     - another-org/terraform-shared-modules
   modules: []
   ```

2. Run the analyze command:
   ```sh
   export GITHUB_TOKEN="your_github_token"
   ./scripts/tfmodules.py analyze
   ```

   This will:
   - List all available terraform modules from pbs-common organization
   - Clone and analyze each repository (from any organization)
   - Extract module usage and resources
   - Match found modules with pbs-common modules
   - Automatically populate `config.yaml` with required modules and their latest versions

**Option B: Manual Configuration**

Edit `config.yaml` to define the modules you need:

```yaml
version: 0.1.0
modules:
  - name: s3
    source: github.com/pbs-common/terraform-aws-s3-module
    version: 5.0.0
    lock: false  # Set to true to prevent auto-updates
  
  - name: lambda
    source: github.com/pbs-common/terraform-aws-lambda-module
    version: 2.3.1
    lock: false
  
  - name: vpc
    source: github.com/pbs-common/terraform-aws-vpc-module
    version: 3.1.0
    lock: true  # This module version is locked
```

**Configuration Options:**
- `version`: Semantic version of your configuration
- `modules`: List of modules to manage
  - `name`: Local directory name for the module
  - `source`: Git repository URL (without `https://`)
  - `version`: Specific git tag/version to use
  - `lock`: (optional) If `true`, prevents automatic updates during `refresh`

### 2.1. Referencing Modules in Terraform

When using these modules in your Terraform code, reference them using Git SSH URLs:

```hcl
module "ecs-service" {
  source = "git::ssh://git@github.com/pbs-common/terraform-modules-test-team.git//modules/ecs-service?ref=main"
}
```

### 3. Initialize Modules

Install all modules defined in your config:

```sh
./scripts/tfmodules.py init
```

This will:
- Validate your configuration
- Clone each module at the specified version
- Copy module files to `modules/<name>/`
- Create/update `modules.lock` with installed versions

### 4. (Optional) Refresh to Latest Versions

To update your config to use the latest available versions:

```sh
./scripts/tfmodules.py refresh
```

This will:
- Fetch latest tags from each module source
- Update `config.yaml` with latest versions (except locked modules)
- Bump the config version based on changes (major/minor/patch)
- **Note:** This only updates the config; modules aren't installed yet

### 5. Update Module Files

After modifying `config.yaml` (manually or via `refresh`), sync the module files:

```sh
./scripts/tfmodules.py update
```

This will:
- Download and install modules at the versions specified in `config.yaml`
- Update `modules.lock` with new versions
- Show a summary of version changes

### 6. Generate README

Update the README with current module information:

```sh
./scripts/tfmodules.py readme
```

This auto-generates the "Modules" section below with your current configuration.

### 7. Validate Configuration

At any time, validate your setup:

```sh
./scripts/tfmodules.py validate
```

This checks:
- Repository is a valid git repo
- All modules exist at their specified versions
- Configuration is valid

### 8. Commit and Push

Commit your changes to git:

```sh
git add config.yaml modules/ modules.lock README.md
git commit -m "Initial module configuration"
git push origin main
```

**What to commit:**
- ✅ `config.yaml` - Your module configuration
- ✅ `modules.lock` - Version lock file
- ✅ `modules/` - Actual module files (flattened)
- ✅ `README.md` - Auto-generated documentation
- ❌ `config-*.yaml` - Backup files (add to `.gitignore`)

### Complete Example Workflow

**Workflow with Automatic Discovery:**

```sh
# 1. Create from template
git clone <template-url> my-modules && cd my-modules

# 2. Install dependencies
pip install -r requirements.txt

# 3. Set up GitHub token
export GITHUB_TOKEN="your_github_token"

# 4. Add repositories to analyze in config.yaml
vim config.yaml  # Add your repositories under 'repositories:'

# 5. Analyze repos and auto-populate modules
./scripts/tfmodules.py analyze

# 6. Review the discovered modules
cat config.yaml

# 7. Initialize and install modules
./scripts/tfmodules.py init

# 8. Update README
./scripts/tfmodules.py readme

# 9. Validate everything
./scripts/tfmodules.py validate

# 10. Commit and push
git add config.yaml modules/ modules.lock README.md
git commit -m "Configure Terraform modules via analysis"
git push origin main
```

**Workflow with Manual Configuration:**

```sh
# 1. Create from template
git clone <template-url> my-modules && cd my-modules

# 2. Install dependencies
pip install -r requirements.txt

# 3. Configure modules manually
vim config.yaml

# 4. Initialize and install modules
./scripts/tfmodules.py init

# 5. Update README
./scripts/tfmodules.py readme

# 6. Validate everything
./scripts/tfmodules.py validate

# 7. Commit and push
git add config.yaml modules/ modules.lock README.md
git commit -m "Configure Terraform modules"
git push origin main
```

### Ongoing Maintenance

**To re-analyze repositories and discover new modules:**
```sh
# Re-run analysis to find newly added modules
export GITHUB_TOKEN="your_github_token"
./scripts/tfmodules.py analyze

# Review changes in config.yaml
git diff config.yaml

# Apply updates
./scripts/tfmodules.py update

# Update documentation
./scripts/tfmodules.py readme

# Commit changes
git add config.yaml modules/ modules.lock README.md
git commit -m "Update modules from analysis"
git push
```

**To update modules to new versions:**
```sh
# Update config with latest versions
./scripts/tfmodules.py refresh

# Review changes in config.yaml
git diff config.yaml

# Apply updates
./scripts/tfmodules.py update

# Update documentation
./scripts/tfmodules.py readme

# Commit changes
git add config.yaml modules/ modules.lock README.md
git commit -m "Update modules to latest versions"
git push
```

**To add a new module:**
1. Add entry to `config.yaml`
2. Run `./scripts/tfmodules.py init`
3. Run `./scripts/tfmodules.py readme`
4. Commit changes

**To remove a module:**
1. Remove entry from `config.yaml`
2. Run `./scripts/tfmodules.py init` (cleans up lock file)
3. Manually remove `modules/<module-name>/` directory
4. Run `./scripts/tfmodules.py readme`
5. Commit changes

## CLI Commands

All commands are run via:

```sh
./scripts/tfmodules.py <command>
```

### `validate`

**Description:**  
Validate the current repository and configuration file. Checks that the repository is a valid git repo and that all modules and versions in `config.yaml` exist in their respective sources.

**Usage:**  
```sh
./scripts/tfmodules.py validate
```

---

### `analyze`

**Description:**  
Analyze Terraform repositories to discover module usage and automatically update `config.yaml` with required modules from pbs-common organization. This command:
- Fetches all `terraform-*-module` repositories from pbs-common organization
- Analyzes repositories specified in `config.yaml` (can be from any GitHub organization)
- Extracts Terraform module sources and resource types used
- Matches used modules with available pbs-common modules
- Updates `config.yaml` with the latest versions of matched modules

**Prerequisites:**
- Set `GITHUB_TOKEN` environment variable with a valid GitHub personal access token
- Add a `repositories` list to `config.yaml` with repos to analyze

**Configuration:**  
Add repositories to analyze in `config.yaml` (repositories can be from any organization):
```yaml
version: 1.0.0
team: your-team-name
repositories:
  - your-org/terraform-infrastructure
  - your-org/terraform-services
  - another-org/platform-terraform
modules: []
```

**Usage:**  
```sh
export GITHUB_TOKEN="your_github_token_here"
./scripts/tfmodules.py analyze
```

**What happens:**
1. Lists all available terraform modules from pbs-common organization with their latest versions
2. Clones and analyzes each repository in the `repositories` list
3. Extracts module sources and resources from all `.tf` files
4. Matches found modules with pbs-common modules
5. Creates a timestamped backup of `config.yaml`
6. Updates `config.yaml` with unique module entries (respects locked modules)
7. Displays summary of modules added/updated

**Notes:**
- If no repositories are specified, the command lists all available pbs-common modules and adds them to config
- Locked modules (with `lock: true`) are not updated
- A backup is automatically created before making changes

---

### `init`

**Description:**  
Initialize the repository by adding all modules at the specified versions. Creates the modules directory, installs modules, and updates the lock file.

**Usage:**  
```sh
./scripts/tfmodules.py init
```

---

### `update`

**Description:**  
Update all modules to the versions specified in `config.yaml`. Re-clones modules at the specified versions and updates the lock file.

**Usage:**  
```sh
./scripts/tfmodules.py update
```

---

### `refresh`

**Description:**  
Refresh the `config.yaml` to use the latest available versions for each module. Bumps the config version based on the type of updates (major/minor/patch). Locked modules are not updated.

**Usage:**  
```sh
./scripts/tfmodules.py refresh
```

---

### `readme`

**Description:**  
Generate or update `README.md` with module information from `config.yaml`. The "Modules" section below is automatically managed by this command.

**Usage:**  
```sh
./scripts/tfmodules.py readme
```

---

### `cleanup`

**Description:**  
Cleanup all modules, remove the lock file, backup current `config.yaml`, and reset `config.yaml` to `config_empty.yaml`. **Use with caution!**

**Usage:**  
```sh
./scripts/tfmodules.py cleanup
```

---

## Modules
<!--
This section is automatically updated by running:

    ./scripts/tfmodules.py readme

Do not edit manually.
-->
- **app-mesh** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-app-mesh-module.git`
- **cloudfront** `4.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudfront-module.git`
- **cloudwatch-alarms** `1.1.0`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudwatch-alarms-module.git`
- **cloudwatch-event-rule** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudwatch-event-rule-module.git`
- **dynamodb** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-dynamodb-module.git`
- **ecr** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-ecr-module.git`
- **ecs-cluster** `2.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-cluster-module.git`
- **ecs-service** `11.0.0`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-service-module.git`
- **ecs-task-definition** `3.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-task-definition-module.git`
- **efs** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-efs-module.git`
- **elasticache-memcached** `2.1.0`  
  Source: `git@github.com:pbs-common/terraform-aws-elasticache-memcached-module.git`
- **iam-role** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-iam-role-module.git`
- **lambda** `2.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-lambda-module.git`
- **lambda-permission** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-lambda-permission-module.git`
- **namespace** `0.1.26`  
  Source: `git@github.com:pbs-common/terraform-aws-namespace-module.git`
- **rds** `2.3.0`  
  Source: `git@github.com:pbs-common/terraform-aws-rds-module.git`
- **s3** `5.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-s3-module.git`
- **sg-rule** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-sg-rule-module.git`
- **sns-topic** `1.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-sns-topic-module.git`
- **sns-topic-subscription** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-sns-topic-subscription-module.git`
- **synthetics** `3.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-synthetics-module.git`
- **virtual-gateway** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-gateway-module.git`
- **virtual-router** `0.0.29`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-router-module.git`
- **virtual-service** `0.0.30`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-service-module.git`

- **app-mesh** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-app-mesh-module.git`
- **cloudfront** `4.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudfront-module.git`
- **cloudwatch-alarms** `1.1.0`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudwatch-alarms-module.git`
- **cloudwatch-event-rule** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-cloudwatch-event-rule-module.git`
- **dynamodb** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-dynamodb-module.git`
- **ecr** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-ecr-module.git`
- **ecs-cluster** `2.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-cluster-module.git`
- **ecs-service** `11.0.0`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-service-module.git`
- **ecs-task-definition** `3.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-ecs-task-definition-module.git`
- **efs** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-efs-module.git`
- **elasticache-memcached** `2.1.0`  
  Source: `git@github.com:pbs-common/terraform-aws-elasticache-memcached-module.git`
- **iam-role** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-iam-role-module.git`
- **lambda** `2.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-lambda-module.git`
- **lambda-permission** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-lambda-permission-module.git`
- **namespace** `0.1.26`  
  Source: `git@github.com:pbs-common/terraform-aws-namespace-module.git`
- **rds** `2.3.0`  
  Source: `git@github.com:pbs-common/terraform-aws-rds-module.git`
- **s3** `5.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-s3-module.git`
- **sg-rule** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-sg-rule-module.git`
- **sns-topic** `1.0.2`  
  Source: `git@github.com:pbs-common/terraform-aws-sns-topic-module.git`
- **sns-topic-subscription** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-sns-topic-subscription-module.git`
- **synthetics** `3.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-synthetics-module.git`
- **virtual-gateway** `1.0.1`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-gateway-module.git`
- **virtual-router** `0.0.29`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-router-module.git`
- **virtual-service** `0.0.30`  
  Source: `git@github.com:pbs-common/terraform-aws-virtual-service-module.git`

