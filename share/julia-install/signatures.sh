#!/usr/bin/env bash

. "${julia_install_dir}/setup-gpg.sh"

unset GREP_OPTIONS GREP_COLOR GREP_COLORS

# Return the signature ID number from the file:
#
function lookup_signature_id()
{
    local signatures="${1}"
    local file="${2##*/}"

    if [[ ! -f "${signatures}" ]]; then
        echo "Missing file ${signatures}."
        return 1
    fi

    local output="$(grep "  $file" "${signatures}")"
    # Return the first field
    echo -n "${output%% *}"
}

function compute_signature()
{
    local algorithm="$1"
    local program

    case "$algorithm" in
        gpg)
            setup_julia_public_key_gpg
            local output="$(verify_archive_signature_gpg)"
        ;;
        ed)
            local output="$(verify_archive_signature_ed)"
        ;;
        *)
            return 1
        ;;
    esac

    echo "${output##*$'\n'}"
}

function verify_signature()
{
    local file="$1"
    local algorithm="$2"
    local expected_signature='Julia archive VERIFIED.'

    if [[ -z "$expected_signature" ]]; then
        warn "No $algorithm signature for $file"
        return
    fi

    local actual_signature="$(compute_signature "$algorithm")"

    # Check the last line of output.
    if [[ "${actual_signature##*$'\n'}" != "$expected_signature" ]]; then
        error "Invalid $algorithm signature for $file"
        error "  expected: $expected_signature"
        error "  actual:   $actual_signature"
        return 1
    fi
}
