package test

import (
        "testing"

        Istio "istio.io/client-go/pkg/apis/security/v1beta1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestauthorizationpolicyTemplate(t *testing.T) {
        // Path to the helm chart we will test
        helmChartPath := "../charts/microservice"
        application := "testapp"
        // Setup the args. For this test, we will set the following input values:
        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        	},
        }

        // Run RenderTemplate to render the template and capture the output.
        output := helm.RenderTemplate(t, options, helmChartPath, "authorization-policy", []string{"templates/authorization-policy.yaml"})

        // Now we use kubernetes/client-go library to render the template output into the authorization-policy struct. This will
        // ensure the authorization-policy resource is rendered correctly.
        var authorizationpolicy Istio.AuthorizationPolicy
        helm.UnmarshalK8SYaml(t, output, &authorizationpolicy)

        // Finally, we verify the authorization-policy spec is set to the expected value
        expectedAction := "Allow"
        Action := authorizationpolicy.Spec.Action
        if Action != expectedAction {
            t.Fatalf("Rendered action (%s) is not expected (%s)", Action, expectedAction)
        }
}
