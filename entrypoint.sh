#!/bin/bash
set -e

export APP_ID=${INPUT_APP_ID}
export INSTALLATION_ID=${INPUT_INSTALLATION_ID}
export PRIVATE_KEY=${INPUT_PRIVATE_KEY}

# Generate the GitHub access token
export JWT_TOKEN=`python3 /root/src/generate_jwt.py`
ACCESS_TOKEN=`python3 /root/src/get_access_token.py`
SUBTREE_URL="https://x-access-token:${ACCESS_TOKEN}@github.com/${INPUT_REPO}.git"

# Generate sha256 of the downstream repo name
SPLIT_DIR=$(echo -n ${INPUT_REPO} | sha256sum)
SPLIT_DIR=${SPLIT_DIR::-3}

# Get subtree repository into split directory
git init --bare ${SPLIT_DIR}

# Create the subtree split branch
git subtree split --prefix=${INPUT_PATH} -b split

# Check for force push to remote
if [ $INPUT_FORCE == "true" ]; then
  PUSH_ARGS="-f"
fi

# Resolve the downstream branch
# If not set then use the event github ref. If the ref isn't set, default to master
if [ "$INPUT_BRANCH" == "" ]; then
    if [ -z $GITHUB_REF ] || [ "$GITHUB_REF" == "" ]; then
        INPUT_BRANCH="master"
    else
        INPUT_BRANCH=$GITHUB_REF
    fi
fi

# Push to the subtree directory
git push ${SPLIT_DIR} split:$INPUT_BRANCH

cd ${SPLIT_DIR}
git remote add origin ${SUBTREE_URL}
git push -u ${PUSH_ARGS} origin $INPUT_BRANCH

# Push to the downstream repo
# git subtree push ${PUSH_ARGS} --prefix="${INPUT_PATH}" "${SUBTREE_URL}" "${INPUT_BRANCH}"

# Tag the subtree repository
if [ $INPUT_TAG != "false" ]; then
    if [ $INPUT_TAG != "true" ]; then
        INPUT_TAG=${GITHUB_REF}
    fi

    git tag $(basename ${INPUT_TAG})
    git push --tags
fi