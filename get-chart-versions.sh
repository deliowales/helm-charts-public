#!/bin/bash
for d in charts/*/ ; do
  echo "Getting chart version for " "$d"
  version=$(grep -oP '(?<=version:)[^ ]*' $d/Chart.yaml)
  echo "$version"
done
