terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  # no config_context — uses the current-context set by KUBECONFIG
}

module "app" {
  source = "../../modules/app"

  app_name       = "demo-app"
  namespace      = "demo-dev"
  image          = "nginxdemos/hello:latest" # swap for your own image
  container_port = 80
  health_path    = "/"
  ingress_host   = "demo.local"
  replica_count  = 2
  cpu_request    = "100m"
  memory_request = "128Mi"
  cpu_limit      = "250m"
  memory_limit   = "256Mi"
}

output "namespace" {
  value = module.app.namespace
}
