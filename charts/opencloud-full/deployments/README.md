# OpenCloud Full Deployment Example

## Introduction

This directory contains an example deployment for the OpenCloud Full Helm chart. It is designed to provide a quick and easy way to set up a functional OpenCloud environment for development and testing purposes.

**Important Note:** This example is not intended for production use. It is configured for ease of deployment in a development environment and does not include production-grade security, scalability, or high-availability considerations.

## Prerequisites

Before deploying this example, ensure you have the following tools installed and configured:

*   **Kubernetes Cluster:** A running Kubernetes cluster (e.g., Minikube, Kind, or a cloud-managed cluster).
*   **Cilium:** A CNI (Container Network Interface) and network policy engine for Kubernetes.
*   **Cilium Gateway API:** For managing external access to services.
*   **Helm v3:** The Kubernetes package manager.
    *   [Installation Guide](https://helm.sh/docs/intro/install/)
*   **Helmfile:** A declarative spec for deploying Helm charts.
    *   [Installation Guide](https://helmfile.readthedocs.io/helmfile/#installation)

## Installation

To deploy the OpenCloud Full example, navigate to this directory and execute the following command:

```bash
helmfile sync
```

This command will synchronize all the Helm charts and their dependencies as defined in the `helmfile.yaml` within this directory.

## Configuration

The default configuration for this deployment is set in the `values.yaml` and `valuesOverride.yaml` files within the `opencloud-full` chart. You may need to adjust certain parameters, such as `externalDomain`, to match your environment.

If you wish to access the deployed services via a custom hostname, you might need to add an entry to your local `/etc/hosts` file pointing to the IP address exposed by your Cilium Gateway API. For example:

```
<CILIUM_GATEWAY_API_IP> opencloud.kube.opencloud.test
```

## Usage

Once the deployment is complete, you should be able to access the OpenCloud instance.

### Accessing the Admin Panel

To log in to the OpenCloud admin panel, you will need the administrator password. Retrieve it using the following `kubectl` command:

```bash
kubectl -n oc get secrets/admin-user --template='{{.data.password | base64decode | printf "%s\n" }}'
```

Use the retrieved password with the username `admin` to log in.

### Limitations

This deployment example uses `ReadWriteOnce` storage access mode for persistence. This means that persistent volumes can only be mounted by a single pod at a time. If you plan to scale your applications, you will need to configure your storage class to support `ReadWriteMany` access mode, provided your underlying storage provider supports it.

## Development Considerations

This chart is primarily configured for development purposes. Features like `demoUsers` are enabled by default to facilitate quick setup and testing. It is strongly advised against using this configuration in a production environment without significant modifications and hardening.
