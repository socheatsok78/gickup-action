#!/bin/sh -l
set -e

INPUT_DEBUG=${INPUT_DEBUG:-false}
INPUT_DRYRUN=${INPUT_DRYRUN:-false}

echo "Starting gickup..."

if [ "$INPUT_DEBUG" = "true" ]; then
    set -- "$@" --debug
    echo " - Debug mode enabled"
fi
if [ "$INPUT_DRYRUN" = "true" ]; then
    set -- "$@" --dryrun
    echo " - Dry-run mode enabled"
fi

/usr/bin/gickup "$@"
