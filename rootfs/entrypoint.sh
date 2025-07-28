#!/bin/bash
set -eou pipefail

export GOMPLATE_CONFIG="${GOMPLATE_CONFIG:-/etc/gomplate/gomplate.yaml}"
export GOMPLATE_LOG_FORMAT=${GOMPLATE_LOG_FORMAT:-logfmt}

if [ ! -f "${RUNNER_WORKSPACE}/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '${RUNNER_WORKSPACE}'"
    exit 1
fi

# Generate gomplate configuration
mkdir -p /etc/gomplate
mkdir -p $(dirname "${RUNNER_WORKSPACE}/${INPUT_CONFIG}")
cat <<EOT > "${GOMPLATE_CONFIG}"
leftDelim: '\${{'
rightDelim: '}}'
inputDir: $(dirname "${RUNNER_WORKSPACE}/${INPUT_CONFIG}")
outputDir: $(dirname "${RUNNER_WORKSPACE}/.gickup-action/${INPUT_CONFIG}")
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

if [ ! -f "${RUNNER_WORKSPACE}/.gickup-action/${INPUT_CONFIG}" ]; then
    echo "Error: Configuration file '${INPUT_CONFIG}' not found in '${RUNNER_WORKSPACE}'"
    exit 1
else
    echo "Using configuration file: ${RUNNER_WORKSPACE}/.gickup-action/${INPUT_CONFIG}"
    set -- "$@" "${RUNNER_WORKSPACE}/.gickup-action/${INPUT_CONFIG}"
fi

# Run gickup with the provided arguments
gickup "$@"
