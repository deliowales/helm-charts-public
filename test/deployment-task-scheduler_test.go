package test

import (
	"testing"

	appsv1 "k8s.io/api/apps/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

func TestDeploymentTemplate(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../charts/microservice"
	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"application.name":                      "data-feed",
			"cloud.region":                          "eu-west-1",
			"application.language":                  "php",
			"cloud.provider":                        "aws",
			"cloud.containerRegistryURL":            "url",
			"cloud.environment":                     "uat",
			"application.resources.limits.memory":   "100Mi",
			"application.resources.requests.memory": "100Mi",
			"nginx.livenessProbe.path":              "/testpath",
			"nginx.readinessProbe.path":             "/testpath",
		},
	}

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, "deployment-task-scheduler", []string{"templates/data-feed/deployment-task-scheduler.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
	// ensure the deployment resource is rendered correctly.
	var taskscheduler appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &taskscheduler)

	// Finally, we verify the deployment spec is set to the expected value
	expectedReplicas := 1
	Replicas := taskscheduler.Spec.Replicas
	if int(*Replicas) != expectedReplicas {
		t.Fatalf("Rendered replica count (%v) is not expected (%v)", Replicas, expectedReplicas)
	}
}
