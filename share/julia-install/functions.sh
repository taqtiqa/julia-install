#!/usr/bin/env bash

source "${julia_install_dir}/signatures.sh"

#
# Pre-install tasks
#
function pre_install()
{
	mkdir -p "$src_dir" || return $?
	mkdir -p "${install_dir%/*}" || return $?
}

#
# Install Julia Dependencies
#
function install_deps()
{
	local packages=($(fetch "$julia/dependencies" "$package_manager" || return $?))

	if (( ${#packages[@]} > 0 )); then
		log "Installing dependencies for $julia $julia_version ..."
		install_packages "${packages[@]}" || return $?
	fi

	install_optional_deps || return $?
}

#
# Install any optional dependencies.
#
function install_optional_deps() { return; }

#
# Download the Julia archive
#
function download_julia()
{
	log "Downloading $julia_url into $src_dir ..."
	download "$julia_url" "$src_dir/$julia_archive" || return $?
	download "${julia_url}.asc" "$src_dir/${julia_archive}.asc" || return $?
}

#
# Verifies the Julia archive against GPG signature.
#
function verify_julia()
{
	log "Verifying $julia_archive ..."

	local file="$src_dir/$julia_archive"

	verify_signature "$file" gpg "$julia_gpg"       || return $?
}

#
# Extract the Julia archive
#
function extract_julia()
{
	log "Extracting $julia_archive to $src_dir/$julia_dir_name ..."
	extract "$src_dir/$julia_archive" "$src_dir" || return $?
}

#
# Download any additional patches
#
function download_patches()
{
	local i patch dest

	for (( i=0; i<${#patches[@]}; i++ )) do
		patch="${patches[$i]}"

		if [[ "$patch" == "http://"* || "$patch" == "https://"* ]]; then
			dest="$src_dir/$julia_dir_name/${patch##*/}"

			log "Downloading patch $patch ..."
			download "$patch" "$dest" || return $?
			patches[$i]="$dest"
		fi
	done
}

#
# Apply any additional patches
#
function apply_patches()
{
	local patch name

	for patch in "${patches[@]}"; do
		name="${patch##*/}"

		log "Applying patch $name ..."
		patch -p1 -d "$src_dir/$julia_dir_name" < "$patch" || return $?
	done
}

#
# Place holder function for configuring Julia.
#
function configure_julia() { return; }

#
# Place holder function for cleaning Julia.
#
function clean_julia() { return; }

#
# Place holder function for compiling Julia.
#
function compile_julia() { return; }

#
# Place holder function for installing Julia.
#
function install_julia() { return; }

#
# Place holder function for post-install tasks.
#
function post_install() { return; }

#
# Remove downloaded archive and unpacked source.
#
function cleanup_source() {
	log "Removing $src_dir/$julia_archive ..."
	rm "$src_dir/$julia_archive" || return $?

	log "Removing $src_dir/$julia_dir_name ..."
	rm -rf "$src_dir/$julia_dir_name" || return $?
}
