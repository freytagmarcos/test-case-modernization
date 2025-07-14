## Desafio 1 - Exercício de modernização

Como novo integrante do time de SRE, você será responsável pela evolução de uma plataforma de e-commerce
hospedada 100% na AWS, e utiliza Kubernetes como orquestrador de contêineres. **A empresa definiu
como prioridades estratégicas: melhorar a resiliência, aumentar a confiabilidade e aprimorar a observabilidade**.
Além disso, deseja implementar práticas de GitOps e estabelecer um processo de deploy mais automatizado e seguro.

### Tarefas:

1. Provisionar um cluster EKS com Terraform.
2. Instalar e configurar ArgoCD no cluster.
3. Criar um Helm chart simples da aplicação web.
4. Criar pipeline no GitHub Actions que:
   * Build da imagem.
   * Push no ECR.
   * Atualização automática do repositório GitOps.
5. Instrumentar a aplicação com OpenTelemetry
6. Criar um dashboard no Datadog ou Grafana.
7. Criar um documento com:
   * Diagrama de arquitetura.
   * SLIs e SLOs propostos.
   * Estratégia de rollout seguro.