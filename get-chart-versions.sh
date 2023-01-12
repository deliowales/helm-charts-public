#!/bin/bash
echo "# Charts" > README.md
for d in charts/*/ ; do
  echo "Getting chart version for" "$d"
  version=$(grep -oP '(?<=version\:\s)[^ ]*' $d/Chart.yaml | tr -d \'\" )
  echo "$version"
  echo $d
  chart=${d#*/}
  echo "## [$(echo $chart | tr -d "/")]($d) ![Version: $version](https://img.shields.io/badge/Version-$version-informational?style=flat-square)" >> README.md
done
