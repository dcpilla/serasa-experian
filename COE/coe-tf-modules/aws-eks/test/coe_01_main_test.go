package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var PlanStruct *terraform.PlanStruct
var TerraformOptions *terraform.Options
var AwsRegion = "sa-east-1"
var TerraformTfVars = "variables-sandbox-test.tfvars"
var BucketName = "serasaexperian-mlcoe-sandbox-tf-state"
var PathCoeDefault = "../docs/examples/coe-default"
var ClusterName string

func TestTerraformEKSDeploy(t *testing.T) {

	//uniqueId := random.UniqueId()

	// // Create an S3 bucket where we can store state
	// BucketName := fmt.Sprintf("test-terraform-eks-deploy-%s", strings.ToLower(uniqueId))
	// defer cleanupS3Bucket(t, AwsRegion, BucketName)
	// aws.CreateS3Bucket(t, AwsRegion, BucketName)

	key := "eks/test/terrafor-11.tfstate"
	ClusterName = terraform.GetVariableAsStringFromVarFile(t, PathCoeDefault+"/"+TerraformTfVars, "eks_cluster_name") + "-sandbox"

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	TerraformOptions = terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: PathCoeDefault,
		PlanFilePath: "sandbox.plan",
		//Reconfigure:  true,
		//MigrateState: true,
		LockTimeout: "120m",
		MaxRetries:  3,
		Vars: map[string]interface{}{
			"eks_cluster_name": ClusterName,
		},
		VarFiles: []string{TerraformTfVars},
		BackendConfig: map[string]interface{}{
			"bucket": BucketName,
			"key":    key,
			"region": AwsRegion,
		},
	})

	//terraform.InitAndPlan(t, terraformOptions)
	PlanStruct = terraform.InitAndPlanAndShowWithStruct(t, TerraformOptions)

	// // Clean up resources with "terraform destroy" at the end of the test.
	// Desabilitando o destroy por teste. Faremos na pipeline.
	// Deixando comentário para futura referencia
	// defer terraform.Destroy(t, TerraformOptions)

	// // Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.Apply(t, TerraformOptions)

	// // Run `terraform output` to get the values of output variables and check they have the expected values.
	// output := terraform.Output(t, terraformOptions, "hello_world")
	// assert.Equal(t, "Hello, World!", output)
}

// func cleanupS3Bucket(t *testing.T, AwsRegion string, BucketName string) {
// 	aws.EmptyS3Bucket(t, AwsRegion, BucketName)
// 	aws.DeleteS3Bucket(t, AwsRegion, BucketName)
// }
