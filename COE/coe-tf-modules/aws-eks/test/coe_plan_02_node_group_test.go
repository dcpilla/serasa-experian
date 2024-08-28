package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformEKSNodeGroups(t *testing.T) {
	t.Parallel()
	t.Run("CheckDiskSize", func(t *testing.T) {
		terraform.RequirePlannedValuesMapKeyExists(t, PlanStruct, "module.experian_eks.module.eks.module.eks_managed_node_group[\"ng_general_small\"].aws_launch_template.this[0]")
		ec2Resource := PlanStruct.ResourcePlannedValuesMap["module.experian_eks.module.eks.module.eks_managed_node_group[\"ng_general_small\"].aws_launch_template.this[0]"]

		blockAttributes := ec2Resource.AttributeValues["block_device_mappings"].([]interface{})[0].(map[string]interface{})["ebs"].([]interface{})[0].(map[string]interface{})

		//Check
		assert.Equal(t, float64(120), blockAttributes["volume_size"])

	})
}
