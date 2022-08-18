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
        		"application.name":                      "data-feed",
                "cloud.region":                          "eu-west-1",
                "cloud.provider":                        "aws",
                "cloud.containerRegistryURL":            "url",
                "cloud.environment":                     "uat",
                "application.resources.limits.memory":   "100mi",
                "application.resources.requests.memory": "100mi",
        	},
        }

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "deployment-queue", []string{"templates/data-feed/deployment-queue.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var queue appsv1.Deployment
        helm.UnmarshalK8SYaml(t, output, &queue)

        // Finally, we verify the deployment spec is set to the expected value
        expectedReplicas := 1
        Replicas := queue.Spec.Replicas
        if int(*Replicas)!= expectedReplicas {
            t.Fatalf("Rendered replica count (%v) is not expected (%v)", Replicas, expectedReplicas)
        }
}
