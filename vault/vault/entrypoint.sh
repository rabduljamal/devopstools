#!/bin/sh
vault server -config=/vault/config/vault.hcl 
apk add curl
sleep 10s

KEY1=$(cat /vault/unseal/unseal_key_1)
KEY3=$(cat /vault/unseal/unseal_key_2)
KEY2=$(cat /vault/unseal/unseal_key_3)

curl -s --insecure -H 'Content-Type: application/json' -X PUT -d '{"key":"'${KEY1}'"}' https://127.0.0.1:8200/v1/sys/unseal
curl -s --insecure -H 'Content-Type: application/json' -X PUT -d '{"key":"'${KEY2}'"}' https://127.0.0.1:8200/v1/sys/unseal
curl -s --insecure -H 'Content-Type: application/json' -X PUT -d '{"key":"'${KEY3}'"}' https://127.0.0.1:8200/v1/sys/unseal