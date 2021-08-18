#!/bin/bash

# disable warning about 'mkdir -m -p'
# shellcheck disable=SC2174

set -Eeuxo pipefail

printf "\n\t🐋 Runner user 🐋\t\n"
su - "${RUNNER}" -c id

sed -i /etc/environment -e "s/USER=root/USER=${RUNNER}/g"

echo "RUNNER_TEMP=/home/${RUNNER}/work/_temp" | tee -a /etc/environment
mkdir -p "/home/${RUNNER}/work/_temp"
chown -R "${RUNNER}":"${RUNNER}" "/home/${RUNNER}/work"

mkdir -m 0700 -p "/home/${RUNNER}/.ssh"
ssh-keyscan -t rsa github.com >>"/home/${RUNNER}/.ssh/known_hosts"
ssh-keyscan -t rsa ssh.dev.azure.com >>"/home/${RUNNER}/.ssh/known_hosts"

chmod 644 "/home/${RUNNER}/.ssh/known_hosts"
chown -R "${RUNNER}":"${RUNNER}" "/home/${RUNNER}/.ssh"

# shellcheck disable=SC1091
. /etc/environment

# Word is of the form "A"B"C" (B indicated). Did you mean "ABC" or "A\"B\"C"?shellcheck(SC2140)
# shellcheck disable=SC2140
chown -R "${RUNNER}":"${RUNNER}" "$AGENT_TOOLSDIRECTORY"

printf "\n\t🐋 Finished building 🐋\t\n"
