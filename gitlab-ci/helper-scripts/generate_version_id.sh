#!/bin/sh
# Generate version number ID.

# Fail on error.
set -e

# Prerequisites.
if ! command -v git >/dev/null 2>&1 ; then
    echo "git command not found."
    exit 1
fi

# Version number initial configs ( eg. 0.1.0 )
# Final version number will be like - v0.1.0-1
MAJOR_NUMBER="${MAJOR_NUMBER:-0}"
MINOR_NUMBER="${MINOR_NUMBER:-1}"
PATCH_NUMBER="${PATCH_NUMBER:-0}"

# Check that we should always have Prerequisites configs.
if [ -z "${MAJOR_NUMBER}" ] || [ -z "${MINOR_NUMBER}" ] || [ -z "${PATCH_NUMBER}" ] ; then
    echo "Version Prerequisites not matched."
    echo "Unable to generate version ID."
    exit 1
fi

# Delete all local tags and then pull all tags.
git tag 2>/dev/null | xargs git tag -d >/dev/null 2>&1
git fetch --tags 2>/dev/null

# Find latest tag and then generate version ID.
LATEST_TAG=$(git tag -l v"${MAJOR_NUMBER}"."${MINOR_NUMBER}"."${PATCH_NUMBER}"-* 2>/dev/null | \
	sort -V 2>/dev/null | tail -1 2>/dev/null)
if [ -z "${LATEST_TAG}" ] ; then
    NEXT_VERSION_ID="v${MAJOR_NUMBER}.${MINOR_NUMBER}.${PATCH_NUMBER}-1"
    echo "${NEXT_VERSION_ID}"
    exit 0
fi

# Generate Version ID.
LATEST_VERSION_ID=$(($(echo "${LATEST_TAG}" | awk -F"-" '{print $2}' 2>/dev/null) + 1))
NEXT_VERSION_ID="v${MAJOR_NUMBER}.${MINOR_NUMBER}.${PATCH_NUMBER}-${LATEST_VERSION_ID}"
echo "${NEXT_VERSION_ID}"
exit 0
