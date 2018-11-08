#!/bin/bash

aws cloudformation delete-stack --stack-name dev-worker-nodes
outputs=1
while [ "$outputs" != "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name dev-worker-nodes | grep -c Outputs)
	sleep 10
done
