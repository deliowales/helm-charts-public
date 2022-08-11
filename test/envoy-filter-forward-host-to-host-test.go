package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestenvoyfilterTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "horizon"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "horizon",
        			"nginx.service.internalPort": "8080",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "envoy-filter-forward-host-to-host", []string{"templates/horizon/envoy-filter-forward-host-to-host.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var envoyfilter corev1.EnvoyFilter
        helm.UnmarshalK8SYaml(t, output, &envoyfilter)

        // Finally, we verify the peer envoyfilter spec is set to the expected value
        expectedpatch := "envoy.lua"
        patch := envoyfilter.Spec.ConfigPatches.Patch.Value.Name
        if patch != expectedpatch {
            t.Fatalf("Rendered patch (%s) is not expected (%s)", patch, expectedpatch)
        }
}
