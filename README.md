# GCP K8s Conformance Environment

This Terraform project can be used to create a test environment on GCP to run the [K8s conformance tests]
for the [Mia-Platform distribution].

## Usage

The projects requires a minimal set of configuration as input of the terraform module that you can see [here](#inputs),
you can choose to set them via flags or via a `terraform.auto.tfvars` file.

When you have the values that you want to set, run the following commands:

```shell
terraform init
terraform plan -out=plan.tfplan <optional -var flags>
```

The plan should create these [resources](#resources), and showing as output the public IP address of the
control-plane.

Finally, run:

```shell
terraform apply plan.tfplan
```

The initialization of the nodes may take a few minutes. You can check the cluster status by checking when the
control plane port is open on the public IP adress that terraform will show you with `netcat`:

```shell
nc -v <public-ip> 6443
```

Or via `telnet`:

```shell
telnet <public-ip> 6443
```

You may now connect to the control plane via ssh, we suggest the usage of the `gcloud` command that Google will
give you via the UI.  
Once inside the control-plane become the `root` user and you will find a configured context for connecting
to the cluster, you may now setup your preferred connection method for interacting with the cluster via the public
endpoint.

## Development

## Pre-commit Hooks Install

Requisites:

- [pre-commit](https://pre-commit.com/#install)
- [terraform-docs](https://terraform-docs.io/user-guide/installation/)

```shell
# Install hooks in .git/hooks/pre-commit
pre-commit install --install-hooks
# (optional) Run manually pre-commit hooks to check if all its working
pre-commit run -a
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_iap_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_node_ports](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_nodes_communication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_public_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.control_plane](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance.worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [random_string.join_token_first_part](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.join_token_second_part](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_GCP_CREDENTIALS_JSON"></a> [GCP\_CREDENTIALS\_JSON](#input\_GCP\_CREDENTIALS\_JSON) | The absolute path of the JSON file containing the GCP credentials to access your project. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of Kubernetes that will run on the cluster. | `string` | `"1.27"` | no |
| <a name="input_nodes_network_cidr"></a> [nodes\_network\_cidr](#input\_nodes\_network\_cidr) | The IP CIDR of the Kubernetes clusrter nodes. Default to 172.16.0.0/24 | `string` | `"172.16.0.0/24"` | no |
| <a name="input_pod_network_cidr"></a> [pod\_network\_cidr](#input\_pod\_network\_cidr) | The IP CIDR of the pods in the Kubernetes cluster. Default to 10.10.0.0/16 | `string` | `"10.10.0.0/16"` | no |
| <a name="input_project"></a> [project](#input\_project) | The Google project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the cluster will be created. | `string` | `"europe-west1"` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | The number of worker nodes of the cluster. Default to 3 | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_public_ip"></a> [control\_plane\_public\_ip](#output\_control\_plane\_public\_ip) | The public IP for connecting to the cluster control plane |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

[K8s conformance tests]: https://www.cncf.io/certification/software-conformance/#how
[Mia-Platform distribution]: https://github.com/mia-platform/distribution
