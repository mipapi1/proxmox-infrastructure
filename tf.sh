#!/bin/bash
# Terraform wrapper: pulls the Proxmox API token from Vault into the environment
# so it never lands in tfvars or state (provider arguments aren't persisted).
#
# Usage: ./tf.sh plan | apply | destroy | <any terraform subcommand> [args]
set -euo pipefail

export VAULT_ADDR="${VAULT_ADDR:-https://vault.agathla.com}"
VAULT_SECRET_PATH="secret/proxmox/terraform"
VAR_FILE="vars/production.tfvars"

cd "$(dirname "$0")"

# Reuse the existing Vault login if it can still read the secret; otherwise log in.
if ! vault kv get -field=api-token "$VAULT_SECRET_PATH" >/dev/null 2>&1; then
  read -p "Vault Username: " VAULT_USER
  vault login -method=userpass -no-print username="$VAULT_USER"
fi

TF_VAR_proxmox_api_token_id="$(vault kv get -field=api-token "$VAULT_SECRET_PATH")"
export TF_VAR_proxmox_api_token_id

# Only subcommands that accept -var-file get it.
case "${1:-}" in
  plan|apply|destroy|import|refresh|console)
    exec terraform "$1" -var-file="$VAR_FILE" "${@:2}"
    ;;
  *)
    exec terraform "$@"
    ;;
esac
