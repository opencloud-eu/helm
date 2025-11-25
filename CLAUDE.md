# CLAUDE.md - OpenCloud Helm Charts Repository Guide

## Overview

This is a **community-maintained** Helm charts repository for deploying OpenCloud on Kubernetes. OpenCloud is a cloud collaboration platform providing file sync/share and document collaboration capabilities.

**Important**: This repository is NOT officially supported by OpenCloud GmbH. For production-ready charts, contact OpenCloud via their [business subscription](https://opencloud.eu/en/product/service-and-support).

## Repository Structure

```
opencloud-eu-helm/
├── charts/
│   ├── opencloud/                    # Production chart (v0.2.3)
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   │   ├── _helpers/             # Helper templates
│   │   │   ├── opencloud/            # Main OpenCloud deployment
│   │   │   ├── keycloak/             # Identity provider
│   │   │   ├── postgres/             # Database for Keycloak
│   │   │   ├── minio/                # S3-compatible storage
│   │   │   ├── collabora/            # Document editor
│   │   │   ├── onlyoffice/           # Alternative document editor
│   │   │   ├── collaboration/        # WOPI server
│   │   │   ├── gateway/              # Gateway API routes
│   │   │   ├── middleware/           # Ingress middleware
│   │   │   └── tika/                 # Content extraction
│   │   └── README.md
│   │
│   ├── opencloud-microservices/      # Microservices chart (v0.3.10)
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   │   ├── _common/              # Shared template helpers
│   │   │   │   ├── _tplvalues.tpl    # Core template functions
│   │   │   │   ├── _configvalues.tpl # Configuration helpers
│   │   │   │   ├── labels/           # Label helpers
│   │   │   │   ├── registry/         # Registry helpers
│   │   │   │   └── *.tpl             # Other helpers
│   │   │   ├── [service]/            # One directory per microservice
│   │   │   │   ├── deployment.yaml
│   │   │   │   ├── service.yaml
│   │   │   │   ├── hpa.yaml          # Horizontal Pod Autoscaler
│   │   │   │   ├── pdb.yaml          # Pod Disruption Budget
│   │   │   │   └── config.yaml       # ConfigMaps (if needed)
│   │   │   └── NOTES.txt
│   │   ├── deployments/
│   │   │   ├── helm/                 # Helmfile deployment
│   │   │   │   └── helmfile.yaml
│   │   │   └── timoni/               # Timoni/FluxCD deployment
│   │   │       ├── opencloud/
│   │   │       ├── openldap/
│   │   │       └── clamav/
│   │   └── schema/
│   │       └── templates.json
│   │
│   └── opencloud-dev/                # Development chart (v0.1.0)
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│
├── deployments/
│   └── nats/                         # NATS configuration examples
│
├── .github/
│   └── workflows/
│       └── publish-helm-charts.yml   # CI/CD for chart publishing
│
├── CONTRIBUTING.md
├── MAINTAINERS.md
├── README.md
└── LICENSE                           # AGPLv3
```

## Available Charts

### 1. Production Chart (`charts/opencloud`)
- **Version**: 0.2.3
- **Architecture**: Groups services logically (frontend, backend pods)
- **Use case**: Standard production deployments
- **Components**: Keycloak, MinIO, PostgreSQL, Collabora/OnlyOffice

### 2. Microservices Chart (`charts/opencloud-microservices`)
- **Version**: 0.3.10
- **Architecture**: Pod-per-service (each OpenCloud service in its own pod)
- **Use case**: Fine-grained resource control, regulatory requirements
- **Components**: 40+ individual microservices
- **Warning**: Higher complexity and resource overhead

### 3. Development Chart (`charts/opencloud-dev`)
- **Version**: 0.1.0
- **Architecture**: Single container
- **Use case**: Development and testing only
- **Warning**: NOT for production

## Key Conventions

### Template Patterns (Microservices Chart)

The microservices chart uses a sophisticated helper system in `templates/_common/`:

```yaml
# Initialize service context at start of deployment.yaml
{{- include "oc.basicServiceTemplates" (dict "scope" . "appName" "appNameFrontend" "appNameSuffix" "") -}}

# Common metadata block
{{ include "oc.metadata" . }}

# Selector block
{{- include "oc.selector" . | nindent 2 }}

# Security context
{{- include "oc.securityContextAndtopologySpreadConstraints" . | nindent 6 }}

# Container security context
{{- include "oc.containerSecurityContext" . | nindent 10 }}

# Liveness probe
{{- include "oc.livenessProbe" . | nindent 10 }}

# Image specification
{{- include "oc.image" $ | nindent 10 }}
```

### Service Naming Convention

Services follow a consistent naming pattern:
- `appNameFrontend`, `appNameGateway`, `appNameGraph`, etc.
- Mapped in `oc.basicServiceTemplates` helper function
- Service directories match the appName (e.g., `templates/frontend/`, `templates/gateway/`)

### Values Structure

```yaml
# Global image settings
image:
  repository: opencloudeu/opencloud-rolling
  tag: ""           # Defaults to appVersion
  pullPolicy: IfNotPresent

# Per-service configuration under 'services' key
services:
  frontend:
    enabled: true
    replicas: 1
    resources: {}
    persistence:
      enabled: false
    autoscaling:
      enabled: false

# External components
keycloak:
  enabled: true
  domain: keycloak.opencloud.test

minio:
  enabled: true
  domain: minio.opencloud.test
```

## Development Workflow

### Prerequisites
- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner (if persistence enabled)
- External ingress controller (e.g., Cilium Gateway API)

### Testing Changes

```bash
# Lint the chart
helm lint charts/opencloud
helm lint charts/opencloud-microservices
helm lint charts/opencloud-dev

# Template rendering (dry-run)
helm template my-release charts/opencloud --debug

# Install from local directory
helm install my-release charts/opencloud --namespace opencloud --create-namespace
```

### Using Helmfile (Microservices)

```bash
cd charts/opencloud-microservices/deployments/helm
helmfile sync
```

### Using Timoni/FluxCD (Microservices)

```bash
kubectl apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud
timoni bundle apply -f ./charts/opencloud-microservices/deployments/timoni/opencloud/opencloud.cue \
  --runtime ./charts/opencloud-microservices/deployments/timoni/opencloud/runtime.cue
```

## Version Policy

Charts are at version `0.x.x` following [SemVer 2.0](https://semver.org/):
- Breaking changes may occur at any time
- Public API is not stable
- Always pin to specific versions in production
- Test updates thoroughly before applying

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/publish-helm-charts.yml`):

1. **Trigger**: Push to `main` branch or version tags (`v*`)
2. **Actions**:
   - Packages all three charts
   - Pushes to GitHub Container Registry (GHCR)
   - OCI artifacts at: `ghcr.io/opencloud-eu/helm-charts/[chart-name]`

### Installing from OCI Registry

```bash
helm pull oci://ghcr.io/opencloud-eu/helm-charts/opencloud --version 0.2.3
helm pull oci://ghcr.io/opencloud-eu/helm-charts/opencloud-microservices --version 0.3.10
helm pull oci://ghcr.io/opencloud-eu/helm-charts/opencloud-dev --version 0.1.0
```

## Microservices List

The microservices chart deploys these OpenCloud services (each in its own pod):

| Service | Description | Scalable |
|---------|-------------|----------|
| activitylog | Activity logging | Yes |
| antivirus | ClamAV scanning | Yes |
| appregistry | Application registry | Yes |
| audit | Audit logging | Yes |
| auth-app | App authentication | Yes |
| authmachine | Machine authentication | Yes |
| authservice | Core authentication | Yes |
| clientlog | Client logging | Yes |
| collaboration | WOPI server | Yes |
| eventhistory | Event history | Yes |
| frontend | Web interface | Yes |
| gateway | API gateway | Yes |
| graph | Microsoft Graph API | Yes |
| groups | Group management | Yes |
| idm | Identity management | **No** (embedded LDAP) |
| idp | Identity provider | **No** (depends on IDM) |
| notifications | Notification service | Yes |
| ocdav | WebDAV interface | Yes |
| ocm | OpenCloud Mesh | **No** (federation state) |
| ocs | OCS API | Yes |
| policies | Policy engine | Yes |
| postprocessing | File postprocessing | Yes |
| proxy | HTTP proxy | Yes |
| search | Full-text search | **No** (BoltDB) |
| settings | Settings management | Yes |
| sharing | Share management | Yes |
| sse | Server-sent events | Yes |
| storagepubliclink | Public links | Yes |
| storageshares | Shared storage | Yes |
| storagesystem | System storage | Yes |
| storageusers | User storage | Yes |
| thumbnails | Thumbnail generation | Yes |
| userlog | User activity log | Yes |
| users | User management | Yes |
| web | Web assets | Yes |
| webdav | WebDAV service | Yes |
| webfinger | WebFinger discovery | Yes |

## Security Considerations

### Secrets to Change for Production

1. **LDAP/IDM**: `ldap-bind-secrets`, `opencloud-ldap-secrets`
2. **Object Storage**: `s3secret`, `opencloud-minio-secrets`
3. **Authentication**: `opencloud-keycloak-admin-secrets`, `opencloud-keycloak-postgresql-secrets`
4. **Messaging**: `opencloud-amqp-secret`
5. **OnlyOffice**: `opencloud-onlyoffice-secrets` (inbox, outbox, session tokens)

### Default Credentials (CHANGE IN PRODUCTION!)

```yaml
# Keycloak
adminUser: admin
adminPassword: admin

# PostgreSQL
user: keycloak
password: keycloak

# MinIO
rootUser: opencloud
rootPassword: opencloud-secret-key

# RabbitMQ
url: amqp://guest:guest@localhost
```

## Common Tasks for AI Assistants

### Adding a New Service

1. Create directory: `templates/[servicename]/`
2. Add files: `deployment.yaml`, `service.yaml`, `hpa.yaml`, `pdb.yaml`
3. Register service in `_common/_tplvalues.tpl` under `oc.basicServiceTemplates`
4. Add configuration section in `values.yaml`

### Modifying Helper Templates

Helpers are in `charts/opencloud-microservices/templates/_common/`:
- `_tplvalues.tpl` - Core functions (metadata, selectors, security)
- `_configvalues.tpl` - Configuration helpers
- `labels/labels.tpl` - Label generation
- `images.tpl` - Image reference helpers
- `events.tpl` - Event system configuration
- `store.tpl` - Storage helpers

### Updating Chart Versions

1. Update version in `Chart.yaml`
2. Update `appVersion` if changing OpenCloud version
3. Tag release: `git tag v0.x.x`
4. Push tag to trigger CI: `git push origin v0.x.x`

## Community Resources

- **Matrix Chat**: [#opencloud-helm:matrix.org](https://matrix.to/#/%23opencloud-helm:matrix.org)
- **GitHub Issues**: [opencloud-eu/helm](https://github.com/opencloud-eu/helm/issues)
- **GitHub Discussions**: [opencloud-eu discussions](https://github.com/orgs/opencloud-eu/discussions)

## Maintainers

See [MAINTAINERS.md](./MAINTAINERS.md) for current maintainers and reviewers.

## License

AGPLv3 - See [LICENSE](./LICENSE)
