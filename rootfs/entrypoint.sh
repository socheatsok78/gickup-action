#!/bin/bash
set -eou pipefail

export GOMPLATE_CONFIG="${GOMPLATE_CONFIG:-/etc/gomplate/gomplate.yaml}"
export GOMPLATE_LOG_FORMAT=${GOMPLATE_LOG_FORMAT:-logfmt}

if [ ! -f "/github/workspace/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '/github/workspace'"
    exit 1
fi

# Generate gomplate configuration
mkdir -p /etc/gomplate
mkdir -p $(dirname "/github/workspace/${INPUT_CONFIG}")
cat <<EOT > "${GOMPLATE_CONFIG}"
leftDelim: '\${{'
rightDelim: '}}'
inputDir: $(dirname "/github/workspace/${INPUT_CONFIG}")
outputDir: $(dirname "/github/workspace/.gickup-action/${INPUT_CONFIG}")
context:
  env:
    url: file://${RUNNER_TEMP}/env.json
  vars:
    url: file://${RUNNER_TEMP}/vars.json
  secrets:
    url: file://${RUNNER_TEMP}/secrets.json
EOT

# Generate gickup configuration using gomplate
gomplate --verbose

if [[ "${INPUT_DEBUG:-false}" == "true" ]]; then
    set -- "$@" --debug
fi
if [[ "${INPUT_DRYRUN:-false}" == "true" ]]; then
    set -- "$@" --dryrun
fi

echo "Running gickup with arguments: $@"

if [ ! -f "/github/workspace/.gickup-action/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '/github/workspace'"
    exit 1
else
    echo "Using configuration file: /github/workspace/.gickup-action/${INPUT_CONFIG}"
    set -- "$@" "/github/workspace/.gickup-action/${INPUT_CONFIG}"
fi

# Run gickup with the provided arguments
gickup "$@"

echo "::group::Debug Information"
env
echo "::endgroup::"
