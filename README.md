# Senior DevOps Engineer — Home Assignment

## Prerequisites
Docker Desktop running | minikube, kubectl, terraform | Windows

## Deployment
1. `minikube start --cpus=2 --memory=4096 --driver=docker`
2. `minikube addons enable ingress`
3. `kubectl config use-context minikube`
4. `git clone <repo_path>` && `cd infra/env/dev`
5. `terraform init` → `plan` → `apply -auto-approve`
6. `kubectl get pods -n demo-dev` — sanity check
7. `kubectl get svc,ingress -n demo-dev` — confirm creation

**Expose locally:**
8. `minikube tunnel` — keep open
9. Hosts file (Admin): `127.0.0.1 demo.local`
10. Verify: `curl http://demo.local`

## CI/CD
GitHub Actions on push/PR to `main`; applies against ephemeral **kind** (CI) vs **minikube** (local).
Rollback: `kubectl rollout undo deployment/demo-app -n demo-dev`

## Security
No secrets committed; prod uses Secrets Manager/OIDC, per-service SA.
Risks: secret sprawl, no TLS (prod: ALB), unpinned image (prod: SHA-256 pin + scan).

## Observability & Troubleshooting
Stack: Prometheus/Grafana (metrics), ELK (logs), OpenTelemetry (tracing); CloudWatch/Datadog as alternatives.
Scenario (CPU 35%, no deploys, latency 200ms→5s): compute is healthy, so check deps first, then network/DNS, pools, noisy neighbors.
Tools: `kubectl top/logs/describe`, `exec`, APM dashboards.
Mitigation: scale out/restart pods; follow-up: tracing + latency alerts.
Autoscaling: HPA (replicas), VPA (pod sizing), both metrics-driven.

## What I'd Improve
Move to AWS EKS; remote state + locking. Gateway API over ingress-nginx; Route53 + ALB for prod. Karpenter; Kyverno for policy.

## Decisions & Trade-offs
minikube/kind fits the 3-hour budget; same module targets EKS later.
minikube (dev) vs kind (CI): both disposable; kind is faster in CI.
`modules/app` is reusable; `env/dev` holds only environment-specific values.

## AI Tool Usage
Claude helped draft Terraform structure, the CI workflow, and README sections. Code was run and verified locally; decisions are my own.