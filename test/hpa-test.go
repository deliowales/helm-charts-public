package test

import (
        "testing"

        autoscalingv1 "k8s.io/api/autoscaling/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestdeploymentTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"application.resources.limits.memory": "100mi"
        			"application.resources.requests.memory": "100mi"
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "hpa", []string{"templates/hpa.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var hpa autoscaling.HorizontalPodAutoscaler
        helm.UnmarshalK8SYaml(t, output, &hpa)

        // Finally, we verify the hpa spec is set to the expected value
        expectedMinReplicas := "3"
        MinReplicas := hpa.Spec.MinReplicas
        if MinReplicas != expectedMinReplicas {
            t.Fatalf("Rendered replica count (%s) is not expected (%s)", MinReplicas, expectedMinReplicas)
        }
}
