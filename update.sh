#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -ne 1 ]; then
  echo "usage: $0 <domjudge commit, tag or branch>" >&2
  exit 1
fi

owner=$(jq -r .owner source.json)
repo=$(jq -r .repo source.json)

rev=$(git ls-remote "https://github.com/$owner/$repo" "$1" "refs/tags/$1^{}" "refs/heads/$1" | cut -f1 | tail -n1)
rev=${rev:-$1}
hash=$(nix-prefetch-github "$owner" "$repo" --rev "$rev" | jq -r .hash)

jq --arg rev "$rev" --arg hash "$hash" '.rev = $rev | .hash = $hash' source.json > source.json.tmp
mv source.json.tmp source.json
echo "pinned $owner/$repo to $rev"
