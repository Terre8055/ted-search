# ted-search
Ted search is an application that provides videos on demand. This repo stores my terraform configuration and Jenkinsfiles for CI/CD and deployment, provisioning on AWS EC2 instances
Ted search is a three-tier application; the main application that processes logic, the frontend served by nginx, and memcached that caches data for faster access and retrival.


## Jenkinsfiles
The Jenkinsfiles in this repository define the Continuous Integration and Continuous Deployment (CI/CD) pipeline for Ted Search. The pipeline automates the building, testing, and deployment of the application. Jenkins is configured to trigger this pipeline on each code push or merge request.

## Main Application:

Handles the core logic and processing of Ted Search.
Deployed on an EC2 instance.

## Frontend (Nginx):

Serves the user interface and static content.
Nginx is used as the web server.
Deployed on a separate EC2 instance.

## Memcached:

Provides caching to optimize data retrieval.
Enhances application performance.
Deployed on another EC2 instance.
Security Groups and Networking
Security groups are defined to control inbound and outbound traffic for each tier.
Appropriate VPC configurations are set up for network isolation and security.

## CI/CD Pipeline
Jenkins orchestrates the CI/CD pipeline.
Commits and merge requests trigger automated builds, tests, and deployments.
Jenkinsfiles define the stages and steps in the pipeline.
