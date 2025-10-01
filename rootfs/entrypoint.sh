#!/bin/bash
set -eou pipefail

# GitHub Actions Environment Variables
GITHUB_RUN_ID=${GITHUB_RUN_ID:-"0"}

# Default inputs
INPUT_CONFIG=${INPUT_CONFIG:-".gickup/gickup.yml"}
INPUT_DEBUG=${INPUT_DEBUG:-"false"}
INPUT_DRYRUN=${INPUT_DRYRUN:-"false"}
INPUT_GITHUB=${INPUT_GITHUB:-"{}"}
INPUT_ENV=${INPUT_ENV:-"{}"}
INPUT_VARS=${INPUT_VARS:-"{}"}
INPUT_SECRETS=${INPUT_SECRETS:-"{}"}

# Prepare environment
GICKUP_ACTION_WORKSPACE="/tmp/.gickup-${GITHUB_RUN_ID}"
echo "::group::Prepare environment..."
(set -x; mkdir -p "${GICKUP_ACTION_WORKSPACE}")
echo "::endgroup::"

# Cleanup trap
cleanup() {
    echo "::group::Cleanup files..."
    (set -x; rm -rf "${GICKUP_ACTION_WORKSPACE}")
    echo "::endgroup::"
}
trap cleanup EXIT SIGINT SIGTERM

# Store environment variables, vars, and secrets in temporary files
echo "${INPUT_GITHUB}"  > "${GICKUP_ACTION_WORKSPACE}/github.json"
echo "${INPUT_ENV}"     > "${GICKUP_ACTION_WORKSPACE}/env.json"
echo "${INPUT_VARS}"    > "${GICKUP_ACTION_WORKSPACE}/vars.json"
echo "${INPUT_SECRETS}" > "${GICKUP_ACTION_WORKSPACE}/secrets.json"

# Generate gomplate configuration
export GOMPLATE_CONFIG="${GICKUP_ACTION_WORKSPACE}/gomplate.yaml"
export GOMPLATE_LOG_FORMAT=${GOMPLATE_LOG_FORMAT:-logfmt}

echo "::group::Prepare gickup configuration..."
cat <<EOT > "${GOMPLATE_CONFIG}"
leftDelim: '\${{'
rightDelim: '}}'
inputDir: $(dirname "/github/workspace/${INPUT_CONFIG}")
outputDir: $(dirname "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}")
context:
  github:
    url: file://${GICKUP_ACTION_WORKSPACE}/github.json
  env:
    url: file://${GICKUP_ACTION_WORKSPACE}/env.json
  vars:
    url: file://${GICKUP_ACTION_WORKSPACE}/vars.json
  secrets:
    url: file://${GICKUP_ACTION_WORKSPACE}/secrets.json
EOT

gomplate --verbose
echo "::endgroup::"

# Prepare gickup command line arguments
if [[ "${INPUT_DEBUG:-false}" == "true" ]]; then
    set -- "$@" --debug
fi
if [[ "${INPUT_DRYRUN:-false}" == "true" ]]; then
    set -- "$@" --dryrun
fi

echo "Running gickup with arguments: $*"

if [ ! -f "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '${GICKUP_ACTION_WORKSPACE}'"
    exit 1
else
    echo "Using configuration file: ${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}"
    set -- "$@" "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}"
fi

# Run gickup with the provided arguments
gickup "$@"
