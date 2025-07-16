
# Documento Técnico - Desafio SRE

## SLIs e SLOs

| Métrica           | SLI                                | SLO                        |
|-------------------|-------------------------------------|----------------------------|
| Disponibilidade   | % de respostas 2xx sobre total      | 99.9%                      |
| Latência P95      | Requisições abaixo de 500ms         | 99%                        |
| Taxa de erros     | Respostas 5xx sobre total           | < 1%                       |
| Uptime            | Healthchecks bem-sucedidos          | 99.95% mensal              |

## Estratégia de Rollout Seguro

- Healthchecks configurados (readiness/liveness)
- Rollout progressivo (canary) com ferramentas como Argo Rollouts ou flag manual por ambiente
- Rollback automático em caso de falha
- Observabilidade reforçada com logs, métricas e tracing (OpenTelemetry + Datadog/Grafana)

## Diagrama de Arquitetura

Ver imagem: `architecture.png`
