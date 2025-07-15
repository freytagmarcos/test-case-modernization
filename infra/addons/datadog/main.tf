resource "helm_release" "datadog" {
  name = datadog-operator
  namespace = datadog
  repository = datadog
  chart = datadog-operator
}