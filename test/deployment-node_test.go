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
			"application.language":                  "node",
			"cloud.region":                          "eu-west-1",
			"cloud.provider":                        "aws",
			"cloud.containerRegistryURL":            "url",
			"cloud.environment":                     "uat",
			"application.resources.limits.memory":   "100Mi",
			"application.resources.requests.memory": "100Mi",
		},
	}

	output := helm.RenderTemplate(t, options, helmChartPath, "deployment-node", []string{"templates/deployment-node.yaml"})

	var deploymentnode appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deploymentnode)

	expectedReplicas := 3
	replicas := deploymentnode.Spec.Replicas
	if int(*replicas) != expectedReplicas {
		t.Fatalf("Rendered replica count (%v) is not expected (%v)", replicas, expectedReplicas)
	}
}
