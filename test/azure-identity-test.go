package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestazureidentityTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"azure.identity.enabled": "true",
        			"azure.identity.clientname": "testclientname",
        			"azure.identity.name": "testname",
        			"azure.identity.idName": "testidname",
        			"azure.identity.resourcename": "testresourcename",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "azure-identity", []string{"templates/azure-identity.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the azure-identity struct. This will
        // ensure the azure-identity resource is rendered correctly.
        var azureidentity corev1.azureidentity
        helm.UnmarshalK8SYaml(t, output, &azureidentity)

        // Finally, we verify the azure-identity spec is set to the expected value
        expectedClientID := "testclientname"
        ClientID := azureidentity.Spec.ClientID
        if ClientID != expectedClientID {
            t.Fatalf("Rendered ClientID (%s) is not expected (%s)", ClientID, expectedClientID)
        }
}
