#!/bin/bash
echo Waiting for dev-worker-nodes stack to be created...
outputs=0

while [ "$outputs" == "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name dev-worker-nodes | grep -c Outputs)
done

workernodejson=$(aws cloudformation describe-stacks --stack-name dev-worker-nodes)

echo Getting NodeInstanceRole...

instrol=$(echo $workernodejson | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="NodeInstanceRole") | .OutputValue')

sed -i "s|<ARN of instance role (not instance profile)>|$instrol|g" ./cm/aws-auth-cm.yaml
