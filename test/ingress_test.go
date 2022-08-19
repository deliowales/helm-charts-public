package test

import (
	"testing"

	networkingv1 "k8s.io/api/networking/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

func TestIngressTemplate(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../charts/microservice"
	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"application.name":   "testapp",
			"ingress.enabled":    "true",
			"ingress.path":       "/testapp",
			"ingress.pathrouted": "/kong/testapp",
		},
	}
	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, "ingress", []string{"templates/ingress.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
	// ensure the deployment resource is rendered correctly.
	var ingress networkingv1.Ingress
	helm.UnmarshalK8SYaml(t, output, &ingress)

	// Finally, we verify the ingress spec is set to the expected value
	expectedPath := "/testapp"
	Path := ingress.Spec.Rules.Http.Paths.Path
	if Path != expectedPath {
		t.Fatalf("Rendered path (%s) is not expected (%s)", Path, expectedPath)
	}
}
