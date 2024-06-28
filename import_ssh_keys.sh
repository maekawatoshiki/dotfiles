#!/usr/bin/env bash
set -eux
set -o pipefail

if ! command -v bw > /dev/null 2>&1; then
  echo "\033[0;31mBitwarden CLI is not installed!\033[0m"
  exit 1
fi

KEYS="github"

for key in ${KEYS}; do
  # Import private key
  bw list --folderid 13d85853-f926-46f1-93c4-b19c00eae822 items | jq -r '.[] | select(.name == "github") | .notes' > "${HOME}/.ssh/${key}"
  chmod 600 "${HOME}/.ssh/${key}"
  printf "\033[0;32mSSH key imported: ~/.ssh/${key}\033[0m\n"

  # Import public key
  bw list --folderid 13d85853-f926-46f1-93c4-b19c00eae822 items | jq -r '.[] | select(.name == "github") | .fields | .[] | select(.name == "pub") | .value' > "${HOME}/.ssh/${key}.pub"
  printf "\033[0;32mSSH key imported: ~/.ssh/${key}.pub\033[0m\n"
done

