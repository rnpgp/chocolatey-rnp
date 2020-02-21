#!/usr/bin/env bash

for entry in output/*.nupkg
do
    echo "Pushing $entry"
    choco push $entry  --source https://push.chocolatey.org/
done
