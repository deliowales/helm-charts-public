package test

import (
        "testing"

        appsv1 "k8s.io/api/apps/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestdeploymentTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        		"application.name":                      "testapp",
                "application.language":                  "php",
                "cloud.region":                          "eu-west-1",
                "cloud.provider":                        "aws",
                "cloud.containerRegistryURL":            "url",
                "cloud.environment":                     "uat",
                "application.resources.limits.memory":   "100mi",
                "application.resources.requests.memory": "100mi",
        	},
        }

	output := helm.RenderTemplate(t, options, helmChartPath, "deployment-php", []string{"templates/deployment-php.yaml"})

	var deploymentphp appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deploymentphp)

	expectedReplicas := 3
	replicas := deploymentphp.Spec.Replicas
	if int(*replicas) != expectedReplicas {
		t.Fatalf("Rendered replica count (%v) is not expected (%v)", replicas, expectedReplicas)
	}
}
