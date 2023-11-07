#!/bin/sh
# Release version number ID.
# Create a tag during CI pipeline build.

# Fail on error.
set -e

# Prerequisites.
RELEASE_VERSION_ID="${RELEASE_VERSION_ID:-${1}}"
PROJECT_ACCESS_TOKEN="${PROJECT_ACCESS_TOKEN:-${2}}"

# Check for Version number ID.
if [ -z "${RELEASE_VERSION_ID}" ] ; then
    echo "Release version number ID is not provided."
    exit 1
fi

# Check that we should always have PROJECT_ACCESS_TOKEN provided.
if [ -z "${PROJECT_ACCESS_TOKEN}" ] ; then
    echo "Project Access Token is not provided."
    exit 1
fi

# Prerequisites related to CI Pipeline.
# Prevent execution of script outside of CI Pipeline.
if [ -z "${CI_PROJECT_ID}" ] || [ -z "${CI_COMMIT_SHA}" ] || [ -z "${CI_SERVER_URL}" ] ; then
    echo "Looks like not getting executed from CI Pipeline."
    exit 1
fi

# Install some tools if not present on system.
if ! command -v curl >/dev/null 2>&1 ; then
    echo "curl command not found."
    exit 1
fi

# Create Tag,
curl -X POST --silent --show-error --fail  \
	"${CI_SERVER_URL}/api/v4/projects/${CI_PROJECT_ID}/repository/tags?tag_name=${RELEASE_VERSION_ID}&ref=${CI_COMMIT_SHA}&private_token=${PROJECT_ACCESS_TOKEN}"
exit "$?"
