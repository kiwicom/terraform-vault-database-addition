variable "name" {
  type = string
}

variable "base_path" {
  type = string
}

variable "location" {
  type = string
}

variable "default_ttl" {
  # 10h
  default = "36000"
}

variable "max_ttl" {
  # 20h
  default = "72000"
}

variable "database_type" {
  type        = string
  description = "Supports postgresql or cassandra"
}

variable "admin_username" {}
variable "admin_password" {}
variable "address" {}

variable "roles_postgresql" {
  default = {
    sudo = [
      "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
      "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
    ],

    rw = [
      "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
      "GRANT SELECT,UPDATE,INSERT,DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
    ],

    ro = [
      "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
      "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
    ],
  }
}

variable "additional_roles" {
  default = {}
}

# outputs
output "roles_policies" {
  value = zipmap(keys(local.roles), [for policy in vault_policy.policy : policy.name])
}

output "roles_paths" {
  value = zipmap(keys(local.roles), [for policy in vault_policy.policy : policy.name])
}
