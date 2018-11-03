# kube

Simple project to deploy Kubernetes on AWS EKS and deploy a hello world app with a database. All infrastructure must be defined as code and can thus be stood up and torn down at will in any environment.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

I built this project on a Windows machine with Cygwin and my personal AWS account.

```
Bash
GNU Make
jq
AWS Account
AWS CLI
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

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

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
