package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestdestinationruleTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "virus-scanner"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "virus-scanner",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "destination-rule", []string{"templates/virus-scanner/destination-rule-s3.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the destinationrule struct. This will
        // ensure the destinationrule resource is rendered correctly.
        var destinationrule corev1.DestinationRule
        helm.UnmarshalK8SYaml(t, output, &destinationrule)

        // Finally, we verify the destinationrule spec is set to the expected value
        expectedTlsMode := "DISABLE"
        TlsMode := destinationrule.Spec.TrafficPolicy.Tls.Mode
        if TlsMode != expectedTlsMode {
            t.Fatalf("Rendered tls mode count (%s) is not expected (%s)", TlsMode, expectedTlsMode)
        }
}
