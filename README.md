# helm-charts-public

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

helm repo add delio https://deliowealth.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
delio` to see the charts.

To install a chart:

    helm install -f <values.yaml> delio/<chart-name> -n <namespace>

To uninstall the chart:

    helm uninstall <chart-name> -n <namespace>