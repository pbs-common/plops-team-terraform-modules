"""GitHub API integration for fetching modules and versions."""

import re
import sys
from typing import Dict, List, Optional

import requests
import semver

from .constants import GITHUB_API_URL, GITHUB_REST_API, GITHUB_TOKEN, ORG_NAME, console
from .utils import is_valid_semver


def get_github_headers() -> Dict[str, str]:
    """Get headers for GitHub API requests."""
    if not GITHUB_TOKEN:
        console.print("[red]Error: GITHUB_TOKEN environment variable not set[/red]")
        console.print("[yellow]Please set it with: export GITHUB_TOKEN='your_token_here'[/yellow]")
        sys.exit(1)
    return {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Content-Type": "application/json",
    }


def get_pbs_common_terraform_modules() -> List[Dict]:
    """
    Get all terraform-*-module repositories from pbs-common organization.
    Returns list of dicts with 'name', 'url', 'ssh_url', and 'latest_version'.
    """
    query = """
    query ($org: String!, $cursor: String) {
      organization(login: $org) {
        repositories(first: 100, after: $cursor) {
          nodes {
            name
            url
            sshUrl
            isArchived
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
    """

    cursor = None
    modules = []
    headers = get_github_headers()

    while True:
        response = requests.post(
            GITHUB_API_URL,
            headers=headers,
            json={
                "query": query,
                "variables": {
                    "org": ORG_NAME,
                    "cursor": cursor,
                },
            },
            timeout=30
        )
        response.raise_for_status()
        data = response.json()

        # Check for GraphQL errors
        if "errors" in data:
            error_messages = "; ".join(e.get("message", "Unknown error") for e in data["errors"])
            raise RuntimeError(f"GitHub GraphQL error: {error_messages}")

        if "data" not in data or data["data"] is None:
            raise RuntimeError("Unexpected empty response from GitHub API")

        repos = data["data"]["organization"]["repositories"]["nodes"]
        page_info = data["data"]["organization"]["repositories"]["pageInfo"]

        for repo in repos:
            # Match terraform-*-module pattern
            if re.match(r"terraform-.*-module", repo["name"]) and not repo["isArchived"]:
                module_info = {
                    "name": repo["name"],
                    "url": repo["url"],
                    "ssh_url": repo["sshUrl"],
                    "latest_version": None
                }
                modules.append(module_info)

        if not page_info["hasNextPage"]:
            break

        cursor = page_info["endCursor"]

    return modules


def get_latest_module_version_from_github(repo_name: str) -> Optional[str]:
    """Get the latest semver tag from a repository using GitHub API."""
    url = f"{GITHUB_REST_API}/repos/{ORG_NAME}/{repo_name}/tags"
    headers = get_github_headers()

    try:
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()

        tags = response.json()
        valid_versions = []

        for tag in tags:
            tag_name = tag["name"]
            # Remove 'v' prefix if present
            version_str = tag_name.lstrip('v')
            if is_valid_semver(version_str):
                valid_versions.append(semver.VersionInfo.parse(version_str))

        if not valid_versions:
            return None

        # Return the latest version
        latest = max(valid_versions)
        return str(latest)
    except Exception as e:
        console.print(f"[yellow]Warning: Could not fetch version for {repo_name}: {e}[/yellow]")
        return None
