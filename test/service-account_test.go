package test

import (
	"testing"

	corev1 "k8s.io/api/core/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

func TestServiceAccountTemplate(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../charts/microserviceaccount"
	application := "testapp"
	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"application.name": "testapp",
			"aws.iamRole":      "testrole",
		},
	}

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, "service-account", []string{"templates/service-account.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
	// ensure the deployment resource is rendered correctly.
	var serviceaccount corev1.ServiceAccount
	helm.UnmarshalK8SYaml(t, output, &serviceaccount)

	// Finally, we verify the peer serviceaccount spec is set to the expected value
	expectedrole := "testrole"
	role := serviceaccount.Metadata.Annotations.Eks.amazonaws.com/role - arn
	if role != expectedrole {
		t.Fatalf("Rendered role (%s) is not expected (%s)", role, expectedrole)
	}
}
