package test

import (
	"github.com/gruntwork-io/terratest/modules/helm"
	appsv1 "k8s.io/api/apps/v1"
	"testing"
)

func TestNodeDeploymentTemplate(t *testing.T) {
	helmChartPath := "../charts/microservice"

	options := &helm.Options{
		SetValues: map[string]string{
			"application.name":                      "testapp",
			"application.env":                       "uat",
			"cloud.region":                          "eu-west-1",
			"application.resources.limits.memory":   "100mi",
			"application.resources.requests.memory": "100mi",
		},
	}

	output := helm.RenderTemplate(t, options, helmChartPath, "deployment-node", []string{"templates/deployment-node.yaml"})

	var deploymentnode appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deploymentnode)

	expectedReplicas := 3
	replicas := deploymentnode.Spec.Replicas
	if int(*replicas) != expectedReplicas {
		t.Fatalf("Rendered replica count (%s) is not expected (%s)", replicas, expectedReplicas)
	}
}
