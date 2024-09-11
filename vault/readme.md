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

## Konfigurasi Vault

Buat Kebijakan untuk Jenkins
Tentukan kebijakan yang memberikan izin akses ke paths secrets yang diinginkan:

Buat file kebijakan jenkins-policy.hcl dengan konten berikut:

```hcl
# jenkins-policy.hcl
path "kv/data/secret-stage/*" {
  capabilities = ["read", "list"]
}

path "kv/data/secret-production/*" {
  capabilities = ["read", "list"]
}
```

## Terapkan kebijakan ke Vault:

```bash
vault policy write jenkins-policy jenkins-policy.hcl
```

## Buat role jenkins-role dan hubungkan dengan kebijakan jenkins-policy:

```bash
vault auth enable approle
vault write auth/approle/role/jenkins-role token_policies="jenkins-policy"
```

## Dapatkan Role ID dan Secret ID untuk digunakan di Jenkins:

```bash
vault read auth/approle/role/jenkins-role/role-id
vault write -f auth/approle/role/jenkins-role/secret-id
```

## Konfigurasi Vault

Buat Kebijakan untuk Jenkins
Tentukan kebijakan yang memberikan izin akses ke paths secrets yang diinginkan:

Buat file kebijakan jenkins-policy.hcl dengan konten berikut:

```
# jenkins-policy.hcl
path "kv/data/secret-stage/*" {
  capabilities = ["read", "list"]
}

path "kv/data/secret-production/*" {
  capabilities = ["read", "list"]
}
```

Terapkan kebijakan ke Vault:

```bash
vault policy write jenkins-policy jenkins-policy.hcl
```

Buat role jenkins-role dan hubungkan dengan kebijakan jenkins-policy:

```bash
vault auth enable approle
vault write auth/approle/role/jenkins-role token_policies="jenkins-policy"
```

Dapatkan Role ID dan Secret ID untuk digunakan di Jenkins:

```bash
vault read auth/approle/role/jenkins-role/role-id
vault write -f auth/approle/role/jenkins-role/secret-id
```

Aktifkan Metode Userpass Auth di Vault
Vault memiliki metode autentikasi bernama Userpass yang memungkinkan login menggunakan kombinasi username dan password. Anda harus mengaktifkan metode ini terlebih dahulu.

```bash
vault auth enable userpass
```

Buat Kebijakan untuk Pengguna UI
Setelah mengaktifkan metode autentikasi Userpass, kita perlu membuat kebijakan (policy) yang menentukan izin akses untuk pengguna UI. Misalnya, kita buat kebijakan yang hanya memungkinkan akses baca pada secrets tertentu.

```
# user-policy.hcl
path "kv/data/secret-stage/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/secret-production/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

Kemudian, buat kebijakan ini di Vault:

```bash
vault policy write user-policy user-policy.hcl
```

Buat User dengan Kredensial User Password
Sekarang kita akan membuat pengguna menggunakan metode Userpass dengan kebijakan yang sudah kita buat.

```bash
vault write auth/userpass/users/your-username password="your-password" policies="user-policy"
```

Gantilah your-username dengan nama pengguna yang Anda inginkan dan your-password dengan kata sandi yang Anda inginkan.
