package test

import (
	"github.com/gruntwork-io/terratest/modules/helm"
	appsv1 "k8s.io/api/apps/v1"
	"testing"
)

func TestCronDeploymentTemplate(t *testing.T) {
	helmChartPath := "../charts/microservice"

	options := &helm.Options{
		SetValues: map[string]string{
			"application.name":                      "horizon",
			"cloud.region":                          "eu-west-1",
			"cloud.provider":                        "aws",
			"cloud.containerRegistryURL":            "url",
			"application.language":                  "node",
			"cloud.environment":                     "uat",
			"application.resources.limits.memory":   "100Mi",
			"application.resources.requests.memory": "100Mi",
			"application.cron.enabled":              "true",
			"serviceEntry.ping.hosts":               "",
		},
	}
	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, "deployment-cron", []string{"templates/horizon/cron/deployment-cron.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
	// ensure the deployment resource is rendered correctly.
	var deploymentcron appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deploymentcron)

	// Finally, we verify the deployment spec is set to the expected value
	expectedReplicas := 3
	Replicas := deploymentcron.Spec.Replicas
	if int(*Replicas) != expectedReplicas {
		t.Fatalf("Rendered replica count (%v) is not expected (%v)", int(*Replicas), expectedReplicas)
	}
}
