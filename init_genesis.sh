#!/bin/sh
#set -o errexit -o nounset -o pipefail

pass="$1"
if [[ ! -z $pass ]] 
then   
  # 3 times send passphrase
  expect << EOF
    set timeout $timeout
    spawn $0
    
    expect {
        "*passphrase:" { send -- "$pass\r" }
    }
    expect {
        "*passphrase:" { send -- "$pass\r" }
    }
    expect {
        "*passphrase:" { send -- "$pass\r" }
    }
    expect {
        "*passphrase:" { send -- "$pass\r" }
    }
    expect eof
EOF

  exit 0
fi 

USER=${USER:-tupt}
MONIKER=${MONIKER:-node001}

rm -rf "$PWD"/.oraid

oraid init --chain-id Oraichain "$MONIKER"

if [ ! -z "$pass" ]
  then 
    echo "Enter passphrase: "  
    read pass
fi

oraid keys add $USER 2>&1 | tee account.txt

# hardcode the validator account for this instance
oraid add-genesis-account $USER "100000000000000orai"

# submit a genesis validator tx
## Workraround for https://github.com/cosmos/cosmos-sdk/issues/8251
oraid gentx $USER "$AMOUNT" --chain-id=Oraichain --amount="$AMOUNT"

oraid collect-gentxs

oraid validate-genesis

cat $PWD/.oraid/config/genesis.json | jq .app_state.auth.accounts.[0] -c > "$MONIKER"_accounts.txt
cat $PWD/.oraid/config/genesis.json | jq .app_state.genutil.gen_txs.[0] -c > "$MONIKER"_validators.txt

echo "The genesis initiation process has finished ..."


