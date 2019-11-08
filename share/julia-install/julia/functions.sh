#!/usr/bin/env bash

julia_version_family="${julia_version:0:3}"
julia_archive="julia-$julia_version-full.tar.gz"
julia_archive_sig="julia-$julia_version-full.tar.gz.asc"
julia_dir_name="julia-$julia_version"
julia_mirror="${julia_mirror:-https://github.com/JuliaLang/julia/releases/download}"
julia_url="${julia_url:-$julia_mirror/v$julia_version/$julia_archive}"

# https://github.com/JuliaLang/julia/releases/download/v1.3.0-rc4/julia-1.3.0-rc4-full.tar.gz
# redirects to AWS-S3 bucket

#
# Configures Julia.
#
function configure_julia()
{

	local opt_dir

	case "$package_manager" in
		brew)
			opt_dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm)"
			;;
		port)
			opt_dir="/opt/local"
			;;
	esac

	if [[ -s configure || configure.in -nt configure ]]; then
		log "Generating ./configure script for Julia $julia_version ..."
		./configure --prefix="$install_dir" \
		    "${opt_dir:+--with-opt-dir="$opt_dir"}" \
		    "${configure_opts[@]}" || return $?
	fi
}

#
# Cleans Julia.
#
function clean_julia()
{
	log "Cleaning julia $julia_version ..."
	make clean || return $?
}

#
# Compiles Julia.
#
function compile_julia()
{
	log "Compiling julia $julia_version ..."
	make "${make_opts[@]}" || return $?
}

#
# Installs Julia into $install_dir
#
function install_julia()
{
	log "Installing julia $julia_version ..."
	make install || return $?
}
