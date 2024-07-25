encrypt  = true
bucket   = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
region   = "@@AWS_REGION@@"
role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService" 
key      = "aws-eks-serasa/@@TFSTATE_NAME@@.tfstate"