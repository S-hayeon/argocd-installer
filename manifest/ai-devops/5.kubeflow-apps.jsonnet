function (
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving", 
    tmaxcloud_image_repo="docker.io/tmaxcloudck",
    istio_image_repo="docker.io/istio",
    gatewaySelector="ingressgateway",
    kubeflow_public_image_repo="gcr.io/kubeflow-images-public",
    katib_image_repo="docker.io/kubeflowkatib",
    katib_image_tag="v0.12.0",
    katib_object_image_tag="v0.11.0",
    mysql_deploy_image_repo="mysql",
    mysql_deploy_image_tag="8.0.27",
    argo_image_repo="docker.io/argoproj",
    argo_image_tag="v2.12.10",
    minio_image_repo="gcr.io/ml-pipeline/minio",
    minio_image_tag="RELEASE.2019-08-14T20-37-41Z-license-compliance",
    notebook_svc_type="Ingress",
    custom_domain_name="tmaxcloud.org",
    knative_serving_image_repo="gcr.io/knative-releases/knative.dev/serving/cmd",
    knative_istio_image_repo="gcr.io/knative-releases/knative.dev/net-istio/cmd",
    knative_serving_image_tag="v0.14.3",
    knative_istio_image_tag="v0.14.1",
    kfserving_image_tag="v0.5.1",
    kfserving_gcr_image_repo="gcr.io/kfserving",
    kfserving_docker_image_repo="docker.io/kfserving",
    kube_rbac_proxy_image_repo="gcr.io/kubebuilder/kube-rbac-proxy",
    kube_rbac_proxy_image_tag="v0.4.0",
    tensorflow_image_repo="docker.io/tensorflow/serving",
    tensorflow_image_tag="1.14.0",
    tensorflow_image_gpu_tag="1.14.0-gpu",
    onnx_image_repo="mcr.microsoft.com/onnxruntime/server",
    onnx_image_tag="v1.0.0",
    mlserver_image_repo="docker.io/seldonio/mlserver",
    mlserver_image_tag="0.2.1",
    pytorch_server_image_gpu_tag="v0.5.1-gpu",
    torchserve_kfs_image_tag="0.3.0",
    torchserve_kfs_image_gpu_tag="0.3.0-gpu",
    triton_image_repo="nvcr.io/nvidia/tritonserver",
    triton_image_tag="20.08-py3"
)
[
    {
    "apiVersion": "app.k8s.io/v1beta1",
    "kind": "Application",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "kubeflow"
    },
    "spec": {
        "addOwnerRef": true,
        "componentKinds": [
        {
            "group": "app.k8s.io",
            "kind": "Application"
        }
        ],
        "descriptor": {
        "description": "application that aggregates all kubeflow applications",
        "keywords": [
            "kubeflow"
        ],
        "links": [
            {
            "description": "About",
            "url": "https://kubeflow.org"
            }
        ],
        "maintainers": [
            {
            "email": "jlewi@google.com",
            "name": "Jeremy Lewi"
            },
            {
            "email": "kam.d.kasravi@intel.com",
            "name": "Kam Kasravi"
            }
        ],
        "owners": [
            {
            "email": "jlewi@google.com",
            "name": "Jeremy Lewi"
            }
        ],
        "type": "kubeflow",
        "version": "v1beta1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "kubeflow",
            "app.kubernetes.io/instance": "kubeflow-v0.7.0",
            "app.kubernetes.io/managed-by": "kfctl",
            "app.kubernetes.io/name": "kubeflow",
            "app.kubernetes.io/part-of": "kubeflow",
            "app.kubernetes.io/version": "v0.7.0"
        }
        }
    }
    },
    {
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "name": "kubeflow-admin"
    },
    "rules": []
    },
    {
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "name": "kubeflow-edit",
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
        }
    },
    "rules": [
        {
        "apiGroups": [
            "tekton.dev"
        ],
        "resources": [
            "tasks",
            "taskruns",
            "pipelines",
            "pipelineruns",
            "pipelineresources",
            "conditions"
        ],
        "verbs": [
            "*"
        ]
        }
    ]
    },
    {
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "name": "kubeflow-view",
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true"
        }
    },
    "rules": []
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "name": "kubeflow-kubernetes-admin",
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
        }
    },
    "rules": [
        {
        "apiGroups": [
            "authorization.k8s.io"
        ],
        "resources": [
            "localsubjectaccessreviews"
        ],
        "verbs": [
            "create"
        ]
        },
        {
        "apiGroups": [
            "rbac.authorization.k8s.io"
        ],
        "resources": [
            "rolebindings",
            "roles"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "get",
            "list",
            "patch",
            "update",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true"
        },
        "name": "kubeflow-kubernetes-edit"
    },
    "rules": [
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "pods/attach",
            "pods/exec",
            "pods/portforward",
            "pods/proxy",
            "secrets",
            "services/proxy"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "serviceaccounts"
        ],
        "verbs": [
            "impersonate"
        ]
        },
        {
        "apiGroups": [
            "tekton.dev"
        ],
        "resources": [
            "tasks",
            "taskruns",
            "pipelines",
            "pipelineruns",
            "pipelineresources",
            "conditions"
        ],
        "verbs": [
            "*"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "pods",
            "pods/attach",
            "pods/exec",
            "pods/portforward",
            "pods/proxy"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "configmaps",
            "endpoints",
            "persistentvolumeclaims",
            "replicationcontrollers",
            "replicationcontrollers/scale",
            "secrets",
            "serviceaccounts",
            "services",
            "services/proxy"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "apps"
        ],
        "resources": [
            "daemonsets",
            "deployments",
            "deployments/rollback",
            "deployments/scale",
            "replicasets",
            "replicasets/scale",
            "statefulsets",
            "statefulsets/scale"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "autoscaling"
        ],
        "resources": [
            "horizontalpodautoscalers"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "batch"
        ],
        "resources": [
            "cronjobs",
            "jobs"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "extensions"
        ],
        "resources": [
            "daemonsets",
            "deployments",
            "deployments/rollback",
            "deployments/scale",
            "ingresses",
            "networkpolicies",
            "replicasets",
            "replicasets/scale",
            "replicationcontrollers/scale"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "policy"
        ],
        "resources": [
            "poddisruptionbudgets"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        },
        {
        "apiGroups": [
            "networking.k8s.io"
        ],
        "resources": [
            "ingresses",
            "networkpolicies"
        ],
        "verbs": [
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view": "true"
        },
        "name": "kubeflow-kubernetes-view"
    },
    "rules": [
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "configmaps",
            "endpoints",
            "persistentvolumeclaims",
            "persistentvolumeclaims/status",
            "pods",
            "replicationcontrollers",
            "replicationcontrollers/scale",
            "serviceaccounts",
            "services",
            "services/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "bindings",
            "events",
            "limitranges",
            "namespaces/status",
            "pods/log",
            "pods/status",
            "replicationcontrollers/status",
            "resourcequotas",
            "resourcequotas/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "namespaces"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "apps"
        ],
        "resources": [
            "controllerrevisions",
            "daemonsets",
            "daemonsets/status",
            "deployments",
            "deployments/scale",
            "deployments/status",
            "replicasets",
            "replicasets/scale",
            "replicasets/status",
            "statefulsets",
            "statefulsets/scale",
            "statefulsets/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "autoscaling"
        ],
        "resources": [
            "horizontalpodautoscalers",
            "horizontalpodautoscalers/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "batch"
        ],
        "resources": [
            "cronjobs",
            "cronjobs/status",
            "jobs",
            "jobs/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "extensions"
        ],
        "resources": [
            "daemonsets",
            "daemonsets/status",
            "deployments",
            "deployments/scale",
            "deployments/status",
            "ingresses",
            "ingresses/status",
            "networkpolicies",
            "replicasets",
            "replicasets/scale",
            "replicasets/status",
            "replicationcontrollers/scale"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "policy"
        ],
        "resources": [
            "poddisruptionbudgets",
            "poddisruptionbudgets/status"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "networking.k8s.io"
        ],
        "resources": [
            "ingresses",
            "ingresses/status",
            "networkpolicies"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "creationTimestamp": null,
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles.kubeflow.org"
    },
    "spec": {
        "conversion": {
        "strategy": "None"
        },
        "group": "kubeflow.org",
        "names": {
        "kind": "Profile",
        "plural": "profiles"
        },
        "scope": "Cluster",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "description": "Profile is the Schema for the profiles API",
            "properties": {
            "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources",
                "type": "string"
            },
            "kind": {
                "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds",
                "type": "string"
            },
            "metadata": {
                "type": "object"
            },
            "spec": {
                "description": "ProfileSpec defines the desired state of Profile",
                "properties": {
                "owner": {
                    "description": "The profile owner",
                    "properties": {
                    "apiGroup": {
                        "description": "APIGroup holds the API group of the referenced subject. Defaults to \"\" for ServiceAccount subjects. Defaults to \"rbac.authorization.k8s.io\" for User and Group subjects.",
                        "type": "string"
                    },
                    "kind": {
                        "description": "Kind of object being referenced. Values defined by this API group are \"User\", \"Group\", and \"ServiceAccount\". If the Authorizer does not recognized the kind value, the Authorizer should report an error.",
                        "type": "string"
                    },
                    "name": {
                        "description": "Name of the object being referenced.",
                        "type": "string"
                    }
                    },
                    "required": [
                    "kind",
                    "name"
                    ],
                    "type": "object"
                },
                "plugins": {
                    "items": {
                    "description": "Plugin is for customize actions on different platform.",
                    "properties": {
                        "apiVersion": {
                        "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources",
                        "type": "string"
                        },
                        "kind": {
                        "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds",
                        "type": "string"
                        },
                        "spec": {
                        "type": "object"
                        }
                    },
                    "type": "object"
                    },
                    "type": "array"
                },
                "resourceQuotaSpec": {
                    "description": "Resourcequota that will be applied to target namespace",
                    "properties": {
                    "hard": {
                        "additionalProperties": {
                        "type": "string"
                        },
                        "description": "hard is the set of desired hard limits for each named resource. More info: https://kubernetes.io/docs/concepts/policy/resource-quotas/",
                        "type": "object"
                    },
                    "scopeSelector": {
                        "description": "scopeSelector is also a collection of filters like scopes that must match each object tracked by a quota but expressed using ScopeSelectorOperator in combination with possible values. For a resource to match, both scopes AND scopeSelector (if specified in spec), must be matched.",
                        "properties": {
                        "matchExpressions": {
                            "description": "A list of scope selector requirements by scope of the resources.",
                            "items": {
                            "description": "A scoped-resource selector requirement is a selector that contains values, a scope name, and an operator that relates the scope name and values.",
                            "properties": {
                                "operator": {
                                "description": "Represents a scope's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist.",
                                "type": "string"
                                },
                                "scopeName": {
                                "description": "The name of the scope that the selector applies to.",
                                "type": "string"
                                },
                                "values": {
                                "description": "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.",
                                "items": {
                                    "type": "string"
                                },
                                "type": "array"
                                }
                            },
                            "required": [
                                "operator",
                                "scopeName"
                            ],
                            "type": "object"
                            },
                            "type": "array"
                        }
                        },
                        "type": "object"
                    },
                    "scopes": {
                        "description": "A collection of filters that must match each object tracked by a quota. If not specified, the quota matches all objects.",
                        "items": {
                        "description": "A ResourceQuotaScope defines a filter that must match each object tracked by a quota",
                        "type": "string"
                        },
                        "type": "array"
                    }
                    },
                    "type": "object"
                }
                },
                "type": "object"
            },
            "status": {
                "description": "ProfileStatus defines the observed state of Profile",
                "properties": {
                "conditions": {
                    "items": {
                    "properties": {
                        "message": {
                        "type": "string"
                        },
                        "status": {
                        "type": "string"
                        },
                        "type": {
                        "type": "string"
                        }
                    },
                    "type": "object"
                    },
                    "type": "array"
                }
                },
                "type": "object"
            }
            },
            "type": "object"
        }
        },
        "version": "v1",
        "versions": [
        {
            "name": "v1",
            "served": true,
            "storage": true
        },
        {
            "name": "v1beta1",
            "served": true,
            "storage": false
        }
        ]
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-controller-service-account",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-cluster-role-binding"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "cluster-admin"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "profiles-controller-service-account",
        "namespace": ai_devops_namespace
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": {
        "cluster-name": "",
        "clusterDomain": "cluster.local",
        "istio-namespace": istio_namespace,
        "userid-header": "kubeflow-userid",
        "userid-prefix": ""
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-kubeflow-config-mb6ktt4hf9",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": {
        "admin": "example@kubeflow.org",
        "gcp-sa": ""
    },
    "kind": "ConfigMap",
    "metadata": {
        "annotations": {},
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-profiles-config-52bcf9k8h9",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-kfam",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "ports": [
        {
            "port": 8081
        }
        ],
        "selector": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        }
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "profiles",
        "app.kubernetes.io/name": "profiles",
        "kustomize.component": "profiles"
        },
        "name": "profiles-deployment",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "profiles",
            "app.kubernetes.io/name": "profiles",
            "kustomize.component": "profiles"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app.kubernetes.io/component": "profiles",
            "app.kubernetes.io/name": "profiles",
            "kustomize.component": "profiles"
            }
        },
        "spec": {
            "containers": [
            {
                "args": [],
                "command": [
                "/manager",
                "-userid-header",
                "$(USERID_HEADER)",
                "-userid-prefix",
                "$(USERID_PREFIX)",
                "-workload-identity",
                "$(WORKLOAD_IDENTITY)"
                ],
                "env": [
                {
                    "name": "USERID_HEADER",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "userid-header",
                        "name": "profiles-kubeflow-config-mb6ktt4hf9"
                    }
                    }
                },
                {
                    "name": "USERID_PREFIX",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "userid-prefix",
                        "name": "profiles-kubeflow-config-mb6ktt4hf9"
                    }
                    }
                },
                {
                    "name": "WORKLOAD_IDENTITY",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "gcp-sa",
                        "name": "profiles-profiles-config-52bcf9k8h9"
                    }
                    }
                }
                ],
                "image": std.join("", [kubeflow_public_image_repo, "/profile-controller:vmaster-ga49f658f"]),
                "imagePullPolicy": "Always",
                "livenessProbe": {
                "httpGet": {
                    "path": "/metrics",
                    "port": 8080
                },
                "initialDelaySeconds": 30,
                "periodSeconds": 30
                },
                "name": "manager",
                "ports": [
                {
                    "containerPort": 8080,
                    "name": "manager-http",
                    "protocol": "TCP"
                }
                ]
            },
            {
                "args": [],
                "command": [
                "/access-management",
                "-cluster-admin",
                "$(CLUSTER_ADMIN)",
                "-userid-prefix",
                "$(USERID_PREFIX)",
                "-userid-header",
                "$(USERID_HEADER)"
                ],
                "env": [
                {
                    "name": "USERID_HEADER",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "userid-header",
                        "name": "profiles-kubeflow-config-mb6ktt4hf9"
                    }
                    }
                },
                {
                    "name": "USERID_PREFIX",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "userid-prefix",
                        "name": "profiles-kubeflow-config-mb6ktt4hf9"
                    }
                    }
                },
                {
                    "name": "CLUSTER_ADMIN",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "admin",
                        "name": "profiles-profiles-config-52bcf9k8h9"
                    }
                    }
                }
                ],
                "image": std.join("", [kubeflow_public_image_repo, "/kfam:vmaster-g9f3bfd00"]),
                "imagePullPolicy": "Always",
                "livenessProbe": {
                "httpGet": {
                    "path": "/metrics",
                    "port": 8081
                },
                "initialDelaySeconds": 30,
                "periodSeconds": 30
                },
                "name": "kfam",
                "ports": [
                {
                    "containerPort": 8081,
                    "name": "kfam-http",
                    "protocol": "TCP"
                }
                ]
            }
            ],
            "serviceAccountName": "profiles-controller-service-account"
        }
        }
    }
    }
]