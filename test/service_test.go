package test

import (
        "testing"

        corev1 "k8s.io/api/core/v1"

        "github.com/gruntwork-io/terratest/modules/helm"
)

func TestserviceTemplate(t *testing.T) {

        helmChartPath := "../charts/microservice"

        options := &helm.Options{
            SetValues: map[string]string{
        			"application.name": "testapp",
        			"service.enabled": "true",
        	},
        }


        output := helm.RenderTemplate(t, options, helmChartPath, "service", []string{"templates/service.yaml"})

        var service corev1.Service
        helm.UnmarshalK8SYaml(t, output, &service)

        expectedtype := "ClusterIP"
        servicetype := service.Spec.Type
        if servicetype != expectedtype {
            t.Fatalf("Rendered type (%s) is not expected (%s)", servicetype, expectedtype)
        }
}
