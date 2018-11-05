#!/bin/bash

# Get Role ARN
echo Waiting for ekssrvrole stack to be created...
outputs=0

while [ "$outputs" == "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name ekssrvrole | grep -c Outputs)
	sleep 10
done

aws cloudformation describe-stacks --stack-name ekssrvrole | grep -c Outputs

echo Getting Role ARN...

rolearn=$(aws cloudformation describe-stacks --stack-name ekssrvrole | jq -r .Stacks[].Outputs[].OutputValue)

echo role ARN: $rolearn

# Get SubnetIds and SecurityGroups
echo Waiting for eksvpc stack to be created...
outputs=0

while [ "$outputs" == "0"  ]; do
	outputs=$(aws cloudformation describe-stacks --stack-name eksvpc | grep -c Outputs)
	sleep 10
done

aws cloudformation describe-stacks --stack-name eksvpc | grep -c Outputs

echo Getting VPC Stack JSON...

vpcstackjson=$(aws cloudformation describe-stacks --stack-name eksvpc)

echo VPC Stack: $vpcstackjson

echo Getting Subnets...

subnets=$(echo $vpcstackjson | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="SubnetIds") | .OutputValue')

echo Subnets: $subnets

echo Getting Security Groups...

secgrps=$(echo $vpcstackjson | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="SecurityGroups") | .OutputValue')

echo Getting VPC ID...

vpcid=$(echo $vpcstackjson | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="VpcId") | .OutputValue')

echo Security Groups: $secgrps

# Create EKS Cluster
echo "aws eks create-cluster --name dev --role-arn $rolearn --resources-vpc-config subnetIds=$subnets,securityGroupIds=$secgrps"

aws eks create-cluster --name dev --role-arn $rolearn --resources-vpc-config subnetIds=$subnets,securityGroupIds=$secgrps

cp ./cf/amazon-eks-nodegroup-parameters.json.template ./cf/amazon-eks-nodegroup-parameters.json

sed -i "s/<vpcid>/$vpcid/g" ./cf/amazon-eks-nodegroup-parameters.json
sed -i "s/<subnets>/$subnets/g" ./cf/amazon-eks-nodegroup-parameters.json
sed -i "s/<secgrps>/$secgrps/g" ./cf/amazon-eks-nodegroup-parameters.json
