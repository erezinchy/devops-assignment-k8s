# Senior DevOps Engineer — Home Assignment

## Prerequisites
- Docker Desktop running (minikube --driver=docker requires it)
- minikube, kubectl, terraform installed | Windows (PowerShell/cmd)

## Deployment
1. `minikube start --cpus=2 --memory=4096 --driver=docker`
2. `minikube addons enable ingress`
3. `kubectl config use-context minikube`
4. `git clone <repo_path>` && `cd infra/env/dev`
5. `terraform init` → `terraform plan` → `terraform apply -auto-approve`
6. `kubectl get pods -n demo-dev` — sanity check: Running/Ready
7. `kubectl get svc,ingress -n demo-dev` — confirm Service + Ingress

**Expose locally:**
8. Open a new terminal and run `minikube tunnel` — keep it open, since it
   simulates a cloud LoadBalancer for the local cluster
9. Add to hosts file (as Admin) `C:\Windows\System32\drivers\etc\hosts`:
   `127.0.0.1 demo.local`
10. Verify: `curl http://demo.local`
11. If it fails, check the tunnel terminal's output — on Windows/Docker
    driver it sometimes binds `127.0.0.1` instead of `minikube ip`

## CI/CD
- GitHub Actions on push/PR to `main`
- Validates + applies Terraform against ephemeral **kind** (CI) vs **minikube** (local) — same manifests
- Rollback: `kubectl rollout undo deployment/demo-app -n demo-dev`

## Security
- **Secrets:** none committed; prod will use AWS Secrets Manager/External Secrets Operator, CI via OIDC
- **Least privilege:** default RBAC now; prod scopes a ServiceAccount per service
- **Risks:** (1) secret sprawl — kept out of Git/state; (2) no TLS on ingress — prod adds TLS via ALB + network policies; (3) unpinned public image — prod pins SHA-256 digests + scans in CI

## What I'd Improve
1. Move to AWS EKS
2. Remote state + locking (S3 + DynamoDB)
3. Replace ingress-nginx with Gateway API
4. Route53 instead of hosts-file edits; ALB instead of `minikube tunnel`
5. Karpenter for node autoscaling; Kyverno for policy enforcement

## Decisions & Trade-offs
1. **Local K8s over cloud:** minikube/kind to fit the 3-hour budget — no IAM/VPC overhead; same Terraform module targets EKS with only the env layer changing
2. **minikube (dev) vs kind (CI):** both disposable local K8s; kind provisions faster in GitHub-hosted runners
3. **Terraform module split:** `modules/app` is reusable/env-agnostic; `env/dev` holds only environment-specific values

## AI Tool Usage
Claude helped draft the Terraform module structure, GitHub Actions workflow, and parts of this README. All generated code was run and verified locally (minikube) before committing; decisions and trade-offs reflect my own judgment.