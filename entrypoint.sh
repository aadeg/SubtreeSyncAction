#!/bin/bash
set -e

# Generate the GitHub access token
export JWT_TOKEN=`python3 /root/src/generate_jwt.py`
ACCESS_TOKEN=python3 /root/src/get_access_token.py

SUBTREE_URL="https://x-access-token:${ACCESS_TOKEN}@github.com/${INPUT_REPO}.git"

# Check for force push to remote
PUSH_ARGS=""
if [ "$INPUT_FORCE" == "true" ]; then
  PUSH_ARGS="-f"
fi

# Resolve the downstream branch
# If not set then use the event github ref. If the ref isn't set, default to master
if [ "$INPUT_BRANCH" == "" ]; then
    if [ -z "$GITHUB_REF" ] || [ "$GITHUB_REF" == "" ]; then
        INPUT_BRANCH="master"
    else
        INPUT_BRANCH="$GITHUB_REF"
    fi
fi

# Push to the downstream repo
git subtree push ${PUSH_ARGS} --prefix="${INPUT_PATH}" "${SUBTREE_URL}" "${INPUT_BRANCH}"

# Tag the subtree repository
if [ "$INPUT_TAG" != "false" ]; then
    if [ "$INPUT_TAG" != "true" ]; then
        INPUT_TAG=${GITHUB_REF}
    fi

    git tag $(basename ${INPUT_TAG})
    git push --tags
fi