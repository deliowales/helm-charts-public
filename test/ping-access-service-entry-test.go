package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestserviceentryTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "horizon"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "horizon",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "ping-access-service-entry", []string{"templates/horizon/ping-access-service-entry.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var serviceentry corev1.ServiceEntry
        helm.UnmarshalK8SYaml(t, output, &serviceentry)

        // Finally, we verify the peer serviceentry spec is set to the expected value
        expectedresolution := "STATIC"
        resolution := serviceentry.Spec.Resolution
        if resolution != expectedresolution {
            t.Fatalf("Rendered resolution (%s) is not expected (%s)", resolution, expectedresolution)
        }
}
