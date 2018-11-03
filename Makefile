SHELL := /bin/bash
PATH := /usr/bin:$(PATH)

role:
	-aws cloudformation create-stack --stack-name ekssrvrole --template-body file://cf/ekssvcrole.yaml --capabilities CAPABILITY_IAM

vpc:
	-aws cloudformation create-stack --stack-name eksvpc --template-body file://cf/eksvpc.yaml --capabilities CAPABILITY_IAM

kubectl:
	-curl  -o "/usr/bin/kubectl.exe" -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/windows/amd64/kubectl.exe

aws-iam-auth:
	-curl -o "/usr/bin/aws-iam-authenticator.exe" -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/windows/amd64/aws-iam-authenticator.exe

cluster:
	-./bash/create-cluster.sh

clusterchk:
	-./bash/clusterchk.sh

all:	role vpc cluster kubectl aws-iam-auth clusterchk

clean:
	-./bash/delete-cluster.sh
	-aws cloudformation delete-stack --stack-name eksvpc 
	-aws cloudformation delete-stack --stack-name ekssrvrole
	-rm /usr/bin/kubectl.exe
	-rm /usr/bin/aws-iam-authenticator.exe
