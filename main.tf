locals {
  roles = merge(var.database_type == "postgresql" ? var.roles_postgresql : {}, var.additional_roles)
}

resource "vault_mount" "database" {
  path = "kw/${var.base_path}/${var.name}"
  type = "database"
}

resource "vault_database_secret_backend_connection" "connection_postgresql" {
  count   = var.database_type == "postgresql" ? 1 : 0
  backend = vault_mount.database.path
  name    = var.name

  allowed_roles = [
    "*"
  ]

  postgresql {
    connection_url = "postgres://${var.admin_username}:${var.admin_password}@${var.address}:${var.db_port}/${var.db_name}"
  }
}

resource "vault_database_secret_backend_connection" "connection_cassandra" {
  count   = var.database_type == "cassandra" ? 1 : 0
  backend = vault_mount.database.path
  name    = var.name

  allowed_roles = [
    "*"
  ]

  cassandra {
    username = var.admin_username
    password = var.admin_password

    hosts = [
      var.address
    ]
  }
}

resource "vault_database_secret_backend_role" "role" {
  for_each            = local.roles
  backend             = vault_mount.database.path
  creation_statements = each.value
  db_name             = var.name
  name                = each.key
  default_ttl         = var.default_ttl
  max_ttl             = var.max_ttl
}

resource "vault_policy" "policy" {
  for_each = local.roles
  name     = "kw/${var.base_path}/${var.name}/creds/${each.key}"
  policy   = <<EOT
# read credentials
path "kw/${var.base_path}/${var.name}/creds/${each.key}" {
  capabilities = ["read"]
}

EOT
}
