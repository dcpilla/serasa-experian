package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformComponentVersions(t *testing.T) {
	t.Parallel()

	expectedArgoCDVersion := terraform.GetVariableAsStringFromVarFile(t, PathCoeDefault+"/"+TerraformTfVars, "coe_argocd_helm_version")

	t.Run("CheckArgoCDVersion", func(t *testing.T) {
		terraform.RequirePlannedValuesMapKeyExists(t, PlanStruct, "module.experian_eks.module.coe-argocd.helm_release.coe-argocd")
		eksResource := PlanStruct.ResourcePlannedValuesMap["module.experian_eks.module.coe-argocd.helm_release.coe-argocd"]

		//Check
		assert.Equal(t, expectedArgoCDVersion, eksResource.AttributeValues["version"])

	})

	t.Run("CheckMetricServerVersion", func(t *testing.T) {
		terraform.RequirePlannedValuesMapKeyExists(t, PlanStruct, "module.experian_eks.helm_release.metrics-server")
		eksResource := PlanStruct.ResourcePlannedValuesMap["module.experian_eks.helm_release.metrics-server"]

		//Check
		assert.Equal(t, "3.12.0", eksResource.AttributeValues["version"])

	})

}
