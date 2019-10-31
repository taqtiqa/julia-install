#!/usr/bin/env bash

# Purpose of this script: Simple & Clean GPG use
#
# 1. Not to polute the users GPG setup with Julia keys
# 2. Avoid GPG instructions required to setup GPG with
#    Julia's keys.

if   command -v gpg > /dev/null; then gpgcmd="gpg --verify"
elif command -v gpg2 > /dev/null; then gitcmd="gpg2 --verify"
fi

# All work should be done is the XDG_CACHE_HOME for this script.
# Until XDG is implemented use "$julia_install_cache_dir/$julia"

# Called with out arguments:
# Expects that $julia_install_cache_dir/$julia are set
function verify_archive_signature(){
  dir="$julia_cache_dir"
  keyfile="${dir}/juliareleases-v1.pub"
  signaturefile="$src_dir/${julia_archive}.asc"
  archivefile="$src_dir/${julia_archive}"

  # Import the key to GPG configured in the tmporary location
  $gpgcmd --homedir "${dir}" \
  --verbose \
  --no-default-keyring \
  --secret-keyring julia-install.sec \
  --keyring julia-install.pub \
  --import "${keyfile}"

  # Verify the archive file against the asc file
  $gpgcmd --homedir "${dir}" \
  --verbose \
  --no-default-keyring \
  --secret-keyring julia-install.sec \
  --keyring julia-install.pub \
  --verify "${signaturefile}" "${archivefile}"
}

# $1 is the version of the Julia public key to use.
# Currently Julia is distributing its first public key for releases.
# For tests we pass in 9999 and use the latest version file name
#
#
function setup_julia_public_key()
{
  # Setup tmp folder
  dir="$julia_install_cache_dir/$julia"
  # Echo Julia's public key used to verify signatures.
  # allow for the fact the key will change over time
  case $1 in 
      1)
        file="${dir}/juliareleases-v1.pub"
        gen_julia_pub_key_1 "${file}"
      ;;
      9999)
        # This is the test public key 
        file="${dir}/juliareleases-v9999.pub"
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
    tee "${1}" <<EOF
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
    tee "${1}" <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
4g==
=Bb8n
-----END PGP PUBLIC KEY BLOCK-----
EOF
}
