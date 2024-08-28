# Changelog

All notable changes to this project will be documented in this file.

### [v0.0.6](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.6&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.5) (2023-02-24)

### Features
* Added bucket_tf_state_end_name for compatibilities purpose
* Added key_pair_create to create or not the key pair for compatibilities purpose
* Added key_pair_name for compatibilities purpose
* Added aws_security_group_description for compatibilities purpose
* Added tags variable to TAG all resources

### [v0.0.5](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.3&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.5) (2023-01-11)

### Features
* Add tags used by Brazil cloud Data Governance (https://pages.experian.com/pages/viewpage.action?pageId=1001013241)

### [v0.0.4](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.3&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.4) (2022-10-19)

### Features
* Output - Name of the S3 log bucket
* Examples - set outputs to be used with terraform_remote_state module, [click here](docs/terraform-remote-state.md) to see more details

### [v0.0.3](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.1&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.3) (2022-10-13)

### Features
* Created Auto Scaling group to create the role AWSServiceRoleForAutoScaling in an automatic way due  we do not have permission to create role without BURoleFor in the name, we need this role to grant EEC KMS permissions
* Created BURoleForSNSLog for SNS logs

### [v0.0.2](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.1&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.2) (2022-10-07)

### Features
* Import SSH RSA PUBLIC to AWS Key pair
* Create defaults endpoints
* Update Documentation with defaults endpoints
* Grant KMS access to auto scaling ARN [Building instances using AutoScaling Groups - Experian  Golden AMIs](https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs)
* Remove old files from this module

### [v0.0.1](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-coe-base-v0.0.1&sourceBranch=refs%2Ftags%2Faws-coe-base-v0.0.1) (2022-10-05)

### Features
* Generate documentation file with the below informations:
    - Create BURoleForSRE for cross account access
    - Create Role for billing purpose with access over OKTA (The AD group will not be created)
    - Create Role for Developer purpose with access over OKTA (The AD group will not be created)
    - Create default buckets
    - Start with terraform module
    - Aditionals information can be add using the variable [documention](README.md#input\_documention)
    - To enabled this feature is needed set a value to [path_documentation_file](README.md#input\_path\_documentation\_file)


