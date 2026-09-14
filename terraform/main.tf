terraform {
  required_version = ">= 1.0.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}

provider "local" {}

resource "local_file" "server_config" {
  filename = "${path.module}/managed_nodes.cfg"
  content  = <<EOT
[web_servers]
server_host_ip = "127.0.0.1"
environment = "staging"
max_connections = 200
EOT

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

output "managed_file_path" {
  value = local_file.server_config.filename
}
