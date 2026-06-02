"""Terraform repository analysis: parsing .tf files, matching modules and resources."""

import re
import subprocess
import tempfile
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple

from .constants import RESOURCE_TO_MODULE_MAP, console


def clone_repo_for_analysis(repo_url: str, target_dir: Path) -> bool:
    """Clone a repository to target directory for analysis."""
    try:
        subprocess.run(
            ["git", "clone", "--depth", "1", "--quiet", repo_url, str(target_dir)],
            capture_output=True,
            text=True,
            check=True,
            timeout=120
        )
        return True
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
        return False


def find_terraform_files(directory: Path) -> List[Path]:
    """Find all .tf files in a directory."""
    return list(directory.rglob("*.tf"))


def extract_module_sources(tf_file: Path) -> List[Tuple[str, Optional[str]]]:
    """
    Extract module sources from a Terraform file.
    Returns list of tuples: (source, version)
    """
    modules = []

    try:
        content = tf_file.read_text(encoding='utf-8')
    except Exception:
        return modules

    # Match module blocks (handles nested braces like tags = { ... })
    module_blocks = []
    for match in re.finditer(r'module\s+"[^"]+"\s*{', content):
        start = match.end()
        depth = 1
        pos = start
        while pos < len(content) and depth > 0:
            if content[pos] == '{':
                depth += 1
            elif content[pos] == '}':
                depth -= 1
            pos += 1
        if depth == 0:
            module_blocks.append(content[start:pos - 1])

    for block_content in module_blocks:

        # Extract source
        source_match = re.search(r'source\s*=\s*"([^"]+)"', block_content)
        if not source_match:
            continue

        source = source_match.group(1)

        # Skip local and registry modules
        if source.startswith("./") or source.startswith("../"):
            continue
        if not ("github.com" in source or "git@" in source or "git::" in source):
            continue

        # Extract version if present
        version_match = re.search(r'version\s*=\s*"([^"]+)"', block_content)
        version = version_match.group(1) if version_match else None

        # Also check for ?ref= in git URLs
        if not version and "?ref=" in source:
            ref_match = re.search(r'\?ref=([^&\s]+)', source)
            if ref_match:
                version = ref_match.group(1)

        modules.append((source, version))

    return modules


def extract_resources(tf_file: Path) -> Set[str]:
    """Extract resource types from a Terraform file."""
    resources = set()

    try:
        content = tf_file.read_text(encoding='utf-8')
    except Exception:
        return resources

    # Match resource blocks
    resource_pattern = r'resource\s+"([^"]+)"\s+"[^"]+"\s*{'
    matches = re.finditer(resource_pattern, content)

    for match in matches:
        resource_type = match.group(1)
        resources.add(resource_type)

    return resources


def normalize_module_source(source: str) -> str:
    """Normalize a module source URL to a canonical form."""
    # Add https:// prefix if it starts with github.com
    if source.startswith("github.com/"):
        source = "https://" + source

    # Convert SSH to HTTPS
    source = re.sub(r'git@github\.com:', 'https://github.com/', source)

    # Remove .git suffix
    if source.endswith('.git'):
        source = source[:-4]

    # Remove query parameters
    source = re.sub(r'\?.*$', '', source)

    # Remove git:: prefix
    source = re.sub(r'^git::', '', source)

    return source


def match_module_to_pbs_common(source: str, available_modules: List[Dict]) -> Optional[Dict]:
    """
    Try to match a module source to a pbs-common module.
    Matches by module name found in the source URL, ignoring organization.
    Works across different organizations (e.g., pbs -> pbs-common).
    Returns the matched module dict or None.
    """
    normalized_source = normalize_module_source(source)

    repo_name = None
    if "//" in normalized_source:
        parts = normalized_source.split("/")
        if len(parts) >= 2:
            repo_name = parts[-1]  # Last part is the repo name

    for module in available_modules:
        module_name = module["name"]

        # Direct match by repository name (ignoring organization)
        if repo_name and repo_name == module_name:
            return module

        # Also check if the full module name is anywhere in the source
        if module_name in normalized_source:
            return module

    return None


def match_resources_to_modules(resources: Set[str], available_modules: List[Dict]) -> Dict[str, Dict]:
    """
    Match resource types to pbs-common modules using the resource mapping.
    Returns dict of module_name -> module_info for matched modules.
    """
    matched_modules = {}

    for resource_type in resources:
        # Check if this resource type has a corresponding module
        if resource_type in RESOURCE_TO_MODULE_MAP:
            module_name = RESOURCE_TO_MODULE_MAP[resource_type]

            # Skip resources without a module assignment (None)
            if module_name is None:
                continue

            # Find this module in available modules
            for module in available_modules:
                if module["name"] == module_name:
                    if module_name not in matched_modules:
                        matched_modules[module_name] = module
                    break

    return matched_modules


def analyze_repository(repo_name: str, available_modules: List[Dict]) -> Dict:
    """
    Analyze a single repository for Terraform modules and resources.
    Repository can be from any GitHub organization (format: org/repo).
    Returns dict with findings.
    """
    results = {
        "name": repo_name,
        "modules_used": [],
        "resources_used": set(),
        "matched_modules": {}
    }

    # Construct SSH URL from org/repo format
    ssh_url = f"git@github.com:{repo_name}.git"

    with tempfile.TemporaryDirectory() as tmpdir:
        clone_dir = Path(tmpdir) / repo_name.split('/')[-1]

        # Clone the repository
        if not clone_repo_for_analysis(ssh_url, clone_dir):
            console.print(f"[yellow]Warning: Could not clone {repo_name}[/yellow]")
            return results

        # Find all Terraform files
        tf_files = find_terraform_files(clone_dir)

        # Extract modules and resources
        for tf_file in tf_files:
            # Extract modules
            modules = extract_module_sources(tf_file)
            results["modules_used"].extend(modules)

            # Extract resources
            resources = extract_resources(tf_file)
            results["resources_used"].update(resources)

    # Match modules to pbs-common modules (from module sources)
    for source, version in results["modules_used"]:
        matched = match_module_to_pbs_common(source, available_modules)
        if matched and matched["name"] not in results["matched_modules"]:
            results["matched_modules"][matched["name"]] = matched

    # Match resources to pbs-common modules
    resource_matches = match_resources_to_modules(results["resources_used"], available_modules)
    for module_name, module_info in resource_matches.items():
        if module_name not in results["matched_modules"]:
            results["matched_modules"][module_name] = module_info

    return results


def clean_module_name(name: str) -> str:
    """
    Clean module name by removing common prefixes and suffixes.
    Examples:
      terraform-aws-ecs-service-module -> ecs-service
      terraform-aws-s3-module -> s3
    """
    cleaned = name

    # Remove terraform-aws- prefix
    if cleaned.startswith("terraform-aws-"):
        cleaned = cleaned[len("terraform-aws-"):]

    # Remove -module suffix
    if cleaned.endswith("-module"):
        cleaned = cleaned[:-len("-module")]

    return cleaned


def update_config_with_analyzed_modules(config: Dict, modules_to_add: List[Dict]) -> Dict:
    """
    Update config with new modules, ensuring uniqueness by name.
    Respects locked modules.
    """
    if "modules" not in config or config["modules"] is None:
        config["modules"] = []

    # Create a dict of existing module names
    existing_modules = {m["name"]: m for m in config["modules"]}

    # Add or update modules
    for module in modules_to_add:
        module_name = module["name"]
        cleaned_name = clean_module_name(module_name)

        module_entry = {
            "name": cleaned_name,
            "source": module["ssh_url"],
            "version": module["latest_version"] or "unknown",
            "lock": False
        }

        if cleaned_name in existing_modules:
            # Check if locked
            if existing_modules[cleaned_name].get("lock", False):
                console.print(f"[yellow]⚠ Skipping locked module: {cleaned_name}[/yellow]")
                continue
            else:
                # Update version
                console.print(f"[cyan]🔄 Updating module: {cleaned_name} → {module_entry['version']}[/cyan]")
                # Find and update the existing entry
                for i, m in enumerate(config["modules"]):
                    if m["name"] == cleaned_name:
                        config["modules"][i] = module_entry
                        break
        else:
            # Add new module
            console.print(f"[green]➕ Adding new module: {cleaned_name} @ {module_entry['version']}[/green]")
            config["modules"].append(module_entry)

    # Sort modules alphabetically by name
    config["modules"] = sorted(config["modules"], key=lambda m: m["name"])

    return config
