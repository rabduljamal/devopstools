#!/bin/sh

# Wait for the Vault server to be ready
sleep 10

# Unseal the Vault server using the unseal keys
vault operator unseal $(cat /vault/unseal/unseal_key_1)
vault operator unseal $(cat /vault/unseal/unseal_key_2)
vault operator unseal $(cat /vault/unseal/unseal_key_3)