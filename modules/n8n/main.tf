
resource "kubernetes_namespace" "n8n" {
  metadata {
    name = "n8n"
  }
}

# ---------------------------------------------------------
# PostgreSQL
# ---------------------------------------------------------

resource "helm_release" "postgresql" {
  name       = "postgresql"
  namespace  = kubernetes_namespace.n8n.metadata[0].name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      auth = {
        username = "n8n"
        password = var.postgres_password
        database = "n8n"
      }

      primary = {
        persistence = {
          enabled = true
          size    = "10Gi"
        }
      }
    })
  ]
}

# ---------------------------------------------------------
# Redis
# ---------------------------------------------------------

resource "helm_release" "redis" {
  name       = "redis"
  namespace  = kubernetes_namespace.n8n.metadata[0].name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      architecture = "standalone"

      auth = {
        enabled  = true
        password = var.redis_password
      }

      master = {
        persistence = {
          enabled = true
          size    = "10Gi"
        }
      }
    })
  ]
}

# ---------------------------------------------------------
# n8n
# ---------------------------------------------------------

resource "helm_release" "n8n" {
  name       = "n8n"
  namespace  = kubernetes_namespace.n8n.metadata[0].name

  repository = "oci://ghcr.io/n8n-io/n8n-helm-chart"
  chart      = "n8n"

  wait    = true
  timeout = 900

  values = [
    templatefile("${path.module}/values/n8n.yaml", {
      postgres_host     = "postgresql.n8n.svc.cluster.local"
      postgres_database = "n8n"
      postgres_user     = "n8n"
      postgres_password = var.postgres_password

      redis_host     = "redis-master.n8n.svc.cluster.local"
      redis_port     = 6379
      redis_password = var.redis_password

      n8n_hostname = var.n8n_hostname
    })
  ]

  depends_on = [
    helm_release.postgresql,
    helm_release.redis
  ]
}
