#!/bin/bash
echo "# Charts" > README.md
echo "Updating Chart version badges in README..."
for d in charts/*/ ; do
  version=$(ggrep -oP '(?<=version\:\s)[^ ]*' $d/Chart.yaml | tr -d \'\" )
  chart=$( echo ${d#*/} | tr -d "/")
  echo "## [${chart^}]($d): ![Version: $version](https://img.shields.io/badge/Version-$version-informational?style=flat-square)" >> README.md
done
