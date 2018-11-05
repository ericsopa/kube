#!/bin/bash

aws eks delete-cluster --name dev

cstatus="\"DELETING\""

while [ "$cstatus" == "\"DELETING\"" ]; do
	cstatus=$(aws eks describe-cluster --name dev --query cluster.status)
done

echo "Cluster is deleted!"
