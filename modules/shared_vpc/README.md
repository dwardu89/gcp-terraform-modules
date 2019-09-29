# Shared VPC Module

This module creates the basic things required to have a shared VPC solution. The terraform allows you to specify the host project and as many service projects.

### Example
The example can be found in `examples/shared_vpc`. The variables need to be populated with your own valies.

## Requirements
In order to run this, you will need to have an Organization which will require you to sign up to [G Suite](https://gsuite.google.com).


| Variable   |      type      | default|  description |
|----------|:-------------:|:------:|------|
| host_project_name |  string| "" |The name of the host project |
| host_project_id |  string| "" |The id of the host project |
| billing_account |  string| "" | The billing account used for the project |
| host_project_skip_delete |    bool   |  true |  Skip deletion of the host project if the resource is removed from terraform |
| service_project_ids | list |   [] |  A list of service project ids |
| service_project_names | list |   [] |  A list of service project names |
| google_apis | list |  ["compute.googleapis.com"] |  A list of Google APIs to enable in the project |
| vpc_name | string |  "" |  The name of the VPC to create |
| labels | map |  {} |  Labels to apply to the resources |
