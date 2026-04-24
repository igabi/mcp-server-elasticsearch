#!/usr/bin/env bash
# Copyright Elasticsearch B.V. and contributors
# SPDX-License-Identifier: Apache-2.0
#
# Bump only the [package] version in Cargo.toml. A naive `sed` on every
# `^version =` line also overwrites dependency versions (e.g. rmcp) and
# breaks `cargo check` during semantic-release.

set -euo pipefail
ver="${1:?usage: $0 <semver>}"

tmp="$(mktemp)"
# First top-level "version = ..." is the [package] version (before deps).
awk -v v="$ver" '
  /^version = / && !seen {
    sub(/^version = "[^"]*"/, "version = \"" v "\"")
    seen=1
  }
  { print }
' Cargo.toml >"$tmp"
mv "$tmp" Cargo.toml
