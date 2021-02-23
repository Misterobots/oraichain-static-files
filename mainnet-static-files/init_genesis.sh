#!/bin/sh
#set -o errexit -o nounset -o pipefail

echo -n "Enter passphrase:"
read -s PASSWORD

USER=${USER:-tupt}
MONIKER=${MONIKER:-node001}

rm -rf "$PWD"/.oraid

oraid init --chain-id Oraichain "$MONIKER"

(echo "$PASSWORD"; echo "$PASSWORD") | oraid keys add $USER 2>&1 | tee account.txt

# hardcode the validator account for this instance
(echo "$PASSWORD") | oraid add-genesis-account $USER "100000000000000orai"

# submit a genesis validator tx
## Workraround for https://github.com/cosmos/cosmos-sdk/issues/8251
(echo "$PASSWORD"; echo "$PASSWORD") | oraid gentx $USER "$AMOUNT" --chain-id=Oraichain -y

# oraid collect-gentxs

# oraid validate-genesis

echo "The genesis initiation process has finished ..."
