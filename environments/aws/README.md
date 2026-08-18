# environments/aws

Live values for the AWS EKS cluster (stage 2). Holds one `values-<service>.yaml`
per deployment unit, overriding the shared `charts/service` template with the
AWS-specific infra bits: ALB ingress (AWS Load Balancer Controller) instead of
MetalLB, RDS instead of the on-prem Postgres container on `docker1`, and images
pulled from ECR instead of the on-prem registry. The `bootstrap/appsets/services.yaml`
ApplicationSet uses a `matrix` generator over `{onprem, aws} × {server, media,
notification, membership-billing}`, so every service is deployed to both clusters
from the same chart.

Image tags here are bumped automatically, together with `environments/onprem/`,
by the `fanmeet-app-source` Jenkins pipeline's "Bump gitops-config tags" stage
(Kaniko pushes to both the on-prem registry and ECR in one build, then this
stage commits both environments' tag bumps in the same commit).

The EKS cluster itself is torn down between sessions to control AWS cost (the
values here and the ECR images stay intact so it can be recreated and Argo CD
re-synced without a rebuild) — see `데브옵스프로젝트`'s `log.md` for the current
up/down status and the `terraform apply` order to bring it back.
