#!/bin/bash
set -eou pipefail

GICKUP_ACTION_WORKSPACE="/github/workspace/.gickup-action"
GICKUP_ACTION_TEMP="/tmp/.gickup-action"

export GOMPLATE_CONFIG="${GOMPLATE_CONFIG:-/etc/gomplate/gomplate.yaml}"
export GOMPLATE_LOG_FORMAT=${GOMPLATE_LOG_FORMAT:-logfmt}

if [ ! -f "/github/workspace/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '/github/workspace'"
    exit 1
fi

echo "::group::Prepare environment..."
(set -x; mkdir -p /etc/gomplate)
(set -x; mkdir -p "${GICKUP_ACTION_TEMP}")
echo "::endgroup::"

# Store environment variables, vars, and secrets in temporary files
echo "${INPUT_GITHUB}" > "${GICKUP_ACTION_TEMP}/github.json"
echo "${INPUT_ENV}" > "${GICKUP_ACTION_TEMP}/env.json"
echo "${INPUT_VARS}" > "${GICKUP_ACTION_TEMP}/vars.json"
echo "${INPUT_SECRETS}" > "${GICKUP_ACTION_TEMP}/secrets.json"

# Generate gomplate configuration
echo "::group::Prepare gickup configuration..."
cat <<EOT > "${GOMPLATE_CONFIG}"
leftDelim: '\${{'
rightDelim: '}}'
inputDir: $(dirname "/github/workspace/${INPUT_CONFIG}")
outputDir: $(dirname "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}")
context:
  github:
    url: file://${GICKUP_ACTION_TEMP}/github.json
  env:
    url: file://${GICKUP_ACTION_TEMP}/env.json
  vars:
    url: file://${GICKUP_ACTION_TEMP}/vars.json
  secrets:
    url: file://${GICKUP_ACTION_TEMP}/secrets.json
EOT

# Generate gickup configuration using gomplate
gomplate --verbose
echo "::endgroup::"

if [[ "${INPUT_DEBUG:-false}" == "true" ]]; then
    set -- "$@" --debug
fi
if [[ "${INPUT_DRYRUN:-false}" == "true" ]]; then
    set -- "$@" --dryrun
fi

echo "Running gickup with arguments: $@"

if [ ! -f "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '/github/workspace'"
    exit 1
else
    echo "Using configuration file: ${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}"
    set -- "$@" "${GICKUP_ACTION_WORKSPACE}/${INPUT_CONFIG}"
fi

# Run gickup with the provided arguments
gickup "$@"
