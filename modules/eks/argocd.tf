
resource "kubernetes_namespace" "argocd" {
  count = var.enable_argocd ? 1 : 0

  metadata {
    name = "argocd"
    labels = {
      name                                 = "argocd"
      "app.kubernetes.io/name"            = "argocd"
      "app.kubernetes.io/component"       = "server"
      "pod-security.kubernetes.io/enforce" = "baseline"
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd[0].metadata[0].name
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

  depends_on = [
    module.eks,
    kubernetes_namespace.argocd
  ]
}
/*
resource "kubernetes_manifest" "argocd_root_app" {
  count = var.enable_argocd && var.argocd_create_root_app ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-app"
      namespace = kubernetes_namespace.argocd[0].metadata[0].name
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.argocd_root_app_repo
        targetRevision = var.argocd_root_app_branch
        path           = var.argocd_root_app_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  depends_on = [helm_release.argocd]
}
*/
data "kubernetes_secret" "argocd_admin" {
  count = var.enable_argocd ? 1 : 0

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd[0].metadata[0].name
  }

  depends_on = [helm_release.argocd]
}

data "kubernetes_service" "argocd_server" {
  count = var.enable_argocd ? 1 : 0

  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd[0].metadata[0].name
  }

  depends_on = [helm_release.argocd]
}