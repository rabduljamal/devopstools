storage "postgresql" {
  connection_url = "postgres://vault:ajhd734hdkallf@postgres:5432/vault?sslmode=disable"
  table          = "vault_kv_store"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://0.0.0.0:8200"
disable_mlock = true 
ui = true

