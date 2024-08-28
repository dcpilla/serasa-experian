**Launch AWS EC2**
----

## What Is The Launch AWS EC2?

This launch initiates an automatic provisioning process for a resource EC2 on AWS.

`WARNING`: The AWS Account MUST have a S3 Bucket called `cockpit-devsecops-states-<<AWS_ACCOUNT_ID>>` to store the TFSTATE file for this automation deployment.

### How to Use

It all starts with filling in the required parameters in Jenkins. Then run the Jenkins Job.

#### Parameters for Using

| TAGS              | Expected Input  
|-------------------| ---------------------------------------------------  
| country           | The Country where it will be deployed
| bu                | The Business Unit
| Environment       | Environment: prd, stg, uat, tst, dev ou sbx
| AppID             | GEARR "App ID"
| CostString        | This key/value can is used for tag-based cost
| tags_schedule     | Tag used for time the instance will be running

| Parameters               | Description              | Mandatory | Example
| ------------------------ | ------------------------ | --------- | -------
| aws_account_id   | AWS Account ID  | yes | 123456789
| so               | Choose SO to launch | yes | Redhat
| ssh_username     | User used in SSH connection | yes | user_test
| ssh_username_key | SSH public key to user connection | yes
| stack_name       | Define a stack name to use in instance name | yes | devsecops
| prefix_hostname  | Define a hostname to use in instance name | yes | spobr
| app_name         | Define a application name | yes | grafana
| instance_type    | Instance Type | yes | t3.medium
| instance_count   | Number of instances to launch | yes | 1
| instance_volume_app_size | FileSystem Size | yes | 50

#### Regex

| Parameters             | Expected input                                                       | Regex
| ---------------------- | -------------------------------------------------------------------- | -----------------------------------------
| aws_account_id         | AWS Account ID number                                                | ^(\d{1,12}\|\d{1,12})$
| ssh_username           | SSH user without blank spaces                                        | ^\S*$
| ssh_username_key       | Public SSH RSA Key                                                   | ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ([^@]+@[^@]+)
| prefix_hostname        | Only numbers, characters (lower case) limited in 10 digits           | ^[0-9a-z_-]{1,10}$
| stack_name             | Only numbers, characters (lower case) limited in 10 digits           | ^[0-9a-z_-]{1,10}$
| app_name               | Only numbers, characters (lower case) limited in 10 digits           | ^[0-9a-z_-]{1,10}$

## Author

* **DevSecOps PaaS Brazil** - <devsecops-paas-brazil@br.experian.com>
