# OpenCloud with NATS deployment example

## Introduction

This example shows how to deploy OpenCloud with NATS as message bus and store.
It will deploy an OpenCloud instance and NATS, preconfigured to work together.

***Note***: This example is not intended for production use. It is intended to get a working OpenCloud
with NATS running in Kubernetes as quickly as possible. It is not hardened in any way.

## Getting started

### Prerequisites

This example requires the following things to be installed:

- [Kubernetes](https://kubernetes.io/) cluster, with an ingress controller installed.
- [Helm](https://helm.sh/) v3
- [Helmfile](https://github.com/helmfile/helmfile)

### End result

After following the steps in this guide, you should be able to access the following endpoint, you
may want to add these to your `/etc/hosts` file pointing to your ingress controller IP:

- https://cloud.opencloud.test

Note that if you want to use your own hostname and domain, you will have to change the `global.domain.opencloud` value.

### Deploying

In this directory, run the following commands:

```bash
$ helmfile sync
```

This will deploy OpenCloud and NATS.
