package test

import (
        "testing"

        appsv1 "k8s.io/api/apps/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestdeploymentTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "horizon"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "horizon",
        			"application.env": "uat",
        			"cloud.region": "eu-west-1",
        			"application.resources.limits.memory": "100mi"
        			"application.resources.requests.memory": "100mi"

        	},

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "deployment-cron", []string{"templates/horizon/deployment-cron.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
        // ensure the deployment resource is rendered correctly.
        var deploymentcron appsv1.Deployment
        helm.UnmarshalK8SYaml(t, output, &deploymentcron)

        // Finally, we verify the deployment spec is set to the expected value
        expectedReplicas := "3"
        Replicas := deploymentcron.Spec.Replicas
        if Replicas != expectedContainerImage {
            t.Fatalf("Rendered replica count (%s) is not expected (%s)", Replicas, expectedReplicas)
        }
}
