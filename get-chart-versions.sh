#!/bin/bash
for d in charts/*/ ; do
  echo "Getting chart version for " $d
  grep -oP '(?<=version:\s/)\w+' $d/Chart.yaml
done
