#!/bin/bash

created=$(aws eks describe-cluster --name dev | jq -r .cluster.createdAt | cut -f1 -d".")
echo "created: $created"

echo "Waiting for cluster to be created..."
while [ "$cstatus" != "\"ACTIVE\"" ];do
        cstatus=$(aws eks describe-cluster --name dev --query cluster.status)
done

now=$(date +%s)
echo "now: $now"

echo "Cluster is up!"

# Do the math
min=$((($now-$created)/60))
echo Took $min minutes

