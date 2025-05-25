bundle: {
    apiVersion: "v1alpha1"
    name:       "opencloud"
    instances: {
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
                    name:    "opencloud-full"
                    version: "2.0.2"
                }
                sync: {
                    timeout: 5
                    createNamespace: true
                }
                helmValues: {
                    logging: {
                        level: "debug"
                    }
                    externalDomain: string @timoni(runtime:string:EXTERNAL_DOMAIN)
                    keycloak: {
                        enabled: true
                        domain: string @timoni(runtime:string:KEYCLOAK_DOMAIN)
                    }
                    minio: {
                        enabled: true
                        domain: string @timoni(runtime:string:MINIO_DOMAIN)
                    }
                    ingress: {
                        enabled: false
                        ingressClassName: "nginx"
                        annotations: {
                            "nginx.ingress.kubernetes.io/proxy-body-size": "1024m"
                        }
                    }
                    insecure: {
                        oidcIdpInsecure: true
                        ocHttpApiInsecure: true
                    }
                    secretRefs: {
                        ldapSecretRef: "ldap-bind-secrets"
                        s3CredentialsSecretRef: "s3secret"
                    }
                    gateway: {
                        httproute: {
                            enabled: true
                        }
                    }
                    features: {
                        externalUserManagement: {
                            enabled: true
                            adminUUID: "0ab77e6d-23b4-4ba3-9843-a3b3efdcfc53"
                            autoprovisionAccounts: {
                                enabled: true
                                claimUserName: "sub"
                            }
                            oidc: {
                                domain: string @timoni(runtime:string:KEYCLOAK_DOMAIN)
                                issuerURI: string @timoni(runtime:string:OIDC_ISSUER_URI)
                                userIDClaim: "sub"
                                userIDClaimAttributeMapping: "username"
                            }
                            ldap: {
                                writeable: true
                                uri: string @timoni(runtime:string:LDAP_URI)
                                insecure: true
                                bindDN: "cn=admin,dc=opencloud,dc=eu"
                                user: {
                                    userNameMatch: "none"
                                    schema: {
                                        id: "openCloudUUID"
                                    }
                                }
                                group: {
                                    schema: {
                                        id: "openCloudUUID"
                                    }
                                }
                            }
                        }
                        appsIntegration: {
                            enabled: true
                            wopiIntegration: {
                                officeSuites: [
                                    {
                                        name: "Collabora",
                                        product: "Collabora",
                                        enabled: false,
                                        uri: string @timoni(runtime:string:COLLABORA_URI),
                                        insecure: true,
                                        disableProof: false,
                                        iconURI: string @timoni(runtime:string:COLLABORA_ICON_URI),
                                        ingress: {
                                            enabled: false
                                            domain: string @timoni(runtime:string:WOPI_INGRESS_DOMAIN)
                                            ingressClassName: "nginx"
                                            annotations: {
                                                "nginx.ingress.kubernetes.io/proxy-body-size": "1024m"
                                            }                                         
                                        }
                                    },
                                    {
                                        name: "OnlyOffice",
                                        product: "OnlyOffice",
                                        enabled: true,
                                        uri: string @timoni(runtime:string:ONLYOFFICE_URI),
                                        insecure: true,
                                        disableProof: false,
                                        iconURI: string @timoni(runtime:string:ONLYOFFICE_ICON_URI),
                                        ingress: {
                                            enabled: false
                                        }
                                    }
                                ]
                            }
                        }
                    }
                    services: {
                        nats: {
                            persistence: {
                                enabled: true
                            }
                        }
                        search: {
                            persistence: {
                                enabled: true
                            }
                            extractor: {
                                type: "tika"
                            }
                        }
                        storagesystem: {
                            persistence: {
                                enabled: true
                            }
                        }
                        storageusers: {
                            persistence: {
                                enabled: true
                            }
                            storageBackend: {
                                driver: "decomposeds3"
                            }
                        }
                        thumbnails: {
                            persistence: {
                                enabled: true
                            }
                        }
                        web: {
                            persistence: {
                                enabled: true
                            }
                            config: {
                                oidc: {
                                    webClientID: "web"
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
                                enabled: false
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
                    timeout: 25
                    createNamespace: true
                }
                helmValues: {
                    ltb_passwd: {
                        enabled: false
                    }
                    replication: {
                        enabled: true
                    }
                    global: {
                        ldapDomain: string @timoni(runtime:string:LDAP_GLOBAL_DOMAIN)
                        adminPassword: "admin" 
                        configPassword: "config"
                    }
                    customLdifFiles: {
                        opencloud_root_ldif: """
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
                            uid: ldapadmin

                            dn: ou=groups,dc=opencloud,dc=eu
                            objectClass: organizationalUnit
                            ou: groups

                            dn: ou=custom,ou=groups,dc=opencloud,dc=eu
                            objectClass: organizationalUnit
                            ou: custom
                            """
                        users_ldif: ""
                        groups_ldif: """
                            dn: cn=users,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: users
                            description: Users
                            member: uid=alan,ou=users,dc=opencloud,dc=eu
                            member: uid=mary,ou=users,dc=opencloud,dc=eu
                            member: uid=margaret,ou=users,dc=opencloud,dc=eu
                            member: uid=dennis,ou=users,dc=opencloud,dc=eu
                            member: uid=lynn,ou=users,dc=opencloud,dc=eu
                            member: uid=admin,ou=users,dc=opencloud,dc=eu

                            dn: cn=chess-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: chess-lovers
                            description: Chess lovers
                            member: uid=alan,ou=users,dc=opencloud,dc=eu

                            dn: cn=machine-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: machine-lovers
                            description: Machine Lovers
                            member: uid=alan,ou=users,dc=opencloud,dc=eu

                            dn: cn=bible-readers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: bible-readers
                            description: Bible readers
                            member: uid=mary,ou=users,dc=opencloud,dc=eu

                            dn: cn=apollos,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: apollos
                            description: Contributors to the Appollo mission
                            member: uid=margaret,ou=users,dc=opencloud,dc=eu

                            dn: cn=unix-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: unix-lovers
                            description: Unix lovers
                            member: uid=dennis,ou=users,dc=opencloud,dc=eu

                            dn: cn=basic-haters,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: basic-haters
                            description: Haters of the Basic programming language
                            member: uid=dennis,ou=users,dc=opencloud,dc=eu

                            dn: cn=vlsi-lovers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: vlsi-lovers
                            description: Lovers of VLSI microchip design
                            member: uid=lynn,ou=users,dc=opencloud,dc=eu

                            dn: cn=programmers,ou=groups,dc=opencloud,dc=eu
                            objectClass: groupOfNames
                            objectClass: top
                            cn: programmers
                            description: Computer Programmers
                            member: uid=alan,ou=users,dc=opencloud,dc=eu
                            member: uid=margaret,ou=users,dc=opencloud,dc=eu
                            member: uid=dennis,ou=users,dc=opencloud,dc=eu
                            member: uid=lynn,ou=users,dc=opencloud,dc=eu
                            """
                    }
                    customSchemaFiles: {
                        "10_opencloud_schema_ldif": """
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
