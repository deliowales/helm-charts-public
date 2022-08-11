package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestpeerauthenticationTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "peer-authentication", []string{"templates/peer-authentication.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var peerauthentication corev1.PodDisruptionBudget
        helm.UnmarshalK8SYaml(t, output, &peerauthentication)

        // Finally, we verify the peer authentication spec is set to the expected value
        expectedmtlsMode := "STRICT"
        mtlsMode := peerauthentication.Spec.mtlsMode.
        if mtlsMode != expectedmtlsMode {
            t.Fatalf("Rendered mtlsMode (%s) is not expected (%s)", mtlsMode, expectedmtlsMode)
        }
}
