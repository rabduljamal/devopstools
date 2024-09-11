## starting

```bash
docker compose up -d
docker exec -it postgres psql -U vault -d vault
```

paste sql schema

```sql
CREATE TABLE vault_kv_store (
    parent_path TEXT COLLATE "C" DEFAULT ''::text,
    path        TEXT COLLATE "C",
    key         TEXT COLLATE "C",
    value       BYTEA,
    PRIMARY KEY (path, key)
);
```

`\q` to quit

restart vault

```bash
docker restart vault
```

init vault

```bash
docker exec -it vault vault operator init
```

copy token

```bash
echo "<UNSEAL_KEY_1>" > vault/unseal/unseal_key_1
echo "<UNSEAL_KEY_2>" > vault/unseal/unseal_key_2
echo "<UNSEAL_KEY_3>" > vault/unseal/unseal_key_3
```

change docker compose file to

```bash
entrypoint: ["/vault/entrypoint.sh"]
#entrypoint: ["sh", "-c", "vault server -config=/vault/config/vault.hcl"]
```

restart docker compose all

```bash
docker compose down
docker compose up -d
```
