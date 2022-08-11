package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestvirtualserviceTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "horizon"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "horizon",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "virtual-service", []string{"templates/horizon/virtual-service.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var virtualservice corev1.VirtualService
        helm.UnmarshalK8SYaml(t, output, &virtualservice)

        // Finally, we verify the peer virtualservice spec is set to the expected value
        expectedhost := "horizon"
        host := virtualservice.Spec.Http.Route.Destination.Host
        if host != expectedhost {
            t.Fatalf("Rendered host (%s) is not expected (%s)", host, expectedhost)
        }
}
