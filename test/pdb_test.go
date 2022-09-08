package test

import (
        "testing"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestpdbTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
                SetValues: map[string]string{
                        "application.name": "testapp",
                        "pdb.enabled":      "true",
                },
        }
        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "pdb", []string{"templates/pdb.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var pdb networkingv1.PodDisruptionBudget
        helm.UnmarshalK8SYaml(t, output, &pdb)

        // Finally, we verify the pdb spec is set to the expected value
        expectedminAvailable := "2"
        minAvailable := pdb.Spec.MinAvailablev
        if int(*minAvailable) != expectedminAvailable {
                t.Fatalf("Rendered minAvailable (%v) is not expected (%v)", minAvailable, expectedminAvailable)
        }
}
