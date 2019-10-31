#!/usr/bin/env bash

function gpg_diagnostic()
{
  rm -rf .gnupg
  mkdir -m 0700 .gnupg
  touch .gnupg/gpg.conf
  chmod 600 .gnupg/gpg.conf
  # tail -n +4 /usr/share/gnupg2/gpg-conf.skel > .gnupg/gpg.conf

  cd .gnupg
  # I removed this line since these are created if a list key is done.
  # touch .gnupg/{pub,sec}ring.gpg
  echo "---------------------------------------------------------------"
  echo "STEP 1: Check keyrings are empty"
gpg --homedir ./ \
--verbose \
--list-keys


  tee gen-key-script <<EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: User 1
Name-Comment: User 1
Name-Email: user.at.1.com
Expire-Date: 0
%no-ask-passphrase
%no-protection
%pubring ./julia-install.pub
%secring ./julia-install.sec
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

  echo "---------------------------------------------------------------"
  echo "STEP 2: Generate the GnuGP key."
  gpg --homedir ./ \
  --verbose \
  --batch \
  --gen-key gen-key-script

  echo "---------------------------------------------------------------"
  echo "STEP 3: Test the key was created, permission and trust was set."
  gpg --homedir ./ \
  --verbose \
  --list-keys

  echo "---------------------------------------------------------------"
  echo "STEP 4: Set trust to 5 for the key so we can encrypt/sign without prompt."
  echo -e "5\ny\n" |  gpg --homedir ./ \
  --verbose \
  --command-fd 0 \
  --no-default-keyring \
  --armor \
  --secret-keyring ./julia-install.sec \
  --keyring ./julia-install.pub \
  --expert \
  --edit-key user.at.1.com trust;

  echo "---------------------------------------------------------------"
  echo "STEP 5: Extract the public key in ASCII text"
  gpg --homedir ./ \
  --verbose \
  --no-default-keyring \
  --armor \
  --secret-keyring ./julia-install.sec \
  --keyring ./julia-install.pub \
  --export user.at.1.com > julia-install-pubkey.gpg

  echo "---------------------------------------------------------------"
  echo "STEP 6: Create test data."
  echo "Hello world" > hello-world.txt

  echo "---------------------------------------------------------------"
  echo "STEP 7: Test the key can sign."
  gpg --homedir ./ \
  --verbose \
  --no-default-keyring \
  --armor \
  --secret-keyring ./julia-install.sec \
  --keyring ./julia-install.pub \
  --output hello-world.txt.asc \
  --detach-sig hello-world.txt

  echo "---------------------------------------------------------------"
  echo "STEP 8: Test the key can verify."
  gpg --homedir ./ \
  --verbose \
  --no-default-keyring \
  --secret-keyring ./julia-install.sec \
  --keyring ./julia-install.pub \
  --verify hello-world.txt.asc hello-world.txt
}

gpg_diagnostic

if [ "$?" -eq 0 ]
then
  # Delete all artifacts of the test.
  # rm gen-key-script
  # rm hello-world.txt
  # rm hello-world.txt.asc
  # rm -rf .gnupg
  echo OK
else
  echo "GPG FAILED AT LEAST ONE of these steps:"
  echo "  1. Check keyrings are empty"
  echo "  2. Generate GPG key"
  echo "  3. Test key was created"
  echo "  4. Trust key"
  echo "  5. Extract public key"
  echo "  6. Create test data"
  echo "  7. Sign test data"
  echo "  8. Verify test data"
  exit 1
fi

  echo "GPG PASSED ALL of these steps:"
  echo "  1. Check keyrings are empty"
  echo "  2. Generate GPG key"
  echo "  3. Test key was created"
  echo "  4. Trust key"
  echo "  5. Extract public key"
  echo "  6. Create test data"
  echo "  7. Sign test data"
  echo "  8. Verify test data"
  exit 0
