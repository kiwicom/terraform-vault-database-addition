# terraform-vault-database-addition

## Example

```hcl-terraform
module "my_vault_integration" {
  source        = "kiwicom/database-addition/vault"
  version       = "~> 1.0"
  database_type = "postgresql" // or cassandra

  location = "europe-west1"

  name      = "my-db-instance-name"
  db_name   = "optional-db-bame"
  base_path = "my/example/path"

  address        = "127.0.0.1"
  admin_username = "postgres"
  admin_password = "my-super-secret-password"

  additional_roles = {
    special_role = [
      "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
      "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
    ],
  }
}
```
