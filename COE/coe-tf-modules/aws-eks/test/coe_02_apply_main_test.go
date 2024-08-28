package test

import (
	"regexp"
	"testing"

	awsSDK "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/stretchr/testify/assert"
)

func TestTerraformEKSApply(t *testing.T) {

	//terraform.InitAndPlan(t, terraformOptions)
	//PlanStruct = terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// // Clean up resources with "terraform destroy" at the end of the test.
	//terraform.Destroy(t, TerraformOptions)

	// // Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	//terraform.InitAndApply(t, TerraformOptions)
	/////terraform.ApplyE(t, TerraformOptions)

	// // Run `terraform output` to get the values of output variables and check they have the expected values.
	// output := terraform.Output(t, terraformOptions, "hello_world")
	// assert.Equal(t, "Hello, World!", output)
}

var azRebalanceIsDisable = false

func TestTerraformEKSNodeGroupsAfterApply(t *testing.T) {

	t.Run("CheckAZRebalanceDisable", func(t *testing.T) {

		asgClient := aws.NewAsgClient(t, AwsRegion)

		// Filter that will list all ASG for the current cluster
		input := autoscaling.DescribeAutoScalingGroupsInput{
			Filters: []*autoscaling.Filter{
				{
					Name:   awsSDK.String("tag-value"),
					Values: []*string{awsSDK.String(ClusterName)},
				},
			},
		}
		// Run aws command
		output, err := asgClient.DescribeAutoScalingGroups(&input)
		if err != nil {
			logger.Log(t, err)
		}

		// Handle result
		for _, group := range output.AutoScalingGroups {
			filterRegex, err := regexp.MatchString(`ng_general_small-*`, *group.AutoScalingGroupName)
			if err != nil {
				logger.Log(t, err)
			}
			if filterRegex {
				for _, process := range group.SuspendedProcesses {
					logger.Log(t, *process.ProcessName)
					if *process.ProcessName == "AZRebalance" {
						azRebalanceIsDisable = true
					}
				}
			}
		}

		//Check
		assert.Equal(t, false, azRebalanceIsDisable)
	})

}
