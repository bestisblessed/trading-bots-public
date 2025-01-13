#!/bin/bash

<<SETUP_INSTRUCTIONS
Script Requirements and Setup:
1. Export your private key from your Phantom/other wallet and save as a JSON file (e.g., my-keypair.json)
2. Install Solana CLI
   instructions: https://docs.anza.xyz/cli/install
3. Set up Solana CLI with:
   solana config set --keypair /path/to/your-keypair.json
4. Install SPL Token CLI
   instructions: https://spl.solana.com/token
5. Check balance and accounts to verify correct wallet connected with:
   solana balance && spl-token accounts
SETUP_INSTRUCTIONS

empty_accounts=$(spl-token accounts | awk '$NF == "0"' | wc -l | tr -d '[:space:]')
echo "TOTAL EMPTY ACCOUNTS CLOSING: $empty_accounts"
echo ""

count=0
spl-token accounts | awk '$NF == "0"' | while read -r line; do
  count=$((count + 1))
  token_address=$(echo "$line" | awk '{print $1}')
  echo "Closing account ($count/$empty_accounts): $token_address"
  echo -n "Balance: "
  solana balance
  signature=$(spl-token close "$token_address" | grep "Signature")
  echo "$signature"
  echo
  sleep 0.5
done
