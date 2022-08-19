package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestserviceTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "service", []string{"templates/service.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var service corev1.Service
        helm.UnmarshalK8SYaml(t, output, &service)

        // Finally, we verify the peer service spec is set to the expected value
        expectedtype := "ClusterIP"
        servicetype := service.Spec.Type
        if servicetype != expectedtype {
            t.Fatalf("Rendered type (%s) is not expected (%s)", servicetype, expectedtype)
        }
}
