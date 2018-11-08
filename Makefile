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

#Create the Redis master replication controller
rc-redis-master:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-master-controller.json
	-sleep 5

#Create the Redis master service
svc-redis-master:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-master-service.json
	-sleep 5

#Create the Redis slave replication controller
rc-redis-slave:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-slave-controller.json
	-sleep 5

#Create the Redis slave service
svc-redis-slave:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-slave-service.json
	-sleep 5

#Create the guestbook replication controller
rc-guestbook:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/guestbook-controller.json
	-sleep 5

#Create the guestbook service
svc-guestbook:
	-kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/guestbook-service.json
	-sleep 5

guestbook: rc-redis-master svc-redis-master rc-redis-slave svc-redis-slave rc-guestbook svc-guestbook

eks:	role vpc cluster kubectl aws-iam-auth clusterchk updkubconf kubekeys workernodes confman

all:	eks guestbook

clean:
	-kubectl delete rc/redis-master rc/redis-slave rc/guestbook svc/redis-master svc/redis-slave svc/guestbook
	-./bash/clean-workers.sh
	-./bash/delete-cluster.sh
	-./bash/clean-vpc-role.sh
	-aws ec2 delete-key-pair --key-name kubekeys
	-rm kubekeys.json
	-rm ./cf/amazon-eks-nodegroup-parameters.json
	-rm ./cm/aws-auth-cm.yaml
	-rm /usr/bin/kubectl.exe
	-rm /usr/bin/aws-iam-authenticator.exe
