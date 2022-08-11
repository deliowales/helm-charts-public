package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestKongIngressTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"kongIngress.enabled": "true"
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "kong-ingress", []string{"templates/kong-ingress.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var kongingress corev1.KongIngress
        helm.UnmarshalK8SYaml(t, output, &kongingress)

        // Finally, we verify the ingress spec is set to the expected value
        expectedRoute := "false"
        Route := ingress.Route.PreserveHost
        if Route != expectedRoute {
            t.Fatalf("Rendered Route (%s) is not expected (%s)", Route, expectedRoute)
        }
}
