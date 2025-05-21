<img src="https://helm.sh/img/helm.svg" width="100px" heigth="100px">

# OpenCloud Helm Charts

Welcome to the **OpenCloud Helm Charts** repository! This repository is intended as a community-driven space for developing and maintaining Helm charts for deploying OpenCloud on Kubernetes.

## 🚀 Installation

This repository contains multiple Helm charts for deploying OpenCloud. Below are the instructions for installing the `opencloud-full` chart, which provides a comprehensive OpenCloud deployment.

### Installing Chart 1 `opencloud-full`

This is the full chart that includes LDAP, OIDC, S3 storage, and various plugins. To install the `opencloud-full` chart, navigate to its deployment directory and synchronize the Helmfile:

```bash
cd charts/opencloud-full/deployments
helmfile sync
```

This command will deploy all the necessary components for a full OpenCloud instance, including its dependencies.

### Installing Chart 2 (Placeholder)

(Details on how to install this chart will be added later.)

### Installing Chart 3 (Placeholder)

(Details on how to install this chart will be added later.)

##  Table of Contents

- [About](#-about)
- [Community](#-community)
- [Contributing](#-contributing)
- [Prerequisites](#prerequisites)
- [Available Charts](#-available-charts)
  - [Production Chart](#production-chart-chartsopencloud)
  - [Development Chart](#development-chart-chartsopencloud-dev)
- [Architecture](#architecture)
  - [Component Interaction Diagram](#component-interaction-diagram)
- [Configuration](#configuration)
  - [Global Settings](#global-settings)
  - [Image Settings](#image-settings)
  - [OpenCloud Settings](#opencloud-settings)
  - [Keycloak Settings](#keycloak-settings)
  - [PostgreSQL Settings](#postgresql-settings)
  - [OnlyOffice Settings](#onlyoffice-settings)
  - [Collabora Settings](#collabora-settings)
  - [Collaboration Service Settings](#collaboration-service-settings)
- [Gateway API Configuration](#gateway-api-configuration)
  - [HTTPRoute Settings](#httproute-settings)
- [Setting Up Gateway API with Talos, Cilium, and cert-manager](#setting-up-gateway-api-with-talos-cilium-and-cert-manager)
- [Setting up Ingress](#setting-up-ingress)
- [License](#-license)
- [Community Maintained](#community-maintained)

## 🚀 About

This repository is created to **welcome contributions from the community**. It does not contain official charts from OpenCloud GmbH and is **not officially supported by OpenCloud GmbH**. Instead, these charts are maintained by the open-source community.

OpenCloud is a cloud collaboration platform that provides file sync and share, document collaboration, and more. This Helm chart deploys OpenCloud with Keycloak for authentication, MinIO for object storage, and multiple options for document editing including Collabora and OnlyOffice.

## 💬 Community

Join our Matrix chat for discussions about OpenCloud Helm Charts:
- [OpenCloud Helm on Matrix](https://matrix.to/#/%23opencloud-helm:matrix.org)

For general OpenCloud discussions:
- [OpenCloud on Matrix](https://matrix.to/#/%23opencloud:matrix.org)
- [OpenCloud on Mastodon](https://social.opencloud.eu/@OpenCloud)
- [GitHub Discussions](https://github.com/orgs/opencloud-eu/discussions)

## 💡 Contributing

We encourage contributions from the community! If you'd like to contribute:
- Fork this repository
- Submit a Pull Request
- Discuss and collaborate on issues

Please ensure that your PR follows best practices and includes necessary documentation.

## Prerequisites

- Kubernetes 1.19+ (e.g. Talos Kubernetes, RKE2)
- Helm 3.2.0+ or Timoni Bundle (flux-helm-release)
- PVC provisioner support in the underlying infrastructure (if persistence is enabled)
- External ingress controller (e.g., Cilium Gateway API) for routing traffic to the services


[View Development Chart Documentation](./charts/opencloud-dev/README.md)

## Architecture

The production chart (`charts/opencloud`) deploys the following components:

1. **OpenCloud** - Main application
2. **Keycloak** - Authentication provider with OpenID Connect
3. **PostgreSQL** - Database for Keycloak and OnlyOffice
4. **MinIO** - S3-compatible object storage
5. **Collabora** - Online document editor (CODE - Collabora Online Development Edition)
6. **OnlyOffice** - Alternative document editor with real-time collaboration
7. **Collaboration Service** - WOPI server that connects OpenCloud with document editors
8. **Redis** - Cache for OnlyOffice
9. **RabbitMQ** - Message queue for OnlyOffice
10. **OpenLDAP** - LDAP server for user and group management

All services are deployed with `ClusterIP` type, which means they are only accessible within the Kubernetes cluster. You need to configure your own ingress controller (e.g., Cilium Gateway API) to expose the services externally.

### Component Interaction Diagram

The following diagram shows how the different components interact with each other:

```mermaid
graph TD
    User[User Browser] -->|Accesses| Gateway[Gateway API]
    
    subgraph "OpenCloud System"
        Gateway -->|cloud.opencloud.test| OpenCloud[OpenCloud Pod]
        Gateway -->|collabora.opencloud.test| Collabora[Collabora Pod]
        Gateway -->|onlyoffice.opencloud.test| OnlyOffice[OnlyOffice Pod]
        Gateway -->|collaboration.opencloud.test| Collaboration[Collaboration Pod]
        Gateway -->|wopiserver.opencloud.test| Collaboration
        Gateway -->|keycloak.opencloud.test| Keycloak[Keycloak Pod]
        Gateway -->|minio.opencloud.test| MinIO[MinIO Pod]
        
        OpenCloud -->|Authentication| Keycloak
        OpenCloud -->|File Storage| MinIO
        OpenCloud -->|Messaging| NATS[NATS]
        OpenCloud -->|User/Group Management| OpenLDAP[OpenLDAP]
        
        Collabora -->|WOPI Protocol| Collaboration
        OnlyOffice -->|WOPI Protocol| Collaboration
        Collaboration -->|File Access| MinIO
        
        Collaboration -->|Authentication| Keycloak
        
        OpenCloud -->|Collaboration API| Collaboration
        
        OnlyOffice -->|Database| PostgreSQL[PostgreSQL]
        OnlyOffice -->|Cache| Redis[Redis]
        OnlyOffice -->|Message Queue| RabbitMQ[RabbitMQ]
    end
    
    Keycloak -->|User Federation| OpenLDAP
    
    classDef pod fill:#f9f,stroke:#333,stroke-width:2px;
    classDef gateway fill:#bbf,stroke:#333,stroke-width:2px;
    classDef user fill:#bfb,stroke:#333,stroke-width:2px;
    classDef db fill:#dfd,stroke:#333,stroke-width:2px;
    classDef mq fill:#ffd,stroke:#333,stroke-width:2px;
    classDef ldap fill:#cff,stroke:#333,stroke-width:2px;

    class OpenCloud,Collabora,OnlyOffice,Collaboration,Keycloak,MinIO pod;
    class PostgreSQL,Redis db;
    class RabbitMQ,NATS mq;
    class OpenLDAP ldap;
    class Gateway gateway;
    class User user;
```

Key interactions:

1. **User to Gateway**: 
   - Users access all services through the Gateway API using different hostnames

2. **OpenCloud Pod**:
   - Main application that users interact with
   - Authenticates users via Keycloak
   - Stores files in MinIO
   - Communicates with Collaboration service for collaborative editing

3. **Collabora Pod**:
   - Office document editor
   - Connects to the Collaboration pod via WOPI protocol
   - Uses token server secret for authentication

4. **OnlyOffice Pod**:
   - Alternative office document editor
   - Connects to the Collaboration pod via WOPI protocol
   - Uses PostgreSQL for database storage
   - Uses Redis for caching
   - Uses RabbitMQ for message queuing
   - Provides real-time collaborative editing

5. **Collaboration Pod**:
   - Implements WOPI server functionality
   - Acts as intermediary between document editors and file storage
   - Handles collaborative editing sessions
   - Accesses files from MinIO

6. **Keycloak Pod**:
   - Handles authentication for all services
   - Manages user identities and permissions

7. **MinIO Pod**:
   - Object storage for all files
   - Accessed by OpenCloud and Collaboration pods

## Configuration

The following sections outline the main configuration parameters for the production chart (`charts/opencloud`). For a complete list of configuration options, please refer to the [values.yaml](./charts/opencloud/values.yaml) file.

### Global Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `namespace` | Deprecated: Namespace is now controlled by Helm (.Release.Namespace) | (removed) |
| `global.domain.opencloud` | Domain for OpenCloud | `cloud.opencloud.test` |
| `global.domain.keycloak` | Domain for Keycloak | `keycloak.opencloud.test` |
| `global.domain.minio` | Domain for MinIO | `minio.opencloud.test` |
| `global.domain.collabora` | Domain for Collabora | `collabora.opencloud.test` |
| `global.domain.onlyoffice` | Domain for OnlyOffice | `onlyoffice.opencloud.test` |
| `global.domain.companion` | Domain for Companion | `companion.opencloud.test` |
| `global.tls.enabled` | Enable TLS (set to false when using gateway TLS termination externally) | `false` |
| `global.tls.secretName` | Secret name for TLS certificate | `""` |
| `global.storage.storageClass` | Storage class for persistent volumes | `""` |

### Image Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | OpenCloud image repository | `opencloudeu/opencloud-rolling` |
| `image.tag` | OpenCloud image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.pullSecrets` | Image pull secrets | `[]` |

### OpenCloud Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `opencloud.enabled` | Enable OpenCloud | `true` |
| `opencloud.replicas` | Number of replicas (Note: When using multiple replicas, persistence should be disabled or use a storage class that supports ReadWriteMany access mode) | `1` |
| `opencloud.logLevel` | Log level | `info` |
| `opencloud.logColor` | Enable log color | `false` |
| `opencloud.logPretty` | Enable pretty logging | `false` |
| `opencloud.insecure` | Insecure mode (for self-signed certificates) | `true` |
| `opencloud.enableBasicAuth` | Enable basic auth | `false` |
| `opencloud.adminPassword` | Admin password | `admin` |
| `opencloud.createDemoUsers` | Create demo users | `false` |
| `opencloud.resources` | CPU/Memory resource requests/limits | `{}` |
| `opencloud.persistence.enabled` | Enable persistence | `true` |
| `opencloud.persistence.size` | Size of the persistent volume | `10Gi` |
| `opencloud.persistence.storageClass` | Storage class | `""` |
| `opencloud.persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `opencloud.storage.s3.internal.enabled` | Enable internal MinIO instance | `true` |
| `opencloud.storage.s3.internal.rootUser` | MinIO root user | `opencloud` |
| `opencloud.storage.s3.internal.rootPassword` | MinIO root password | `opencloud-secret-key` |
| `opencloud.storage.s3.internal.bucketName` | MinIO bucket name | `opencloud-bucket` |
| `opencloud.storage.s3.internal.region` | MinIO region | `default` |
| `opencloud.storage.s3.internal.resources` | CPU/Memory resource requests/limits | See values.yaml |
| `opencloud.storage.s3.internal.persistence.enabled` | Enable MinIO persistence | `true` |
| `opencloud.storage.s3.internal.persistence.size` | Size of the MinIO persistent volume | `30Gi` |
| `opencloud.storage.s3.internal.persistence.storageClass` | MinIO storage class | `""` |
| `opencloud.storage.s3.internal.persistence.accessMode` | MinIO access mode | `ReadWriteOnce` |
| `opencloud.storage.s3.external.enabled` | Enable external S3 | `false` |
| `opencloud.storage.s3.external.endpoint` | External S3 endpoint URL | `""` |
| `opencloud.storage.s3.external.region` | External S3 region | `default` |
| `opencloud.storage.s3.external.accessKey` | External S3 access key | `""` |
| `opencloud.storage.s3.external.secretKey` | External S3 secret key | `""` |
| `opencloud.storage.s3.external.bucket` | External S3 bucket | `""` |
| `opencloud.storage.s3.external.createBucket` | Create bucket if it doesn't exist | `true` |

### Keycloak Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `keycloak.enabled` | Enable Keycloak | `true` |
| `keycloak.replicas` | Number of replicas | `1` |
| `keycloak.adminUser` | Admin user | `admin` |
| `keycloak.adminPassword` | Admin password | `admin` |
| `keycloak.resources` | CPU/Memory resource requests/limits | `{}` |
| `keycloak.realm` | Realm name | `openCloud` |
| `keycloak.persistence.enabled` | Enable persistence | `true` |
| `keycloak.persistence.size` | Size of the persistent volume | `1Gi` |
| `keycloak.persistence.storageClass` | Storage class | `""` |
| `keycloak.persistence.accessMode` | Access mode | `ReadWriteOnce` |

### PostgreSQL Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `postgres.enabled` | Enable PostgreSQL | `true` |
| `postgres.database` | Database name | `keycloak` |
| `postgres.user` | Database user | `keycloak` |
| `postgres.password` | Database password | `keycloak` |
| `postgres.resources` | CPU/Memory resource requests/limits | `{}` |
| `postgres.persistence.enabled` | Enable persistence | `true` |
| `postgres.persistence.size` | Size of the persistent volume | `1Gi` |
| `postgres.persistence.storageClass` | Storage class | `""` |
| `postgres.persistence.accessMode` | Access mode | `ReadWriteOnce` |


### OnlyOffice Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `onlyoffice.enabled` | Enable OnlyOffice | `true` |
| `onlyoffice.repository` | OnlyOffice image repository | `onlyoffice/documentserver` |
| `onlyoffice.tag` | OnlyOffice image tag | `8.2.2` |
| `onlyoffice.pullPolicy` | Image pull policy | `IfNotPresent` |
| `onlyoffice.wopi.enabled` | Enable WOPI integration | `true` |
| `onlyoffice.useUnauthorizedStorage` | Use unauthorized storage (for self-signed certificates) | `true` |
| `onlyoffice.persistence.enabled` | Enable persistence | `true` |
| `onlyoffice.persistence.size` | Size of the persistent volume | `2Gi` |
| `onlyoffice.resources` | CPU/Memory resource requests/limits | `{}` |
| `onlyoffice.config.coAuthoring.token.enable.request.inbox` | Enable token for incoming requests | `true` |
| `onlyoffice.config.coAuthoring.token.enable.request.outbox` | Enable token for outgoing requests | `true` |
| `onlyoffice.config.coAuthoring.token.enable.browser` | Enable token for browser requests | `true` |
| `onlyoffice.collaboration.enabled` | Enable collaboration service | `true` |

If you use Traefik and enable OnlyOffice, this chart will automatically create a `Middleware`
named `add-x-forwarded-proto-https`, used by:
* Ingress (if `annotationsPreset: traefik`)
* Gateway API `HTTPRoute` (if `gateway.className: traefik`)

This ensures the `X-Forwarded-Proto: https` header is added as required by OnlyOffice.

### Collabora Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `collabora.enabled` | Enable Collabora | `true` |
| `collabora.image.repository` | Collabora image repository | `collabora/code` |
| `collabora.image.tag` | Collabora image tag | `24.04.13.2.1` |
| `collabora.image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `collabora.adminUser` | Admin user | `admin` |
| `collabora.adminPassword` | Admin password | `admin` |
| `collabora.ssl.enabled` | Enable SSL | `true` |
| `collabora.ssl.verification` | SSL verification | `true` |
| `collabora.resources` | CPU/Memory resource requests/limits | `{}` |

### Collaboration Service Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `collaboration.enabled` | Enable collaboration service | `true` |
| `collaboration.wopiDomain` | WOPI server domain | `collaboration.opencloud.test` |
| `collaboration.resources` | CPU/Memory resource requests/limits | `{}` |

### LDAP Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ldap.enabled` | Enable LDAP integration | `false` |
| `ldap.host` | LDAP server hostname or IP | `""` |
| `ldap.port` | LDAP server port | `389` |
| `ldap.useTLS` | Use TLS for LDAP connection | `false` |
| `ldap.bindDN` | Bind DN for LDAP authentication | `""` |
| `ldap.bindPassword` | Bind password for LDAP authentication | `""` |
| `ldap.userSearchBase` | Base DN for user searches | `""` |
| `ldap.userSearchFilter` | Filter for user searches | `(objectClass=person)` |
| `ldap.groupSearchBase` | Base DN for group searches | `""` |
| `ldap.groupSearchFilter` | Filter for group searches | `(objectClass=groupOfNames)` |

## Gateway API Configuration

The production chart includes HTTPRoute resources that can be used to expose the OpenCloud, Keycloak, and MinIO services externally. The HTTPRoutes are configured to route traffic to the respective services.

### HTTPRoute Settings

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `httpRoute.enabled` | Enable HTTPRoutes | `false` |
Comment
| `httpRoute.gateway.create` | Create Gateway resource | `false` |
| `httpRoute.gateway.name` | Gateway name | `opencloud-gateway` |
| `httpRoute.gateway.namespace` | Gateway namespace | `""` (defaults to Release.Namespace) |
| `httpRoute.gateway.className` | Gateway class | `cilium` |

### Advanced Configuration Options

The production chart supports several advanced configuration options introduced in recent updates:

#### Environment Variables

You can set custom environment variables for the OpenCloud deployment:

```yaml
opencloud:
  env:
    - name: MY_VARIABLE
      value: "my-value"
    - name: ANOTHER_VARIABLE
      value: "another-value"
```

Or via command line:
```bash
--set opencloud.env[0].name=MY_VARIABLE,opencloud.env[0].value=my-value
```

#### Proxy Basic Auth

Enable basic authentication for the proxy:

```yaml
opencloud:
  proxy:
    basicAuth:
      enabled: true
```

Or via command line:
```bash
--set opencloud.proxy.basicAuth.enabled=true
```

#### Improved Namespace Handling

The chart now automatically uses the correct namespace across all resources, eliminating the need to manually set the namespace in multiple places.

The following HTTPRoutes are created when `httpRoute.enabled` is set to `true`:

1. **OpenCloud Proxy HTTPRoute (`oc-proxy-https`)**:
   - Hostname: `global.domain.opencloud`
   - Service: `{{ release-name }}-opencloud`
   - Port: 9200
   - Headers: Removes Permissions-Policy header to prevent browser console errors

2. **Keycloak HTTPRoute (`oc-keycloak-https`)** (when `keycloak.enabled` is `true`):
   - Hostname: `global.domain.keycloak`
   - Service: `{{ release-name }}-keycloak`
   - Port: 8080
   - Headers: Adds Permissions-Policy header to prevent browser features like interest-based advertising

3. **MinIO HTTPRoute (`oc-minio-https`)** (when `opencloud.storage.s3.internal.enabled` is `true`):
   - Hostname: `global.domain.minio`
   - Service: `{{ release-name }}-minio`
   - Port: 9001
   - Headers: Adds Permissions-Policy header to prevent browser features like interest-based advertising

   default user: opencloud
   pass: opencloud-secret-key

4. **MinIO Console HTTPRoute (`oc-minio-console-https`)** (when `opencloud.storage.s3.internal.enabled` is `true`):
   - Hostname: `console.minio.opencloud.test` (or `global.domain.minioConsole` if defined)
   - Service: `{{ release-name }}-minio`
   - Port: 9001
   - Headers: Adds Permissions-Policy header to prevent browser features like interest-based advertising

5. **OnlyOffice HTTPRoute (`oc-onlyoffice-https`)** (when `onlyoffice.enabled` is `true`):
   - Hostname: `global.domain.onlyoffice`
   - Service: `{{ release-name }}-onlyoffice`
   - Port: 443 (or 80 if using HTTP)
   - Path: "/"
   - This route is used to access the OnlyOffice Document Server for collaborative editing

6. **WOPI HTTPRoute (`oc-wopi-https`)** (when `onlyoffice.collaboration.enabled` and `onlyoffice.enabled` are `true`):
   - Hostname: `global.domain.wopi` (or `collaboration.wopiDomain`)
   - Service: `{{ release-name }}-collaboration`
   - Port: 9300
   - Path: "/"
   - This route is used for the WOPI protocol communication between OnlyOffice and the collaboration service

7. **Collabora HTTPRoute** (when `collabora.enabled` is `true`):
   - Hostname: `global.domain.collabora`
   - Service: `{{ release-name }}-collabora`
   - Port: 9980
   - Headers: Adds Permissions-Policy header to prevent browser features like interest-based advertising

8. **Collaboration (WOPI) HTTPRoute** (when `collaboration.enabled` is `true`):
   - Hostname: `collaboration.wopiDomain`
   - Service: `{{ release-name }}-collaboration`
   - Port: 9300
   - Headers: Adds Permissions-Policy header to prevent browser features like interest-based advertising

All HTTPRoutes are configured to use the same Gateway specified by `httpRoute.gateway.name` and `httpRoute.gateway.namespace`.

## Setting Up Gateway API with Talos, Cilium, and cert-manager

This section provides a practical guide to setting up the Gateway API with Talos, Cilium, and cert-manager for the production OpenCloud chart.

### Prerequisites

- Talos Kubernetes cluster up and running
- kubectl configured to access your cluster
- Helm 3 installed

### Step 1: Install Cilium with Gateway API Support

First, install Cilium with Gateway API support using Helm:

```bash
# Add the Cilium Helm repository
helm repo add cilium https://helm.cilium.io/

# Install Cilium with Gateway API enabled
helm install cilium cilium/cilium \
  --namespace kube-system \
  --set gatewayAPI.enabled=true \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost=<your-kubernetes-api-server-ip> \
  --set k8sServicePort=6443
```

### Step 2: Install cert-manager

Install cert-manager to manage TLS certificates:

```bash
# install the default cert manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

### Step 3: Create a ClusterIssuer for cert-manager

Create a ClusterIssuer for cert-manager to issue certificates:

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
```

Apply the ClusterIssuer:

```bash
kubectl apply -f cluster-issuer.yaml
```

### Step 4: Create a Wildcard Certificate for OpenCloud Domains

Create a wildcard certificate for all OpenCloud subdomains:

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: opencloud-wildcard-tls
  namespace: kube-system
spec:
  secretName: opencloud-wildcard-tls
  dnsNames:
    - "opencloud.test"
    - "*.opencloud.test"
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
```

Apply the certificate:

```bash
kubectl apply -f cluster-issuer.yaml
```

### Step 5: Create the Gateway

Create a Gateway resource to expose your services:


```yaml
# gateway.yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: cilium-gateway
  namespace: kube-system
spec:
  gatewayClassName: cilium
  infrastructure:
    annotations:
      io.cilium/lb-ipam-ips: "192.168.178.77"  # Replace with your desired IP
      cilium.io/hubble-visibility: "flow"
      cilium.io/preserve-client-cookies: "true"
      cilium.io/preserve-csrf-token: "true"
      io.cilium/websocket: "true"
      io.cilium/websocket-timeout: "3600"
  addresses:
    - type: IPAddress
      value: 192.168.178.77  # Replace with your desired IP
  listeners:
    - name: oc-proxy-https
      protocol: HTTPS
      port: 443
      hostname: "cloud.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
    - name: oc-minio-https
      protocol: HTTPS
      port: 443
      hostname: "minio.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
    - name: oc-minio-console-https
      protocol: HTTPS
      port: 443
      hostname: "console.minio.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
    - name: oc-keycloak-https
      protocol: HTTPS
      port: 443
      hostname: "keycloak.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
    - name: oc-wopi-https
      protocol: HTTPS
      port: 443
      hostname: "wopiserver.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
    - name: oc-onlyoffice-https
      protocol: HTTPS
      port: 443
      hostname: "onlyoffice.opencloud.test"
      tls:
        mode: Terminate
        certificateRefs:
          - name: opencloud-wildcard-tls
            namespace: kube-system
      allowedRoutes:
        namespaces:
          from: All
```

Apply the Gateway:

```bash
kubectl apply -f gateway.yaml
```

### Step 6: Configure DNS

Configure your DNS to point to the Gateway IP address. You can use a wildcard DNS record or individual records for each service:

```
*.opencloud.test  IN  A  192.168.178.77  # Replace with your Gateway IP
```

Alternatively, for local testing, you can add entries to your `/etc/hosts` file:

```
192.168.178.77  cloud.opencloud.test
192.168.178.77  keycloak.opencloud.test
192.168.178.77  minio.opencloud.test
192.168.178.77  onlyoffice.opencloud.test
192.168.178.77  collabora.opencloud.test
192.168.178.77  collaboration.opencloud.test
192.168.178.77  wopiserver.opencloud.test
```

### Step 7: Install OpenCloud

Finally, install OpenCloud using Helmfile:

```bash
# Clone the repository
git clone https://github.com/opencloud-eu/helm.git opencloud-helm
cd charts/opencloud-full/deployments

# Install OpenCloud
helmfile sync
```

### Troubleshooting

If you encounter issues with the OnlyOffice or Collabora pods connecting to the WOPI server, ensure that:

1. The WOPI server certificate is properly created in the kube-system namespace
2. The OnlyOffice/Collabora pod is configured with the correct token settings in the configmap
3. The Gateway is properly configured to route traffic to the WOPI server
4. The ReferenceGrant is properly configured to allow the Gateway to access the TLS certificates

You can check the status of the certificates:

```bash
kubectl get certificates -n kube-system
```

Check the logs of the OnlyOffice pod:

```bash
kubectl logs -n opencloud -l app.kubernetes.io/component=onlyoffice
```

Or check the logs of the Collabora pod:

```bash
kubectl logs -n opencloud -l app.kubernetes.io/component=collabora
```

You can also check the status of the HTTPRoutes:

```bash
kubectl get httproutes -n opencloud
```

For OnlyOffice-specific issues, check that the PostgreSQL, Redis, and RabbitMQ services are running correctly:

```bash
kubectl get pods -n opencloud -l app.kubernetes.io/component=onlyoffice-postgresql
kubectl get pods -n opencloud -l app.kubernetes.io/component=onlyoffice-redis
kubectl get pods -n opencloud -l app.kubernetes.io/component=onlyoffice-rabbitmq
```

## Setting up Ingress

For some deployments the kubernetes gateway API is not readily available. Using the traditional Ingress objects can be easier to
set up. The chart only deploys the necessary Ingress objects, e.g.
minio is not reachable.

### Step 1: Install cert-manager

Install cert-manager to manage TLS certificates:

```bash
# install the default cert manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

### Step 2: Create a ClusterIssuer for cert-manager

Create a ClusterIssuer for cert-manager to issue certificates:

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
```

Apply the ClusterIssuer:

```bash
kubectl apply -f cluster-issuer.yaml
```

### Step 3: Create a Wildcard Certificate for OpenCloud Domains

Create a wildcard certificate for all OpenCloud subdomains:

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: opencloud-wildcard-tls
  namespace: kube-system
spec:
  secretName: opencloud-wildcard-tls
  dnsNames:
    - "opencloud.test"
    - "*.opencloud.test"
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
```

Apply the certificate:

```bash
kubectl apply -f cluster-issuer.yaml
```

### Step 4: Install OpenCloud

Finally, install OpenCloud using Helm:

```bash
# Clone the repository
git clone https://github.com/your-repo/opencloud-helm.git
cd opencloud-helm
```

Customize the chart to use Ingress objects instead of the newer gateway API

```yaml
global:
  # TLS settings
  tls:
    # Enable TLS
    enabled: true
    secretName: opencloud-wildcard-tls

# Disable Gateway API configuration
httpRoute:
  enabled: false

# Enable ingress
ingress:
  enabled: true
  # onlyoffice requires adding an X-Forwarded-Proto header to the request.
  # The chart currently knows how to add this header for traefik, nginx,
  # haproxy, contour, and istio. PR welcome.
  annotationsPreset: "traefik"  # optional, default ""
  annotations:
    cert-manager.io/cluster-issuer: selfsigned-issuer
```

```bash
# Install OpenCloud
helm install opencloud . \
  --namespace opencloud \
  --create-namespace \
  --set httpRoute.gateway.name=opencloud-gateway \
  --set httpRoute.gateway.namespace=kube-system
```


### 🔧 Traefik Middleware for OnlyOffice
If you enable:
```yaml
ingress:
  enabled: true
  annotationsPreset: "traefik"
onlyoffice:
  enabled: true
```

The chart will automatically:
* Create a Traefik `Middleware` resource named `add-x-forwarded-proto-https` in the chart's namespace.
* Attach that Middleware to the OnlyOffice Ingress via:
  ```yaml
  traefik.ingress.kubernetes.io/router.middlewares: <namespace>-add-x-forwarded-proto-https@kubernetescrd
  ```

If you disable the preset and define custom annotations:
```yaml
annotationsPreset: ""
ingress.annotations:
  traefik.ingress.kubernetes.io/router.middlewares: my-custom-middleware@kubernetescrd
```
Then you are responsible for creating the referenced Middleware yourself.


## 📜 License

This project is licensed under the **AGPLv3** licence. See the [LICENSE](LICENSE) file for more details.

## Community Maintained

This repository is **community-maintained** and **not officially supported by OpenCloud GmbH**. Use at your own risk, and feel free to contribute to improve the project!