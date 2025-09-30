bundle: {
    apiVersion: "v1alpha1"
    name:       "clamav"
    instances: {
        // "service-account": {
        //     module: url: "oci://ghcr.io/stefanprodan/modules/flux-tenant"
        //     namespace: "opencloud"
        //     values: {
        //         role: "namespace-admin"
        //         resourceQuota: {
        //             kustomizations: 100
        //             helmreleases:   100
        //         }
        //     }
        // },
      
        "clamav": {
            module: {
                url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
                version: "latest"
            }
            namespace: "clamav"
            values: {
                repository: {
                    url: "https://gitlab.opencode.de/api/v4/projects/1381/packages/helm/stable"
                }
                chart: {
                    name:    "opendesk-clamav"
                    version: "4.0.6"
                }
                sync: {
                    timeout: 5
                    createNamespace: true
                }
                helmValues: {
                    // Global persistence indirection (like _domainFilter pattern)
                    _persistenceStorageClassName: string @timoni(runtime:string:PERSISTENCE_STORAGE_CLASS_NAME)
                    _persistenceAccessModes:     string @timoni(runtime:string:PERSISTENCE_ACCESS_MODES)

                    replicaCount: string @timoni(runtime:string:CLAMAV_REPLICA_COUNT)
                    resources: {
                        limits: {
                            cpu: string @timoni(runtime:string:CLAMAV_RESOURCES_LIMITS_CPU)
                            memory: string @timoni(runtime:string:CLAMAV_RESOURCES_LIMITS_MEMORY)
                        }
                        requests: {
                            cpu: string @timoni(runtime:string:CLAMAV_RESOURCES_REQUESTS_CPU)
                            memory: string @timoni(runtime:string:CLAMAV_RESOURCES_REQUESTS_MEMORY)
                        }
                    }
                    persistence: {
                        accessModes: [ "\(_persistenceAccessModes)" ]
                        size: string @timoni(runtime:string:CLAMAV_PERSISTENCE_SIZE)
                        storageClass: "\(_persistenceStorageClassName)"
                    }
                    freshclam: {
                        image: {
                            tag: string @timoni(runtime:string:CLAMAV_FRESHCLAM_IMAGE_TAG)
                        }
                    }
                    clamd: {
                        image: {
                            tag: string @timoni(runtime:string:CLAMAV_CLAMD_IMAGE_TAG)
                        }
                    }
                    icap: {
                        image: {
                            registry:   string @timoni(runtime:string:CLAMAV_ICAP_IMAGE_REGISTRY)
                            repository: string @timoni(runtime:string:CLAMAV_ICAP_IMAGE_REPOSITORY)
                            tag:        string @timoni(runtime:string:CLAMAV_ICAP_IMAGE_TAG)
                        }

                        settings: {
                            clamdModClamdHost: string @timoni(runtime:string:CLAMAV_ICAP_CLAMD_HOST)
                            tmpDir: "/icap-tmp"
                        }

                        extraVolumes: [
                            {
                                name: "icap-tmp"
                                emptyDir: {}
                            }
                        ]

                        extraVolumeMounts: [
                            {
                                name:      "icap-tmp"
                                mountPath: "/icap-tmp"
                            }
                        ]

                        lifecycleHooks: {
                            postStart: {
                                exec: {
                                    command: [
                                    "sh", "-c",
                                    "rm -f /var/run/c-icap/c-icap.* /var/tmp/c-icap.* || true"
                                    ]
                                }
                            }
                        }
                    }
                    milter: {
                        settings: {
                            clamdHost: string @timoni(runtime:string:CLAMAV_MILTER_CLAMD_HOST)
                        }
                    }
                }
            }
        }
    }
}
