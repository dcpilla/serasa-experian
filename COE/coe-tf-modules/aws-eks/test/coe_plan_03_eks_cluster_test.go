package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformEKSCluster(t *testing.T) {
	t.Parallel()

	t.Run("CheckNameCluster", func(t *testing.T) {

		terraform.RequirePlannedValuesMapKeyExists(t, PlanStruct, "module.experian_eks.module.eks.aws_eks_cluster.this[0]")
		eksResource := PlanStruct.ResourcePlannedValuesMap["module.experian_eks.module.eks.aws_eks_cluster.this[0]"]

		//Check
		assert.Equal(t, ClusterName, eksResource.AttributeValues["name"])

	})

}
