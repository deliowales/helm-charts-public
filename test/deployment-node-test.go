package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestPodTemplateRendersContainerImage(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        // - image=nginx:1.15.8
        options := &helm.Options{
            ValuesFiles:     []string{"values.yaml"},
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"application.env": "uat",
        			"cloud.region": "eu-west-1",

        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "deployment-node", []string{"templates/deployment-node.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the Pod struct. This will
        // ensure the Pod resource is rendered correctly.
        var deploymentnode corev1.Deployment
        helm.UnmarshalK8SYaml(t, output, &deploymentnode)

        // Finally, we verify the pod spec is set to the expected container image value
        expectedReplicas := "3"
        Replicas := deploymentnode.Spec.Replicas
        if Replicas != expectedContainerImage {
            t.Fatalf("Rendered replica count (%s) is not expected (%s)", Replicas, expectedReplicas)
        }
}
