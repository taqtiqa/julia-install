#!/usr/bin/env bash

. "${julia_install_dir}/versions.sh"
. "${julia_install_dir}/signatures.sh"

julia_versions_user=jlenv
julia_versions_url="https://raw.githubusercontent.com/${julia_versions_user}/julia-versions/master"
julia_versions_files=({versions,stable}.txt signatures.{gpg,ed})

#
# Determines if the julia-versions files are missing for a julia.
#
function are_julia_versions_missing()
{
	local dir="$julia_install_cache_dir/$julia"

	if [[ ! -d "$dir" ]]; then
		return 0
	fi

	local file

	for file in "${julia_versions_files[@]}"; do
		if [[ ! -f "$dir/$file" ]]; then
			return 0
		fi
	done

	return 1
}

#
# Downloads a file from the julia-versions repository.
#
function download_julia_versions_file()
{
	local julia="$1"
	local julia_name="${julia}"

	local file="$2"
	local dir="$julia_install_cache_dir/$julia"
	local dest="$dir/$file"

	local url="$julia_versions_url/$julia_name/$file"

	if [[ -f "$dest" ]]; then rm "$dest"      || return $?
	else                      mkdir -p "$dir" || return $?
	fi

	local ret

	download "$url" "$dest" >/dev/null 2>&1
	ret=$?

	if (( ret > 0 )); then
		error "Failed to download $url to $dest!"
		return $ret
	fi
}

#
# Downloads all julia-versions files for a julia.
#
function download_julia_versions()
{
	local julia="$1"

	for file in "${julia_versions_files[@]}"; do
		download_julia_versions_file "$julia" "$file" || return $?
	done
}

#
# Lists all current stable versions.
#
function stable_julia_versions()
{
	local julia="$1"

	cat "$julia_install_cache_dir/$julia/stable.txt"
}

#
# Finds the closest matching stable version.
#
function latest_julia_version()
{
	local julia="$1"
	local version="$2"

	latest_version "$julia_install_cache_dir/$julia/stable.txt" "$version"
}

#
# Determines if the given version is a known version.
#
function is_known_julia_version()
{
	local julia="$1"
	local version="$2"

	is_known_version "$julia_install_cache_dir/$julia/versions.txt" "$version"
}

#
# Looks up a checksum for $julia_archive.
#
function julia_checksum_for()
{
	local julia="$1"
	local algorithm="$2"
	local archive="$3"
	local checksums="checksums.$algorithm"

	lookup_checksum "$julia_install_cache_dir/$julia/$checksums" "$archive"
}

#
# Looks up a signature number for $julia_archive.
#
function julia_signature_for()
{
	local julia="$1"
	local algorithm="$2"
	local archive="$3"
	local signatures="signatures.$algorithm"

	lookup_signature_id "$julia_install_cache_dir/$julia/$signatures" "$archive"
}

#
# Resolves a short-hand julia version to a fully qualified version.
#
function lookup_julia_version()
{
	local julia="$1"
	local version="$2"

	if is_known_julia_version "$julia" "$version"; then
		echo -n "$version"
	else
		latest_julia_version "$julia" "$version"
	fi
}
