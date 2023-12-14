#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

TMP_DIR=/tmp/greptime-chart-tmp
CHART_DIRS=(charts)

function copy_original_files() {
    rm -rf "${TMP_DIR}"
    mkdir -p "${TMP_DIR}"
    for dir in "${CHART_DIRS[@]}"; do
        cp -r "${dir}" "${TMP_DIR}"/"${dir}"
    done
}

function run_update_docs() {
    make update-docs
}

function check_diff() {
    for dir in "${CHART_DIRS[@]}"; do
        diff -Naupr "${dir}" "${TMP_DIR}"/"${dir}" || (echo \'"${dir}"/\' is out of date, please run \'make update-docs\' && exit 1)
    done
}

copy_original_files
run_update_docs
check_diff
