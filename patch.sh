#!/usr/bin/env bash

# set -x # Debug
set -e
set -o pipefail
set -o nounset
set -o noclobber

TARGET="${1:?target (arg1) is not set}"
DIR="$(dirname "${BASH_SOURCE[0]}")"

function _gp {
	local -r patch="${1:?patch not set}"
	local -r target="${2:?target not set}"
	gopatch --patch="$patch" "$target" --verbose | \
		grep -v ': skipped$'
}

function _gopatch {
	local -r target="${1:?target not set}"
	local -r gopatches="${DIR}/gopatches"
	_gp "${gopatches}/main.patch"       "${target}/main.go"
	_gp "${gopatches}/types.patch"      "${target}/pkg/apis/externaldns/types.go"
	_gp "${gopatches}/types_test.patch" "${target}/pkg/apis/externaldns/types_test.go"
}

function _patch {
	local -r target="${1:?target not set}"
	local -r patches="${DIR}/patches"
	find "$patches" -type f -name '*.patch' -print0 | \
		xargs -0 cat | (cd "$target" && patch -ruN -p1)
}

function _files {
	local -r target="${1:?target not set}"
	local -r files="${DIR}/files"
	rsync -av "${files}/." "$target"
}

function _gomod {
	local -r target="${1:?target not set}"
	(
		cd "$target"
		go mod edit -require github.com/neticdk/tidydns-go@v0.0.3
		go mod tidy
	)
}

_patch "$TARGET"
_gopatch "$TARGET"
_files "$TARGET"
_gomod "$TARGET"
