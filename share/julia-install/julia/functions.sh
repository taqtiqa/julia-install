#!/usr/bin/env bash

julia_version_family="${julia_version:0:3}"
julia_archive="julia-$julia_version-full.tar.gz"
julia_archive_sig="julia-$julia_version-full.tar.gz.asc"
julia_dir_name="julia-$julia_version"
julia_mirror="${julia_mirror:-https://github.com/JuliaLang/julia/releases/download}"
julia_url="${julia_url:-$julia_mirror/v$julia_version/$julia_archive}"

#
# Configures Julia.
#
	# log "Configuring ${julia} $julia_version ..."
  # # Currently disabled:
	# # - must specify O=builddir to run the Julia `make configure` target
	# make configure  || return $?

function configure_julia()
{
	local configure_log="${julia_install_cache_dir}/logs/${ji_system_name_lowercase}_${ji_system_version_lowercase}_configure_${ji_build_datetime}.log"

  mkdir -p "${julia_install_cache_dir}/logs"
	log "Configuring ${julia} ${julia_version} in ${src_dir}/${julia_dir_name}/ for install folder ${julia_install_dir} ..."
    # ji_system_type=Linux
    # ji_system_name=Ubuntu
    # ji_system_version=16.04
    # ji_system_arch=x86_64

	local systm_vrsn_mk="${julia_install_dir}/${julia}/os/${ji_system_name_lowercase}/${ji_system_version_lowercase}/Make.user"
	local systm_nm_mk="${julia_install_dir}/${julia}/os/${ji_system_name_lowercase}/Make.user"
	# Note: the system-version Make.user should include the system-name Make.user
	if [ -f "${systm_vrsn_mk}" ]
	then
	  log ${systm_vrsn_mk}
    cp --force "${systm_vrsn_mk}" "${src_dir}/${julia_dir_name}/"
	elif [ -f "${systm_nm_mk}" ]
	then
	  # When no system-version Make.user, copy system-name Make.user file if exists
	  log ${systm_nm_mk}
		cp --force "${systm_nm_mk}" "${src_dir}/${julia_dir_name}/"
	else
	  echo "No Make.user file available for ${ji_system_name:-name_not_set} version ${ji_system_version:-version_not_set}.  Continuing."
  fi
}

#
# Clean Julia build and install artefacts.
#
function clean_julia()
{
	local clean_log="${julia_install_cache_dir}/logs/${ji_system_name_lowercase}_${ji_system_version_lowercase}_testall_${ji_build_datetime}.log"

  mkdir -p "${julia_install_cache_dir}/logs"
  log "Cleaning ${julia} $julia_version ..."
	make clean 2>&1 | tee ${clean_log} || return $?
}

#
# Compiles Julia.
#
function compile_julia()
{
	local build_log="${julia_install_cache_dir}/logs/${ji_system_name_lowercase}_${ji_system_version_lowercase}_build_${ji_build_datetime}.log"
	local test_log="${julia_install_cache_dir}/logs/${ji_system_name_lowercase}_${ji_system_version_lowercase}_testall_${ji_build_datetime}.log"

  mkdir -p "${julia_install_cache_dir}/logs"
	log "Compiling ${julia} ${julia_version}. Make options: ${make_opts[@]:-none} ..."
	make "${make_opts[@]}" 2>&1 | tee ${build_log} || return $?

	log "Running test suite for ${julia} ${julia_version} ..."
	make testall 2>&1 | tee ${test_log} || return $?
}

#
# Installs Julia into $install_dir
#
function install_julia()
{
	local install_log="${julia_install_cache_dir}/logs/${ji_system_name_lowercase}_${ji_system_version_lowercase}_install_${ji_build_datetime}.log"
	log "Installing ${julia} ${julia_version} ..."
  mkdir -p "${julia_install_cache_dir}/logs"
	make 2>&1 | tee ${install_log}|| return $?
}

#
# Run compiled Julia test suite
#
function post_install()
{
	return
}
