resource "helm_release" "datadog-operator" {
  name = datadog-operator
  namespace = datadog
  repository = datadog
  chart = datadog-operator
}