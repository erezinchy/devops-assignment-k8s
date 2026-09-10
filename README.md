# Senior DevOps Engineer — Home Assignment

## Prerequisites
- Docker Desktop running (minikube --driver=docker requires it)
- minikube, kubectl, terraform installed
- Windows (commands below use PowerShell / cmd)

## Deployment

1. `minikube start --cpus=2 --memory=4096 --driver=docker`
2. `minikube addons enable ingress`
3. `kubectl config use-context minikube`
4. `git clone <repo_path>`
5. `cd infra/env/dev`
6. `terraform init`
7. `terraform plan`
8. `terraform apply -auto-approve`
9. `kubectl get pods -n demo-dev` — sanity check: pods should be Running/Ready
10. `kubectl get svc,ingress -n demo-dev` — sanity check: confirm Service + Ingress were created

**Expose locally:**

11. Open a new terminal and run `minikube tunnel` — keep it open
12. Edit hosts file (as Admin) `C:\Windows\System32\drivers\etc\hosts`:
127.0.0.1 demo.local
13. Verify: `curl http://demo.local`

## CI/CD
- GitHub Actions runs on push/PR to `main`
- Validates + applies Terraform against an ephemeral **kind** cluster (CI)
  vs. **minikube** (local dev) — same manifests, different local K8s distro
- Rollback: `kubectl rollout undo deployment/demo-app -n demo-dev`

## What I'd improve with more time
1. Move to AWS EKS
2. Add remote state + state locking (S3 + DynamoDB)
3. Replace ingress-nginx with Gateway API
4. For prod, use Route53 instead of manual hosts-file edits
5. For prod, use ALB instead of `minikube tunnel`

## Decisions & Trade-offs
- **Local K8s over cloud**: chose minikube/kind over a real cloud cluster to
  stay within the 3-hour budget — no IAM/VPC setup overhead. Same Terraform
  module would target EKS (or AKS/GKE) with only the environment layer
  changing.
- **minikube (dev) vs kind (CI)**: both are disposable local K8s; kind is
  faster to provision in GitHub-hosted runners. Manifests are identical.
- **Terraform module split**: `modules/app` is reusable/env-agnostic;
  `env/dev` holds only environment-specific values — this separation is
  intended to carry directly to staging/prod.