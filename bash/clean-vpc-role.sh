#!/bin/bash

aws cloudformation delete-stack --stack-name eksvpc
outputs=1
while [ "$outputs" != "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name eksvpc| grep -c Outputs)
	sleep 10
done

aws cloudformation delete-stack --stack-name ekssrvrole
outputs=1
while [ "$outputs" != "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name ekssrvrole| grep -c Outputs)
	sleep 10
done
