encrypt  = true
bucket   = "cockpit-devsecops-states-{{account_id}}"
region   = "{{account_region}}"
role_arn = "arn:aws:iam::{{account_id}}:role/BUAdministratorAccessRole" 
key      = "aws-eks-serasa/{{tf_state_name}}.tfstate"
