bundle: {
    apiVersion: "v1alpha1"
    name:       "opencloud"
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
        "opencloud": {
            module: {
                url:     "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
                version: "latest"
            }
            namespace: "opencloud"
            values: {
                repository: {
                    url: "oci://ghcr.io/suse-coder/helm-charts"
                }
                chart: {
                    name:    "opencloud-microservices"
                    version: "*"
                }
                sync: {
                    timeout: 10
                    createNamespace: true
                }
                helmValues: {
                    logging: {
                        level: string @timoni(runtime:string:OPENCLOUD_LOGGING_LEVEL)
                    }
                    externalDomain: string @timoni(runtime:string:EXTERNAL_DOMAIN)
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
                    onlyoffice: {
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
                            }
                        }
                        search: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:SEARCH_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:SEARCH_PERSISTENCE_SIZE)
                            }
                            extractor: {
                                type: string @timoni(runtime:string:SEARCH_EXTRACTOR_TYPE)
                            }
                        }
                        storagesystem: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:STORAGE_SYSTEM_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:STORAGE_SYSTEM_PERSISTENCE_SIZE)
                            }
                        }
                        storageusers: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:STORAGE_USERS_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:STORAGE_USERS_PERSISTENCE_SIZE)
                            }
                            storageBackend: {
                                driver: string @timoni(runtime:string:STORAGE_USERS_BACKEND_DRIVER)
                            }
                        }
                        thumbnails: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:THUMBNAILS_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:THUMBNAILS_PERSISTENCE_SIZE)
                            }
                        }
                        web: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:WEB_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:WEB_PERSISTENCE_SIZE)
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
                                    image: "opencloudeu/web-extensions:external-sites-latest"
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
                                    image: "opencloudeu/web-extensions:draw-io-latest"
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
                                    image: "opencloudeu/web-extensions:importer-latest"
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
                                    image: "opencloudeu/web-extensions:json-viewer-latest"
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
                                    image: "opencloudeu/web-extensions:progress-bars-latest"
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
                                    image: "opencloudeu/web-extensions:unzip-latest"
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
                            }
                        }
                        ocm: {
                            persistence: {
                                enabled: bool @timoni(runtime:bool:OCM_PERSISTENCE_ENABLED)
                                size: string @timoni(runtime:string:OCM_PERSISTENCE_SIZE)
                            }
                        }
                    }
                }
            }
        },
        "openldap": {
            module: {
                url:     "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
                version: "latest"
            }
            namespace: "openldap"
            values: {
                repository: {
                    url: "https://jp-gouin.github.io/helm-openldap/"
                }
                chart: {
                    name:    "openldap-stack-ha"
                    version: "4.3.3"
                }
                sync: {
                    timeout: 5
                    createNamespace: true
                }
                helmValues: {
                    "ltb-passwd": {
                        enabled: bool @timoni(runtime:bool:OPENLDAP_LTB_PASSWD_ENABLED)
                    }
                    replication: {
                        enabled: bool @timoni(runtime:bool:OPENLDAP_REPLICATION_ENABLED)
                    }
                    replicaCount: string @timoni(runtime:string:OPENLDAP_REPLICA_COUNT)
                    global: {
                        ldapDomain: string @timoni(runtime:string:LDAP_GLOBAL_DOMAIN)
                        adminPassword: string @timoni(runtime:string:LDAP_ADMIN_PASSWORD)
                        configPassword: string @timoni(runtime:string:LDAP_CONFIG_PASSWORD)
                    }
                    customLdifFiles: {
                        "opencloud_root.ldif": """
                            dn: dc=opencloud,dc=eu
                            objectClass: organization
                            objectClass: dcObject
                            dc: opencloud
                            o: openCloud

                            dn: ou=users,dc=opencloud,dc=eu
                            objectClass: organizationalUnit
                            ou: users

                            dn: cn=admin,dc=opencloud,dc=eu
                            objectClass: inetOrgPerson
                            objectClass: person
                            cn: admin
                            sn: admin

                            dn: ou=groups,dc=opencloud,dc=eu
                            objectClass: organizationalUnit
                            ou: groups

                            dn: ou=custom,ou=groups,dc=opencloud,dc=eu
                            objectClass: organizationalUnit
                            ou: custom
                            """
                        "users.ldif": """
                            """
                        "groups.ldif": """
                            dn: cn=users,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: users
                            dn: cn=chess-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: chess-lovers
                            description: Chess lovers

                            dn: cn=machine-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: machine-lovers
                            description: Machine Lovers

                            dn: cn=bible-readers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: bible-readers
                            description: Bible readers

                            dn: cn=apollos,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: apollos
                            description: Contributors to the Appollo mission

                            dn: cn=unix-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: unix-lovers
                            description: Unix lovers

                            dn: cn=basic-haters,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: basic-haters
                            description: Haters of the Basic programming language

                            dn: cn=vlsi-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: vlsi-lovers
                            description: Lovers of VLSI microchip design

                            dn: cn=programmers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: programmers
                            description: Computer Programmers
                            """
                    }
                    customSchemaFiles: {
                        "10_opencloud_schema.ldif": """
                            dn: cn=opencloud,cn=schema,cn=config
                            objectClass: olcSchemaConfig
                            cn: opencloud
                            olcObjectIdentifier: openCloudOid 1.3.6.1.4.1.63016
                            # We'll use openCloudOid:1 subarc for LDAP related stuff
                            #   openCloudOid:1.1 for AttributeTypes and openCloudOid:1.2 for ObjectClasses
                            olcAttributeTypes: ( openCloudOid:1.1.1 NAME 'openCloudUUID'
                              DESC 'A non-reassignable and persistent account ID)'
                              EQUALITY uuidMatch
                              SUBSTR caseIgnoreSubstringsMatch
                              SYNTAX 1.3.6.1.1.16.1 SINGLE-VALUE )
                            olcAttributeTypes: ( openCloudOid:1.1.2 NAME 'openCloudExternalIdentity'
                              DESC 'A triple separated by "$" representing the objectIdentity resource type of the Graph API ( signInType $ issuer $ issuerAssignedId )'
                              EQUALITY caseIgnoreMatch
                              SUBSTR caseIgnoreSubstringsMatch
                              SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
                            olcAttributeTypes: ( openCloudOid:1.1.3 NAME 'openCloudUserEnabled'
                              DESC 'A boolean value indicating if the user is enabled'
                              EQUALITY booleanMatch
                              SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE)
                            olcAttributeTypes: ( openCloudOid:1.1.4 NAME 'openCloudUserType'
                              DESC 'User type (e.g. Member or Guest)'
                              EQUALITY caseIgnoreMatch
                              SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )
                            olcAttributeTypes: ( openCloudOid:1.1.5 NAME 'openCloudLastSignInTimestamp'
                              DESC 'The timestamp of the last sign-in'
                              EQUALITY generalizedTimeMatch
                              ORDERING generalizedTimeOrderingMatch
                              SYNTAX  1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE )
                            olcObjectClasses: ( openCloudOid:1.2.1 NAME 'openCloudObject'
                              DESC 'OpenCloud base objectclass'
                              AUXILIARY
                              MAY ( openCloudUUID ) )
                            olcObjectClasses: ( openCloudOid:1.2.2 NAME 'openCloudUser'
                              DESC 'OpenCloud User objectclass'
                              SUP openCloudObject
                              AUXILIARY
                              MAY ( openCloudExternalIdentity $ openCloudUserEnabled $ openCloudUserType $ openCloudLastSignInTimestamp) )
                            """
                    }
                }
            }
        }
    }
}
