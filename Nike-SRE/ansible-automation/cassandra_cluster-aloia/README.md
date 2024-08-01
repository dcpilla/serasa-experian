$ cd cassandra
$ terraform.exe -chdir=. init -backend-config=../backend_conf/uat.conf -reconfigure -lock=false
$ terraform.exe -chdir=. plan -var-file=../variables-uat.tfvar -lock=false

$ cd ansible
$ ansible-playbook -i inventory-prod playbook-prod.yaml --private-key ~/cassandra-prd.pem -u ec2-user
