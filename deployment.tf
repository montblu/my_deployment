resource "kubernetes_deployment" "main" {
  metadata {
    name      = local.resource_name
    namespace = var.namespace

    annotations = local.annotations
    labels      = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        volume {}

        container {
          args    = var.args
          command = var.command
          dynamic "env" {
            for_each = var.env
            content {
              name       = env.value
              value      = lookup(env.value, "value", null)
              value_from = lookup(env.value, "value_from", null)
            }
          }
          dynamic "env_from" {
            for_each = var.env_from
            content {
              dynamic "config_map_ref" {
                for_each = lookup(env_from.value, "config_map_ref", [])
                content {
                  name     = lookup(config_map_ref.value, "name", null)
                  optional = lookup(config_map_ref.value, "name", null)
                }
              }
              prefix = lookup(env_from.value, "prefix", null)
              dynamic "secret_ref" {
                for_each = lookup(env_from.value, "secret_ref", [])
                content {
                  name     = lookup(secret_ref.value, "name", null)
                  optional = lookup(secret_ref.value, "name", null)
                }
              }
            }
          }
          name              = local.resource_name
          image             = local.image
          image_pull_policy = var.image_pull_policy
          working_dir       = var.working_dir

          resources {
            limits   = var.resource_limits
            requests = var.resource_requests
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].template[0].metadata[0].annotations["reloader.stakater.com/last-reloaded-from"],
      spec[0].template[0].spec[0].container[0].image
    ]
  }

  wait_for_rollout = var.wait_for_rollout

  depends_on = [
    aws_ecr_lifecycle_policy.main
  ]
}
