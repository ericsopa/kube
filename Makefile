SHELL := /bin/bash
PATH := /usr/bin:$(PATH)

role:
	-aws cloudformation create-stack --stack-name ekssrvrole --template-body file://cf/ekssvcrole.yaml --capabilities CAPABILITY_IAM

vpc:
	-aws cloudformation create-stack --stack-name eksvpc --template-body file://cf/eksvpc.yaml --capabilities CAPABILITY_IAM

kubectl:
	-curl  -o "/usr/bin/kubectl.exe" -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/windows/amd64/kubectl.exe
	-chmod 755 /usr/bin/kubectl.exe

aws-iam-auth:
	-curl -o "/usr/bin/aws-iam-authenticator.exe" -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/windows/amd64/aws-iam-authenticator.exe
	-chmod 755 /usr/bin/aws-iam-authenticator.exe

cluster:
	-./bash/create-cluster.sh

clusterchk:
	-./bash/clusterchk.sh

updkubconf:
	aws eks update-kubeconfig --name dev

kubekeys:
	aws ec2 create-key-pair --key-name kubekeys > kubekeys.json

workernodes:
	-aws cloudformation create-stack --stack-name dev-worker-nodes --template-url https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2018-08-30/amazon-eks-nodegroup.yaml --parameters file://cf/amazon-eks-nodegroup-parameters.json --region us-east-1 --capabilities CAPABILITY_IAM

confman:
	-curl -o "cm/aws-auth-cm.yaml" -O https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2018-08-30/aws-auth-cm.yaml
	-bash/aws-auth-cm.sh
	-kubectl apply -f ./cm/aws-auth-cm.yaml

all:	role vpc cluster kubectl aws-iam-auth clusterchk updkubconf kubekeys workernodes confman

clean:
	-aws cloudformation delete-stack --stack-name dev-worker-nodes
	-./bash/delete-cluster.sh
	-aws cloudformation delete-stack --stack-name eksvpc 
	-aws cloudformation delete-stack --stack-name ekssrvrole
	-aws ec2 delete-key-pair --key-name kubekeys
	-rm kubekeys.json
	-rm ./cf/amazon-eks-nodegroup-parameters.json
	-rm ./cm/aws-auth-cm.yaml
	-rm /usr/bin/kubectl.exe
	-rm /usr/bin/aws-iam-authenticator.exe
