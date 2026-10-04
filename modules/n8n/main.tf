
resource "kubernetes_namespace" "n8n" {
  metadata {
    name = "n8n"
  }
}

# =========================================================
# n8n core secret
# =========================================================

resource "kubernetes_secret" "n8n" {
  metadata {
    name      = "n8n-secrets"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  type = "Opaque"

  data = {
    N8N_ENCRYPTION_KEY = var.n8n_encryption_key
    N8N_HOST           = var.n8n_hostname
    N8N_PROTOCOL       = "https"
    N8N_PORT           = "5678"
  }
}

# =========================================================
# PostgreSQL password
# =========================================================

resource "kubernetes_secret" "n8n_db_password" {
  metadata {
    name      = "n8n-db-password"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  type = "Opaque"

  data = {
    password = var.postgres_password
  }
}

# =========================================================
# Redis password
# =========================================================

resource "kubernetes_secret" "n8n_redis_password" {
  metadata {
    name      = "n8n-redis-password"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  type = "Opaque"

  data = {
    password = var.redis_password
  }
}

# =========================================================
# PostgreSQL
# =========================================================

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

# =========================================================
# Redis
# =========================================================

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

# =========================================================
# n8n
# =========================================================

resource "helm_release" "n8n" {
  name       = "n8n"
  namespace  = kubernetes_namespace.n8n.metadata[0].name

  repository = "oci://ghcr.io/n8n-io/n8n-helm-chart"
  chart      = "n8n"

  wait    = true
  timeout = 900

  values = [
    templatefile("${path.module}/values-n8n.yaml", {
      n8n_hostname = var.n8n_hostname
    })
  ]

  depends_on = [
    kubernetes_secret.n8n,
    kubernetes_secret.n8n_db_password,
    kubernetes_secret.n8n_redis_password,
    helm_release.postgresql,
    helm_release.redis
  ]
}
