resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      name                                 = "argocd"
      "app.kubernetes.io/name"            = "argocd"
      "app.kubernetes.io/component"       = "server"
      "pod-security.kubernetes.io/enforce" = "baseline"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  reuse_values = true
  
  values = [
    yamlencode({
      global = {
        image = {
          tag = var.argocd_version
        }
      }

      # Server configuration
      server = {
        replicas = var.argocd_ha_enabled ? 3 : 1
        
        autoscaling = var.argocd_ha_enabled ? {
          enabled     = true
          minReplicas = 2
          maxReplicas = 5
        } : {
          enabled = false
          minReplicas = 1
          maxReplicas = 1
        }

        resources = {
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
        }

        service = {
          type = var.argocd_enable_loadbalancer ? "LoadBalancer" : "ClusterIP"
          annotations = var.argocd_enable_loadbalancer ? {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = var.argocd_loadbalancer_internal ? "internal" : "internet-facing"
          } : {}
        }

      }

      controller = {
        replicas = var.argocd_ha_enabled ? 2 : 1
        
        resources = {
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }
        }
      }

      repoServer = {
        replicas = var.argocd_ha_enabled ? 2 : 1
        
        autoscaling = var.argocd_ha_enabled ? {
          enabled     = true
          minReplicas = 2
          maxReplicas = 5
        } : {
          enabled = false
          minReplicas = 1
          maxReplicas = 1
        }

        resources = {
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
        }
      }

      redis = {
        enabled = !var.argocd_ha_enabled
        resources = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }
        }
      }

      redis-ha = {
        enabled = var.argocd_ha_enabled
        replicas = var.argocd_ha_enabled ? 3 : 1
        resources = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }
        }
      }
    })
  ]
  wait          = true
  wait_for_jobs = true
  timeout       = 600
}

data "kubernetes_secret" "argocd_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  depends_on = [helm_release.argocd]
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  depends_on = [helm_release.argocd]
}