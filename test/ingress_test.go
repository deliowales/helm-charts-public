package test

import (
	"testing"

	"fmt"

	networkingv1 "k8s.io/api/networking/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

func TestIngressTemplate(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../charts/microservice"
	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"application.name":           "testapp",
			"ingress.enabled":            "true",
			"ingress.path":               "/testapp",
			"ingress.pathrouted":         "/kong/testapp",
			"service.enabled":            "true",
			"application.language":       "php",
			"cloud.provider":             "aws",
			"cloud.containerRegistryURL": "url",
			"cloud.environment":          "uat",
			"nginx.livenessProbe.path":   "/testpath",
			"nginx.readinessProbe.path":  "/testpath",
		},
	}
	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, "ingressv1", []string{"templates/ingressv1.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the deployment struct. This will
	// ensure the deployment resource is rendered correctly.
	var ingress networkingv1.Ingress
	helm.UnmarshalK8SYaml(t, output, &ingress)

	// Finally, we verify the ingress spec is set to the expected value
	//expectedPort := 80
	port := ingress.Spec.Rules
	//Port := ingress.Spec.Rules.http.Paths.Backend.Service.Port.Number
	//if Port != expectedPort {
	//	t.Fatalf("Rendered port (%v) is not expected (%v)", Port, expectedPort)
	//}
	fmt.Println(port)
}


[{ {&HTTPIngressRuleValue{Paths:[]HTTPIngressPath{HTTPIngressPath{Path:/testapp,Backend:IngressBackend{Resource:nil,Service:&IngressServiceBackend{Name:testapp,Port:ServiceBackendPort{Name:,Number:80,},},},PathType:*ImplementationSpecific,},},}}}]
