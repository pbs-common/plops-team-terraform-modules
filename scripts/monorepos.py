import os
import requests

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
if not GITHUB_TOKEN:
    raise RuntimeError("GITHUB_TOKEN environment variable not set")
ORG_NAME = "pbs-common"
TEMPLATE_NAME = "terraform-modules-template"

GITHUB_API_URL = "https://api.github.com/graphql"

HEADERS = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Content-Type": "application/json",
}

QUERY = """
query ($org: String!, $cursor: String) {
  organization(login: $org) {
    repositories(first: 100, after: $cursor) {
      nodes {
        name
        nameWithOwner
        templateRepository {
          name
          nameWithOwner
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
"""


def repos_created_from_template():
    cursor = None
    matches = []

    while True:
        response = requests.post(
            GITHUB_API_URL,
            headers=HEADERS,
            json={
                "query": QUERY,
                "variables": {
                    "org": ORG_NAME,
                    "cursor": cursor,
                },
            },
        )
        response.raise_for_status()
        data = response.json()

        repos = data["data"]["organization"]["repositories"]["nodes"]
        page_info = data["data"]["organization"]["repositories"]["pageInfo"]

        for repo in repos:
            template = repo["templateRepository"]
            if not template:
                continue

            if (
                template["name"] == TEMPLATE_NAME
                or template["nameWithOwner"] == TEMPLATE_NAME
            ):
                matches.append(repo["nameWithOwner"])

        if not page_info["hasNextPage"]:
            break

        cursor = page_info["endCursor"]

    return matches


if __name__ == "__main__":
    results = repos_created_from_template()
    print("Repositories created from template:")
    for r in results:
        print(f" - {r}")