#!/usr/bin/env bash

shopt -s extglob

julia_install_version="0.3.0"
julia_install_dir="${BASH_SOURCE[0]%/*}"
julia_install_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/src"

julias=(julia)
patches=()
configure_opts=()
make_opts=()

system_dir="/usr/local"

if (( UID == 0 )); then
  # The src_dir are XDG locations.
	src_dir="${julia_install_cache_dir}"
	julias_dir="/opt/julias"
else
  # The src_dir are XDG locations.
	src_dir="${julia_install_cache_dir}"
	julias_dir="$HOME/.julias"
fi

. "${julia_install_dir}/util.sh"
. "${julia_install_dir}/julia-versions.sh"
. "${julia_install_dir}/functions.sh"

#
# Prints usage information for julia-install.
#
function usage()
{
	cat <<USAGE
usage: julia-install [OPTIONS] [JULIA [VERSION] [-- CONFIGURE_OPTS ...]]

Options:

	-r, --julias-dir DIR	Directory that contains other installed Julias
	-i, --install-dir DIR	Directory to install Julia into
	    --prefix DIR        Alias for -i DIR
	    --system		Alias for -i $system_dir
	-s, --src-dir DIR	Directory to download source-code into
	-c, --cleanup		Remove archive and unpacked source-code after installation
	-j, --jobs JOBS		Number of jobs to run in parallel when compiling
	-p, --patch FILE	Patch to apply to the Julia source-code
	-M, --mirror URL	Alternate mirror to download the Julia archive from
	-u, --url URL		Alternate URL to download the Julia archive from
	-g, --gpg		Verify GPG signature of the Julia archive
	-e  --ed		Verify Minisign/Signify signature of the Julia archive
	--no-download		Use the previously downloaded Julia archive
	--no-verify		Do not verify the downloaded Julia archive
	--no-extract		Do not re-extract the downloaded Julia archive
	--no-install-deps	Do not install build dependencies before installing Julia
	--no-reinstall  	Skip installation if another Julia is detected in same location
	-L, --latest		Downloads the latest julia versions and signatures
	-V, --version		Prints the version
	-h, --help		Prints this message

Examples:

	$ julia-install julia
	$ julia-install julia 1.0
	$ julia-install julia 1.0.4
	$ julia-install julia -- --with-openssl-dir=...
	$ julia-install -M https://ftp.julialang.org/pub/julia julia
	$ julia-install -M http://www.mirrorservice.org/sites/ftp.julialang.org/pub/julia julia
	$ julia-install -p https://raw.github.com/gist/4136373/falcon-gc.diff julia 1.9.3

USAGE
}

#
# Parses a "julia-version" string.
#
function parse_julia()
{
	local arg="$1"

	case "$arg" in
		*-*)
			julia="${arg%%-*}"
			julia_version="${arg#*-}"
			;;
		*)
			julia="${arg}"
			julia_version=""
			;;
	esac

	if [[ ! "${julias[@]}" == *"$julia"* ]]; then
		error "Unknown julia: $julia"
		return 1
	fi
}

#
# Parses command-line options for julia-install.
#
function parse_options()
{
	local argv=()

	while [[ $# -gt 0 ]]; do
		case $1 in
			-r|--julias-dir)
				julias_dir="$2"
				shift 2
				;;
			-i|--install-dir|--prefix)
				install_dir="$2"
				shift 2
				;;
			--system)
				install_dir="$system_dir"
				shift 1
				;;
			-s|--src-dir)
				src_dir="$2"
				shift 2
				;;
			-c|--cleanup)
				cleanup=1
				shift
				;;
			-j|--jobs|-j+([0-9])|--jobs=+([0-9]))
				make_opts+=("$1")
				shift
				;;
			-p|--patch)
				patches+=("$2")
				shift 2
				;;
			-M|--mirror)
				julia_mirror="$2"
				shift 2
				;;
			-u|--url)
				julia_url="$2"
				shift 2
				;;
			-g|--gpg)
				julia_gpg=1
				shift
				;;
			--ed)
				julia_ed=1
				shift
				;;
			--no-download)
				no_download=1
				shift
				;;
			--no-verify)
				no_verify=1
				shift
				;;
			--no-extract)
				no_download=1
				no_verify=1
				no_extract=1
				shift
				;;
			--no-install-deps)
				no_install_deps=1
				shift
				;;
			--no-reinstall)
				no_reinstall=1
				shift
				;;
			-L|--latest)
				force_update=1
				shift
				;;
			-V|--version)
				echo "julia-install: $julia_install_version"
				exit
				;;
			-h|--help)
				usage
				exit
				;;
			--)
				shift
				configure_opts=("$@")
				break
				;;
			-*)
				echo "julia-install: unrecognized option $1" >&2
				return 1
				;;
			*)
				argv+=($1)
				shift
				;;
		esac
	done

	case ${#argv[*]} in
		2)	parse_julia "${argv[0]}-${argv[1]}" || return $? ;;
		1)	parse_julia "${argv[0]}" || return $? ;;
		0)	return 0 ;;
		*)
			echo "julia-install: too many arguments: ${argv[*]}" >&2
			usage 1>&2
			return 1
			;;
	esac
}

#
# Prints Julias supported by julia-install.
#
function list_julias()
{
	local julia

	for julia in "${julias[@]}"; do
		if [[ $force_update -eq 1 ]] ||
		   are_julia_versions_missing "$julia"; then
			log "Downloading latest $julia versions ..."
			download_julia_versions "$julia"
		fi
	done

	echo "Stable julia versions:"
	for julia in "${julias[@]}"; do
		echo "  $julia:"
		stable_julia_versions "$julia" | sed -e 's/^/    /' || return $?
	done
}

#
# Initializes variables.
#
function init()
{
	local fully_qualified_version="$(lookup_julia_version "$julia" "$julia_version")"

	if [[ -n "$fully_qualified_version" ]]; then
		julia_version="$fully_qualified_version"
	else
		warn "Unknown $julia version $julia_version. Proceeding anyways ..."
	fi

	julia_cache_dir="$julia_install_cache_dir/$julia"
	install_dir="${install_dir:-$julias_dir/$julia-$julia_version}"

	source "$julia_install_dir/functions.sh"       || return $?
	source "$julia_install_dir/$julia/functions.sh" || return $?

	julia_gpg="${julia_gpg:-$(julia_signature_for "$julia" gpg "$julia_archive")}"
}
