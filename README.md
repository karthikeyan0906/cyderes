**1) How to use project eks_project**

export your github credentials locally ,
these will be used by terraform to push secrets into your repository:

export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-personal-access-token

**2) initialize and apply the terraform config**

this will create:

the eks cluster and managed node group

required iam roles and policies

an iam user for github actions with programmatic access

github repo secrets (aws access and secret keys) using the github provider

**Commands :**

setup aws cli acccess , terraform 

terraform init

terraform apply

configure your local environment

set up your kubeconfig:

bash
aws configure
aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>
update the aws-auth config map

this step allows the github action's iam user to access the cluster:

**command to add githubaction IAM role** in aws-auth configmap to allow cluster permission 
kubectl edit configmap aws-auth -n kube-system
add a new mapUsers entry with the iam arn created by terraform and assign it a username and group like system:masters.

**3) verify your repo secrets are set correctly**

confirm that your dockerhub creds (DOCKER_USERNAME and DOCKER_PASSWORD) and 
terraform-set aws creds (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) are present in the github repo’s secrets.

**4) build and push the docker image**

this happens automatically when you push code to the main or initial branch. github actions will:

build the custom nginx docker image

push it to dockerhub

**5) deploy to eks using helm**

trigger the deploy workflow manually from the github actions tab and provide the following inputs:

cluster_name: your eks cluster name

region: aws region

this will:

configure kube access

install helm

deploy the latest image to eks
