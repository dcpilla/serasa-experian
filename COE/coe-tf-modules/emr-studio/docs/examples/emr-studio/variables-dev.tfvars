env                                = "dev"
gearr_id                           = "12003"
project_name                       = "datascience"
team                               = "Data_Intelligence"
buckets_name_allow_emr_studio_role = [
    "serasaexperian-da-datascience-data-mesh-views-dev"
]
buckets_name_deny_emr_studio_role  = [
    "cf-templates-mwe96llfjata-sa-east-1", 
    "serasaexperian-da-datascience-dev-logs",
    "serasaexperian-da-datascience-dev-tf", 
    "serasaexperian-datascience-data-emr-workspace-dev",
    "serasaexperian-datascience-cloudformation-template-dev"
]
buckets_name_allow_emr_role        = [
    
]
allowed_instance_types             = ["m5.xlarge", "m5.2xlarge", "m5.4xlarge", "m5.8xlarge", "r5.xlarge"]
bootstrap_script_path              = "bootstrap-scripts/bootstrap-script.sh"
emr-subnet                         = "emr"
additional_user_policy             = false
