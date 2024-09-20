terraform {
 backend "s3" {
   encrypt = true
   bucket = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
   region = "sa-east-1"
   role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
   key = "piaas-iac-controller/piaas-controller.tfstate"
 }
}