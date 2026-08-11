# fanmeet-gitops-config

The single source of truth Argo CD watches for the Fanmeet on-prem K8s deployment.
App code lives in the separate `데브옵스프로젝트/app-source` tree (not yet its own
repo — see that repo's `log.md` for status).

## Layout

- `charts/service/` — one common Helm chart shared by all 4 deployment units
  (monolith + media/notification/membership-billing). The template never branches
  per service; only `environments/*/values-*.yaml` differ.
- `environments/onprem/` — live values for the on-prem VMware cluster.
- `environments/aws/` — stage-2 placeholder, not started.
- `bootstrap/` — Argo CD "App of Apps": `root-app.yaml` is applied once by hand,
  everything else (the ApplicationSet, and the 4 Applications it generates) is
  then reconciled from this repo automatically.

## Bootstrapping a cluster from scratch

```bash
kubectl apply -f bootstrap/root-app.yaml
```
