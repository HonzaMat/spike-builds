<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: MIT
-->

= Examples: Getting release information via GitHub REST API

If you need to automatically fetch the latest released Spike binaries (or get a list
of all releases) in your scripts or CI jobs, you can use the Github's REST API.

There are two endpoints that are of interest:

- Information about the latest release: https://api.github.com/repos/HonzaMat/spike-builds/releases/latest
- Information about all releases: https://api.github.com/repos/HonzaMat/spike-builds/releases

More details can be found in the [GitHub REST API documentation](https://docs.github.com/en/rest/releases/releases?apiVersion=2026-03-10).

Here are few quick examples how you can query that API.


== Examples using curl + jq

```bash
# Get the latest release date:

$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases/latest \
    | jq -r .tag_name
20261108

# Get the download URL of the latest release:

$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases/latest \
    | jq -r .assets[0].browser_download_url
https://github.com/HonzaMat/spike-builds/releases/download/20261108/riscv-isa-sim-20261108-linux-x86-64.tar.gz

# Get the dates of all published releases:

$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases \
    | jq -r .[].tag_name
20261108
20261101
20261025
...
```

== Example using Python

```python
from pprint import pprint

import requests

# Get information about all published releases:
url = "https://api.github.com/repos/HonzaMat/spike-builds/releases"
headers = {
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2026-03-10",
}

response = requests.get(url, headers=headers, allow_redirects=True)
response.raise_for_status()

data = response.json()
all_releases = [
    {"date": item["tag_name"], "url": item["assets"][0]["browser_download_url"]}
    for item in data
]

pprint(all_releases)

# [{'date': '20261108',
#   'url': 'https://github.com/HonzaMat/spike-builds/releases/download/20261108/riscv-isa-sim-20261108-linux-x86-64.tar.gz'},
#  {'date': '20261101',
#   'url': 'https://github.com/HonzaMat/spike-builds/releases/download/20261023/riscv-isa-sim-20261101-linux-x86-64.tar.gz'},
#  ...
#  ...
# ]

```
