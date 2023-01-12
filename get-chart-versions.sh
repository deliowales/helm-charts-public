#!/bin/bash
for d in charts/*/ ; do
  echo "Getting chart version for " "$d"
  cd $d
  version=$(grep -oP '(?<=version:)[^ ]*' Chart.yaml)
  echo "$version"
done
