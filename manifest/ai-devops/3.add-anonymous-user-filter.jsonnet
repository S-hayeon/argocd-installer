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
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "EnvoyFilter",
    "metadata": {
        "name": "add-user-filter",
        "namespace": istio_namespace
    },
    "spec": {
        "workloadLabels": {
        "app": "istio-ingressgateway"
        },
        "filters": [
        {
            "listenerMatch": {
            "listenerType": "GATEWAY"
            },
            "filterName": "envoy.lua",
            "filterType": "HTTP",
            "insertPosition": {
            "index": "FIRST"
            },
            "filterConfig": {
            "inlineCode": "function envoy_on_request(request_handle)\n    request_handle:headers():add(\"kubeflow-userid\",\"anonymous@kubeflow.org\")\nend\n"
            }
        }
        ]
    }
    }
]