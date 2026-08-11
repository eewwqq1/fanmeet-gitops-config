# environments/aws

Not started yet. This directory is a placeholder for stage 2 (AWS landing zone) —
see `docs/superpowers/plans/2026-08-06-stage1-aws-landing-zone.md` in the
`데브옵스프로젝트` repo for the current status of that stage.

When stage 2 begins, this directory will hold `values-<service>.yaml` overrides
for the AWS cluster (ALB ingress instead of MetalLB, RDS instead of the on-prem
Postgres container, etc.), and the ApplicationSet in `bootstrap/appsets/services.yaml`
will switch from a `list` generator to a `matrix` generator over
`{onprem, aws} × {server, media, notification, membership-billing}`.
