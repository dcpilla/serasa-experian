# How to configure my application

1. Copy the file `hcharts-stateless/values.yaml` into the root folder of your application
   1. You need to edit the following configuration:
      1. deployment.repository
      2. deployment.host
      3. deployment.production.replicaCount
      4. containerPort
   2. You may update any other configuration on the file

2. Create a folder called `env-files`:
   1. For each enviroment, create a file `env.<(stg,qa,uat,prod)>
   2. Inside each file addd the environment variable in the format: ```key: value```
