bundle: {
    apiVersion: "v1alpha1"
    name:       "opencloud"
    instances: {
        "opencloud": {
            module: {
                url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
                version: "latest"
            }
            namespace: "opencloud"
            values: {
                repository: {
                    url: "oci://ghcr.io/opencloud-eu/helm-charts"
                }
                chart: {
                    name:    "opencloud-microservices"
                    version: "0.3.4"
                }
                sync: {
                    timeout: 10
                    createNamespace: true
                }
                helmValues: {
                    // Global persistence indirection (like _domainFilter pattern)
                    _persistenceStorageClassName: string @timoni(runtime:string:PERSISTENCE_STORAGE_CLASS_NAME)
                    _persistenceAccessModes:     string @timoni(runtime:string:PERSISTENCE_ACCESS_MODES)

                    deploymentStrategy: {
                        type: string @timoni(runtime:string:DEPLOY_TYPE)
                        rollingUpdate: {
                            maxSurge: string @timoni(runtime:string:MAX_SURGE)
                            maxUnavailable: string @timoni(runtime:string:MAX_UNAV)
                        }
                    }

                    logging: {
                        level: string @timoni(runtime:string:OPENCLOUD_LOGGING_LEVEL)
                    }
                    externalDomain: string @timoni(runtime:string:EXTERNAL_DOMAIN)
                    image: {
                        tag: string @timoni(runtime:string:TAG)
                    }
                    keycloak: {
                        enabled: bool @timoni(runtime:bool:KEYCLOAK_ENABLED)
                        domain: string @timoni(runtime:string:KEYCLOAK_DOMAIN)
                        postgresql: {
                            password: string @timoni(runtime:string:KEYCLOAK_POSTGRESQL_PASSWORD)
                        }
                        config: {
                            adminPassword: string @timoni(runtime:string:KEYCLOAK_ADMIN_PASSWORD)
                        }
                    }
                    minio: {
                        enabled: bool @timoni(runtime:bool:MINIO_ENABLED)
                        domain: string @timoni(runtime:string:MINIO_DOMAIN)
                        config: {
                            rootPassword: string @timoni(runtime:string:MINIO_ROOT_PASSWORD)
                            persistence: {
                                size: string @timoni(runtime:string:MINIO_PERSISTENCE_SIZE)
                            }
                        }
                    }
                    collabora: {
                        enabled: bool @timoni(runtime:bool:COLLABORA_ENABLED)
                        domain: string @timoni(runtime:string:COLLABORA_DOMAIN)
                    }
                    onlyoffice: {
                        enabled: bool @timoni(runtime:bool:ONLYOFFICE_ENABLED)
                        domain: string @timoni(runtime:string:ONLYOFFICE_DOMAIN)
                        persistence: {
                            size: string @timoni(runtime:string:ONLYOFFICE_PERSISTENCE_SIZE)
                        }
                        config: {
                            coAuthoring: {
                                secret: {
                                    inbox: string @timoni(runtime:string:ONLYOFFICE_INBOX)
                                    outbox: string @timoni(runtime:string:ONLYOFFICE_OUTBOX)
                                    session: string @timoni(runtime:string:ONLYOFFICE_SESSION)
                                }
                            }
                            rabbitmq: {
                                url: string @timoni(runtime:string:AMQP_URL)
                            }
                        }
                    }
                    ingress: {
                        enabled: bool @timoni(runtime:bool:INGRESS_ENABLED)
                        ingressClassName: string @timoni(runtime:string:INGRESS_CLASS_NAME)
                        annotations: {
                            "nginx.ingress.kubernetes.io/proxy-body-size": string @timoni(runtime:string:INGRESS_PROXY_BODY_SIZE)
                        }
                    }
                    insecure: {
                        oidcIdpInsecure: bool @timoni(runtime:bool:OIDC_IDP_INSECURE)
                        ocHttpApiInsecure: bool @timoni(runtime:bool:OC_HTTP_API_INSECURE)
                    }
                    secretRefs: {
                        ldapSecretRef: "ldap-bind-secrets"
                        s3CredentialsSecretRef: "s3secret"
                    }
                    gateway: {
                        httproute: {
                            enabled: bool @timoni(runtime:bool:GATEWAY_HTTPROUTE_ENABLED)
                        }
                    }
                    features: {
                        demoUsers: bool @timoni(runtime:bool:DEMO_USERS_ENABLED)
                        virusscan: {
                            enabled: bool @timoni(runtime:bool:ANTIVIRUS_ENABLED)
                            infectedFileHandling: string @timoni(runtime:string:ANTIVIRUS_INFECTED_FILE_HANDLING)
                            icap: {
                                url: string @timoni(runtime:string:ANTIVIRUS_ICAP_URL)
                                service: string @timoni(runtime:string:ANTIVIRUS_ICAP_SERVICE)
                            }
                        }
                        quotas: {
                            default: string @timoni(runtime:string:QUOTAS_DEFAULT)
                            roles: {
                                // Guest Role set to 20GB
                                "38071a68-456a-4553-846a-fa67bf5596cc": int @timoni(runtime:number:QUOTAS_GUEST)
                                // User Role set to 300GB
                                "d7beeea8-8ff4-406b-8fb6-ab2dd81e6b11": int @timoni(runtime:number:QUOTAS_USER)
                                // Space Administrator Role set to 100TB
                                "2aadd357-682c-406b-8874-293091995fdd": int @timoni(runtime:number:QUOTAS_SPACE_ADMIN)
                            }
                        }
                        externalUserManagement: {
                            enabled: bool @timoni(runtime:bool:EXTERNAL_USER_MANAGEMENT_ENABLED)
                            adminUUID: string @timoni(runtime:string:EXTERNAL_USER_MANAGEMENT_ADMIN_UUID)
                            autoprovisionAccounts: {
                                enabled: bool @timoni(runtime:bool:AUTOPROVISION_ACCOUNTS_ENABLED)
                                claimUserName: string @timoni(runtime:string:AUTOPROVISION_ACCOUNTS_CLAIM_USER_NAME)
                            }
                            oidc: {
                                domain: string @timoni(runtime:string:KEYCLOAK_DOMAIN)
                                issuerURI: string @timoni(runtime:string:OIDC_ISSUER_URI)
                                userIDClaim: string @timoni(runtime:string:OIDC_USER_ID_CLAIM)
                                userIDClaimAttributeMapping: string @timoni(runtime:string:OIDC_USER_ID_CLAIM_ATTRIBUTE_MAPPING)
                                roleAssignment: {
                                    claim: string @timoni(runtime:string:OIDC_ROLE_ASSIGNMENT_CLAIM)
                                }
                            }
                            ldap: {
                                writeable: bool @timoni(runtime:bool:LDAP_WRITEABLE)
                                uri: string @timoni(runtime:string:LDAP_URI)
                                insecure: bool @timoni(runtime:bool:LDAP_INSECURE)
                                bindDN: string @timoni(runtime:string:LDAP_BIND_DN)
                                user: {
                                    userNameMatch: string @timoni(runtime:string:LDAP_USER_NAME_MATCH)
                                    schema: {
                                        id: string @timoni(runtime:string:LDAP_USER_SCHEMA_ID)
                                    }
                                }
                                group: {
                                    schema: {
                                        id: string @timoni(runtime:string:LDAP_GROUP_SCHEMA_ID)
                                    }
                                }
                            }
                        }

                        appsIntegration: {
                            enabled: bool @timoni(runtime:bool:APPS_INTEGRATION_ENABLED)
                            wopiIntegration: {
                                officeSuites: [
                                    {
                                        name: "Collabora",
                                        product: "Collabora",
                                        enabled: bool @timoni(runtime:bool:COLLABORA_ENABLED),
                                        uri: string @timoni(runtime:string:COLLABORA_URI),
                                        insecure: bool @timoni(runtime:bool:COLLABORA_INSECURE),
                                        disableProof: bool @timoni(runtime:bool:COLLABORA_DISABLE_PROOF),
                                        iconURI: string @timoni(runtime:string:COLLABORA_ICON_URI),
                                        ingress: {
                                            enabled: bool @timoni(runtime:bool:COLLABORA_INGRESS_ENABLED)
                                            domain: string @timoni(runtime:string:WOPI_INGRESS_DOMAIN)
                                            ingressClassName: string @timoni(runtime:string:COLLABORA_INGRESS_CLASS_NAME)
                                            annotations: {
                                                "nginx.ingress.kubernetes.io/proxy-body-size": string @timoni(runtime:string:COLLABORA_INGRESS_PROXY_BODY_SIZE)
                                            }
                                        }
                                    },
                                    {
                                        name: "OnlyOffice",
                                        product: "OnlyOffice",
                                        enabled: bool @timoni(runtime:bool:ONLYOFFICE_ENABLED),
                                        uri: string @timoni(runtime:string:ONLYOFFICE_URI),
                                        insecure: bool @timoni(runtime:bool:ONLYOFFICE_INSECURE),
                                        disableProof: bool @timoni(runtime:bool:ONLYOFFICE_DISABLE_PROOF),
                                        iconURI: string @timoni(runtime:string:ONLYOFFICE_ICON_URI),
                                        ingress: {
                                            enabled: bool @timoni(runtime:bool:ONLYOFFICE_INGRESS_ENABLED)
                                        }
                                    }
                                ]
                            }
                        }
                    }
                    services: {
                        nats: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:NATS_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:NATS_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                                chownInitContainer: bool @timoni(runtime:bool:NATS_PERSISTENCE_CHOWN_INIT_CONTAINER)
                            }
                        }
                        search: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:SEARCH_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:SEARCH_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                            extractor: {
                                type: string @timoni(runtime:string:SEARCH_EXTRACTOR_TYPE)
                            }
                        }
                        storagesystem: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:STORAGE_SYSTEM_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:STORAGE_SYSTEM_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                        }
                        storageusers: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:STORAGE_USERS_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:STORAGE_USERS_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                            storageBackend: {
                                driver: string @timoni(runtime:string:STORAGE_USERS_BACKEND_DRIVER)
                            }
                        }
                        thumbnails: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:THUMBNAILS_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:THUMBNAILS_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                        }
                        web: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:WEB_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:WEB_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                            config: {
                                oidc: {
                                    webClientID: string @timoni(runtime:string:WEB_OIDC_WEB_CLIENT_ID)
                                }
                                externalApps: {
                                    "external-sites": {
                                        config: {
                                            sites: [
                                                {
                                                    name: "openCloud"
                                                    url: string @timoni(runtime:string:OPENCLOUD_WEB_URL)
                                                    target: "external"
                                                    color: "#0D856F"
                                                    icon: "cloud"
                                                    priority: 50
                                                }
                                            ]
                                        }
                                    }
                                }
                            }
                            additionalInitContainers: [
                                {
                                    name: "external-sites"
                                    image: "opencloudeu/web-extensions:external-sites-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/external-sites /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                },
                                {
                                    name: "drawio"
                                    image: "opencloudeu/web-extensions:draw-io-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/draw-io /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                },
                                {
                                    name: "importer"
                                    image: "opencloudeu/web-extensions:importer-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/importer /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                },
                                {
                                    name: "jsonviewer"
                                    image: "opencloudeu/web-extensions:json-viewer-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/json-viewer /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                },
                                {
                                    name: "progressbars"
                                    image: "opencloudeu/web-extensions:progress-bars-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/progress-bars /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                },
                                {
                                    name: "unzip"
                                    image: "opencloudeu/web-extensions:unzip-1.0.0"
                                    command: [
                                        "/bin/sh",
                                        "-c",
                                        "cp -R /usr/share/nginx/html/unzip /apps"
                                    ]
                                    volumeMounts: [
                                        {
                                            name: "apps"
                                            mountPath: "/apps"
                                        }
                                    ]
                                }
                            ]
                        }
                        idm: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:IDM_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:IDM_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                        }
                        ocm: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:OCM_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:OCM_PERSISTENCE_SIZE)
                                storageClassName: "\(_persistenceStorageClassName)"
                                accessModes: [ "\(_persistenceAccessModes)" ]
                            }
                        }
                    }
                }
            }
        },
    }
}
