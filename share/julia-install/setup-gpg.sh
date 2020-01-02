#!/usr/bin/env bash

# Purpose of this script: Simple & Clean GPG use
#
# 1. Not to polute the users GPG setup with Julia keys
# 2. Avoid GPG instructions required to setup GPG with
#    Julia's keys.

# All work should be done is the XDG_CACHE_HOME for this script.
# Until XDG is implemented use "$julia_install_cache_dir/$julia"

# Called with out arguments:
# Expects that $julia_install_cache_dir/$julia are set
function verify_archive_signature_gpg(){
  keyfile="${src_dir}/juliareleases.pub"
  signaturefile="$src_dir/${julia_archive}.asc"
  archivefile="$src_dir/${julia_archive}"

  # Import the key to GPG configured in the tmporary location
  $gpgcmd --homedir "${src_dir}/.gnupg" \
  --batch \
  --status-fd 2 \
  --with-colons \
  --no-default-keyring \
  --keyring julia-install.pub \
  --import "${keyfile}"  < /dev/null
  # Fully trust imported keys - quiets GPG WARNING output
  for fpr in $(gpg --homedir "${src_dir}/.gnupg" --no-default-keyring --keyring julia-install.pub --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u)
  do
    echo -e "5\ny\n" |  gpg --homedir "${src_dir}/.gnupg" --no-default-keyring --keyring julia-install.pub --command-fd 0 --expert --edit-key $fpr trust
  done

  # Verify the archive file against the asc file
  $gpgcmd --homedir "${src_dir}/.gnupg" \
  --batch \
  --status-fd 2 \
  --with-colons \
  --no-default-keyring \
  --keyring julia-install.pub \
  --verify "${signaturefile}" "${archivefile}" < /dev/null
  if [ "${?}" -ne 0 ]; then
    echo "Julia archive NOT verified."
    return 1
  else
    echo "Julia archive VERIFIED."
    return 0
  fi
}

# $1 is the version of the Julia public key to use.
# Currently Julia is distributing its first public key for releases.
# For tests we pass in 9999 and use the latest version file name
#
#
function setup_julia_public_key_gpg()
{
  echo $julia_install_cache_dir
  #echo $src_dir

  rm -rf "${src_dir}/.gnupg"
  mkdir -m 0700 "${src_dir}/.gnupg"
  touch "${src_dir}/.gnupg/gpg.conf"
  chmod 600 "${src_dir}/.gnupg/gpg.conf"
  mkdir -p "${src_dir}/.gnupg/private-keys-v1.d"
  chmod 700 "${src_dir}/.gnupg/private-keys-v1.d"

  local sigsfile="${julia_install_cache_dir}/${julia}/signatures.${algorithm}"
	local key_id="$(lookup_signature_id ${sigsfile} ${file})"

  # Echo Julia's public key used to verify signatures.
  # allow for the fact the key will change over time
  case ${key_id} in
      1)
        file="${src_dir}/juliareleases.pub"
        gen_julia_pub_key_1 "${file}"
      ;;
      9999)
        # This is the test public key
        file="${src_dir}/juliareleases.pub"
        gen_julia_pub_key_9999 "${file}"
      ;;
      *)
        echo "Not given a recognized Julia key version number."
        exit 1
      ;;
  esac
}

# This is the public key:
# https://julialang.org/juliareleases.asc
function gen_julia_pub_key_1()
{
  cat <<EOF >>"${1}"
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

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
Lr+fAJHZvbYCQjMTkZYScgYU
=XN/B
-----END PGP PUBLIC KEY BLOCK-----
EOF
}

# This is the public key:
# ./test/factory/hello-world-pubkey.gpg
function gen_julia_pub_key_9999()
{
  cat <<EOF > "${1}"
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
fw==
=EQdm
-----END PGP PUBLIC KEY BLOCK-----
EOF
}
