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

Prerequisite: Argo CD must already be installed on the target cluster. The
current on-prem cluster runs Argo CD v3.5.0, installed via the standard
non-Helm manifest:
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.0/manifests/install.yaml
```
Once Argo CD is running and its CRDs (`applications.argoproj.io`,
`applicationsets.argoproj.io`, `appprojects.argoproj.io`) are registered:
```bash
kubectl apply -f bootstrap/root-app.yaml
```
This creates the root "App of Apps" Application, which reconciles the
ApplicationSet in `bootstrap/appsets/`, which in turn generates one
Application per service.

## Day-2 operations

- **Changing a value** (image tag, resources, env var): edit the relevant
  `environments/onprem/values-<service>.yaml`, commit, push to `main`. Argo
  CD's automated sync (`selfHeal: true`) picks it up within ~3 minutes.
- **`helm` is no longer the deploy path.** The 4 services' original
  `helm install`/`helm upgrade` CLI workflow is superseded by this repo —
  do not run `helm upgrade` against them directly; changes made that way
  will be silently reverted by Argo CD's self-heal (or, if you `helm
  uninstall`, the live resources will be deleted and then recreated by
  self-heal after a real availability gap). All changes must go through
  this git repo.
- **Emergency manual intervention** (e.g. hotfixing a running pod): first
  disable auto-sync for the affected app so Argo CD doesn't immediately
  revert your change: `argocd app set fanmeet-<service> --sync-policy none`
  (or edit the Application resource's `spec.syncPolicy` directly via
  `kubectl` if the `argocd` CLI isn't available). Re-enable
  (`--sync-policy automated`) once the emergency fix is reflected in git
  and synced normally, or the manual change will eventually drift and get
  reverted anyway.
