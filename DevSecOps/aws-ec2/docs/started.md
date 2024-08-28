### Project Configuration

#### How to Use

It all starts with filling in the required parameters in Jenkins. Then run the Jenkins Job.

#### Parameters for Using

| Parameters               | Description                                 | Mandatory | Example        |
| ------------------------ | --------------------------------------------| --------- | ---------------|
| aws_account_id           | AWS Account ID                              | yes       | 123456789      |
| so                       | Choose SO to launch                         | yes       | Redhat         |
| country                  | Choose your country                         | yes       | BR             |
| bu                       | Choose your Bussiness Unit                  | yes       | EITS_Enterprise|
| ssh_username             | User used in SSH connection                 | yes       | user_test      |
| ssh_username_key         | SSH public key to user connection           | yes       |                |
| stack_name               | Define a stack name to use in instance name | yes       | devsecops      |
| prefix_hostname          | Define a hostname to use in instance name   | yes       | spobr          |
| app_name                 | Define a application name                   | yes       | grafana        |
| instance_type            | Instance Type                               | yes       | t3.medium      |
| instance_count           | Number of instances to launch               | yes       | 1              |
| instance_volume_app_size | FileSystem Size                             | yes       | 50             |

#### Regex

| Parameter              | Expected input                                                       | Regex                                                   |
| ---------------------- | -------------------------------------------------------------------- | --------------------------------------------------------|
| aws_account_id         | Inserting numbers up to 12 digits                                    | ^(\d{1,12}\|\d{1,12})$                                  |
| ssh_username           | No blank spaces allowed                                              | ^\S*$                                                   |
| ssh_username_key       | Public SSH RSA key                                                   | ``` ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ([^@]+@[^@]+) ```|
| prefix_hostname        | Numbers, letters (lowercase only), limited to 10 characters          | ``` ^[0-9a-z_-]{1,10}$ ```                              |
| stack_name             | Numbers, letters (lowercase only), limited to 10 characters          | ``` ^[0-9a-z_-]{1,10}$ ```                              |
| app_name               | Numbers, letters (lowercase only), limited to 10 characters          | ``` ^[0-9a-z_-]{1,10}$ ```                              |

#### Author

* **Chapter DevSecOps** - devsecops-chapter-br@br.experian.com