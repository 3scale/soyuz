#!/bin/bash
set -eou pipefail

[[ ${DEBUG-0} -ge 2 ]] && { echo hi; set -x; }

info()  { if [[ ${DEBUG-0} -ge 0 ]]; then echo "`date -u +"%Y-%m-%dT%H:%M:%SZ"` info: $@"; fi }
debug() { if [[ ${DEBUG-0} -ge 1 ]]; then echo "`date -u +"%Y-%m-%dT%H:%M:%SZ"` debug: $@"; fi }
error() { echo "`date -u +"%Y-%m-%dT%H:%M:%SZ"` error: $@"; exit 1; }

check_environment(){
    [[ -z ${VAULT_ROLE_ID-} ]] && error "VAULT_ROLE_ID environment variable is not defined."
    [[ -z ${VAULT_SECRET_ID-} ]] && error "VAULT_SECRET_ID environment variable is not defined."
    [[ -z ${VAULT_ADDR-} ]] && error "VAULT_ADDR environment variable is not defined."
    info "Environment is OK."
}

get_vault_token(){
    VAULT_TOKEN=$( \
        vault write \
        -field=token \
        auth/approle/login \
        role_id=${VAULT_ROLE_ID} \
        secret_id=${VAULT_SECRET_ID} \
    )
    [[ -z ${VAULT_TOKEN-} ]] && error "Unable to retrieve VAULT_TOKEN."
    info "VAULT_TOKEN obtained."
}

write_vault_token(){
    echo $VAULT_TOKEN > $HOME/.vault-token
    info "VAULT_TOKEN saved to $HOME/.vault-token"
}

check_environment
get_vault_token
write_vault_token