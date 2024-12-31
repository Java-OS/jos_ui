#!/bin/bash

set -x

WORK_DIR=$(dirname "$0")
cd "${WORK_DIR}" || exit

flatc --no-emit-min-max-enum-values -d message_buffer.fbs
# shellcheck disable=SC2035
mv *.dart ../lib/message_buffer.dart
