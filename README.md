# kube

Simple project to deploy Kubernetes on AWS EKS and deploy a hello world app with a database. All infrastructure must be defined as code and can thus be stood up and torn down at will in any environment.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system. This code is based on [AWS Documentaion](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

### Prerequisites

I built this project on a Windows machine with Cygwin and my personal AWS account.

```
Bash
GNU Make
jq
AWS Account
AWS CLI > 1.16.18 & Python 3, or Python > 2.7.9
AWS IAM User with Access Keys that have permission to administer the following services:
* IAM
* CloudFormation
* VPC
* EKS
```

### Installing

All the details are in the Makefile. The Makefile calls scripts from bash/ and uses CloudFormation templates in cf/.

The shortest path to done is...

```
make all
```

To cleanup just...

```
make clean
```

End with an example of getting some data out of the system or using it for a little demo--TODO

## Running the tests

To test your configuration

```
kubectl get svc --all-namespaces
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   21m
```
Note

If you receive the error "aws-iam-authenticator": executable file not found in $PATH, then your kubectl is not configured for Amazon EKS. For more information, see Configure kubectl for Amazon EKS.

```
kubectl get nodes --watch
NAME                             STATUS     ROLES    AGE   VERSION
ip-192-168-169-20.ec2.internal   NotReady   <none>   0s    v1.10.3
ip-192-168-70-151.ec2.internal   NotReady   <none>   2s    v1.10.3
ip-192-168-212-244.ec2.internal   NotReady   <none>   <invalid>   v1.10.3
...
ip-192-168-169-20.ec2.internal    Ready    <none>   39s   v1.10.3
ip-192-168-212-244.ec2.internal   Ready    <none>   35s   v1.10.3
ip-192-168-70-151.ec2.internal    Ready    <none>   42s   v1.10.3
```
#### First-app Deployment Test:

Look out for the URL to access your first deployed application on EKS cluster, at the termination/end of the `make all` command.

It lookes like *Access your application at ----> ***http://a4ef127f7e17a11e89f900aa47ab6f8e-1637274877.us-east-1.elb.amazonaws.com****

## Deployment

Note

You may receive an error that one of the Availability Zones in your request does not have sufficient capacity to create an Amazon EKS cluster. If this happens, the error output contains the Availability Zones that can support a new cluster. Retry creating your cluster with at least two subnets that are located in the supported Availability Zones for your account.

The repo contains different eksvpc.yaml files with 2 or 5 subnets in different Availability Zones. You can control which AZs the subnets go in and you may have to work around this limitation in the AWS EKS service to get it working.

## Built With

* Bash [cygwin](https://www.cygwin.com/) - GNU tools and Bash shell for Windows
* AWS CloudFormation [AWS CLI](https://aws.amazon.com/cli/) - AWS API for Bash aws-cli/1.16.45 Python/2.7.14
* [jq](https://stedolan.github.io/jq/manual/) - JSON parsin tool v1.5

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ericsopa/kube/tags). 

## Authors

* **Paul Ericson** - *Initial work* - [ericsopa](https://github.com/ericsopa)

See also the list of [contributors](https://github.com/ericsopa/kube/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Thanks to AWS for having simple CloudFormation templates
* The AWS Doc team
* Cygwin and jq devs
