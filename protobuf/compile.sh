#!/bin/bash

WORK_DIR=$(dirname "$0")
cd "${WORK_DIR}" || exit

SRC_DIR="."
DEST_DIR="../lib/protobuf";

rm -rfv ${DEST_DIR} 2> /dev/null
mkdir ${DEST_DIR}

protoc -I=${SRC_DIR} \
       --dart_out=${DEST_DIR} \
       ./*.proto
