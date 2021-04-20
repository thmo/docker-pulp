#!/usr/bin/env bash

FILE_PATH=$1
SIGNATURE_PATH="$1.asc"
ADMIN_ID=$(gpg --list-keys --with-colons --homedir ~/.gnupg/ | grep fpr: | head -n1 | cut -d: -f10)

# Create a detached signature
gpg --quiet --batch --pinentry-mode loopback --yes --homedir ~/.gnupg/ --detach-sign -u "$ADMIN_ID" \
   --armor --output "$SIGNATURE_PATH" "$FILE_PATH"

# Check the exit status
STATUS=$?
if [ $STATUS -eq 0 ]; then
      echo "{\"file\": \"$FILE_PATH\", \"signature\": \"$SIGNATURE_PATH\"}"
else
   exit $STATUS
fi
