# GCP K8s Conformance Environment

This Terraform project can be used to create a test environment on GCP to run the [K8s conformance tests](https://www.cncf.io/certification/software-conformance/#how) for the [Mia-Platform distribution](https://github.com/mia-platform/distribution).

## Pre-commit hooks install

Requisites:

- Python
- [pre-commit](https://pypi.org/project/pre-commit/) package

```shell
# Install pre-commit package in user environment
pip install pre-commit
# Install hooks in .git/hooks/pre-commit
pre-commit install --install-hooks
# (optional) Run manually pre-commit hooks
pre-commit run -a
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.52.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_all_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_k8s](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.master](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance.worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.vpc_subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [random_string.join_token_first_part](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.join_token_second_part](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [template_file.master_startup](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.worker_startup](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_GCP_CREDENTIALS_JSON"></a> [GCP\_CREDENTIALS\_JSON](#input\_GCP\_CREDENTIALS\_JSON) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `string` | n/a | yes |
| <a name="input_pod_network_cidr"></a> [pod\_network\_cidr](#input\_pod\_network\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->