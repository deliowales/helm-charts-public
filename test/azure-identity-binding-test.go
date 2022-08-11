package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestazureidentitybindingTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"azure.identity.name": "testname",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "azure-identity-binding", []string{"templates/azure-identity-binding.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the azure-identity-binding struct. This will
        // ensure the azure-identity-binding resource is rendered correctly.
        var azureidentitybinding corev1.azureidentitybinding
        helm.UnmarshalK8SYaml(t, output, &azureidentitybinding)

        // Finally, we verify the azure-identity-binding spec is set to the expected value
        expectedazureIdentity := "testclientname"
        azureIdentity := azureidentitybinding.Spec.AzureIdentity
        if azureIdentity != expectedazureIdentity {
            t.Fatalf("Rendered azureIdentity (%s) is not expected (%s)", azureIdentity, expectedazureIdentity)
        }
}
