# ted-search
Ted search is an application that provides videos on demand. This repo stores my terraform configuration and Jenkinsfiles for CI/CD and deployment, provisioning on AWS EC2 instances
Ted search is a three-tier application; the main application that processes logic, the frontend served by nginx, and memcached that caches data for faster access and retrival.
All three services are ran on a docker container in aws ec2 instance. 
