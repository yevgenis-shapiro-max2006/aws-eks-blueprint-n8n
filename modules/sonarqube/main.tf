
resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  namespace        = "sonarqube"
  create_namespace = true

  timeout          = 1200
  wait             = true
  atomic           = true
 
  set {
    name  = "community.enabled"
    value = "true"
  }

  set {
    name  = "edition"
    value = ""
  }
 
  values = [
    file("${path.module}/sonarqube.yaml")
  ]
}

