# EKS Infrastructure Deployment & CI/CD Pipeline

1. Project Overview

This repository demonstrates EKS infrastructure deployment using Terraform, Docker image build and push via GitHub Actions, and automated Helm-based application delivery to Kubernetes.

2. Infrastructure 

Terraform used to provision EKS cluster version 1.29, node groups with attached policies ( EKS ,ECR,SSM,) IAM roles ,github action secrets, k8 cluster role for github action

terraform apply triggered from local environment.

kubernetes access configured with aws eks update-kubeconfig.

3. CI/CD Pipeline

GitHub Actions handles:

parameterized values.yml 

Docker image build & push on main branch push

Helm deployment to EKS via workflow_dispatch

Secrets like docker and aws creds are stored securely in repo settings.

Application exposed via service type as loadbalancer

4. Challenges 

NodePort SG Issues: Initially i used nodeport and manually allowed the port in node SG but that gave additional code to write tf codebase hence Resolved by switching to LoadBalancer service type.

IAM Role issues in aws-auth: created cluster role,groups ,permissions and role bindings with k8 terraform provider and manually updated the aws auth config map 

IAM role issues in cluster : cluster couldnt connect with nodegroups as sandbox service in nodes wasnt started as it didnt had ECR permissions which required for AWS to spin up some daemon pods like kube-dns,kube-proxy,aws-node ( manages CNI ), i logged into one of the running nodes via session manager and checked the cloud init logs to confirm this as nodes werent connected to cluster 

After adding the ECR permissions it was fixed and i replaced the node group instances via terraform so new instance sandbox services are started properly as they run only on first boot 

Helm Chart Service Confusion: Debugged and fixed service.yaml to align with correct values.yaml. and helm space issues was faced and fixed by adding commands in single line instead of backslash / 

Githubaction issues :

helm chart was failing in githuaction as the path was not correcly updated and even after updating the paths i was getting error while running helm charts as i triggered the failed workflow which has old path of helm even though source file was updated

Terraform issues : syntax issues was fixed by terraform validate , indenation issues was fixed by terraform fmt commands , while setting up S3 backend directories got terraform initializing error for backend which was fixed with migrate-state Terraform comamnds 

Local issues : since i used git bash on windows, i had lots of issues in confguring aws,kubectl,terraform which was fixed by updating the file path in bash_prompt and souring it 

5. other solutions i woud have added if i got more time 

TLS setup via cert-manager

prometheus graphana for monitoring

adding terrafork modules to update aws-auth configmap with githubactions IAM Role which was done manually now 

creating k8 resources like namespace via helm instead of using defaut namespace

.github/workflows when placed inside project root "eks_project" as i had other terraform project in same repo, it was giving error as github workflow should be kept in root of the repo which needs to be checked and fixed by forcing githubaction to check the workflow in custom path rather checking in the root of the repository