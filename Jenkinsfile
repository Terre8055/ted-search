pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'openjdk-8'
        terraform 'terraform'
    }

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES') 
        gitLabConnection('gitlab')
    }

    environment {
        AWS_ECR = "644435390668.dkr.ecr.ap-south-1.amazonaws.com"
        TED_IMAGE = "embedash:1.1-SNAPSHOT"
        TED_REPO = "mike-ted:latest"
        NGINX_IMAGE = "ted_nginx:1.1-SNAPSHOT"
        NGINX_REPO = "minney-nginx:latest"
    }

    triggers {
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')    
    }



    stages {
        stage('Checkout') {
            steps {
                script {
                    env.GIT_COMMIT_MSG = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    checkout scm
                }
            }
        }

        stage('Build->Test->Package->Verify') {
            steps {
                script {
                    sh 'mvn verify'
                }
            }
        }

        stage ('Publish') {
            when {
                expression { env.GIT_COMMIT_MSG.contains('#test') }
            }
            steps {
                script {
                        sh("aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${AWS_ECR}")
                        sh("docker tag ${TED_IMAGE} ${AWS_ECR}/${TED_REPO}")
                        sh("docker tag ${NGINX_IMAGE} ${AWS_ECR}/${NGINX_REPO}")
                        sh("docker push ${AWS_ECR}/${TED_REPO}")
                        sh("docker push ${AWS_ECR}/${NGINX_REPO}")
                }
            }
        }

        stage('Terraform') {
            when {
                expression { env.GIT_COMMIT_MSG.contains('#test') }
            }
            steps {
                script {
                        sh ("terraform init -reconfigure")
                        sh ("terraform workspace new ${env.GIT_COMMITTER_NAME.toLowerCase().replaceAll(" ", "-")} || true")
                        sh ("terraform workspace select ${env.GIT_COMMITTER_NAME.toLowerCase().replaceAll(" ", "-")}")
                        sh ("terraform plan")
                        sh ("terraform apply -auto-approve")
                }
            }
        }

        stage('E2E') {
                when {
                    expression { env.GIT_COMMIT_MSG.contains('#test') }
                }
                steps {
                    script {
                        def ec2_ip = sh(script: 'terraform output -raw ec2_ip', returnStdout: true).trim()
                        def ec2_access_port = sh(script: 'terraform output -raw ec2_access_port', returnStdout: true).trim()

                        def responseCode = sh(script: "curl -v -s -o /dev/null -w '%{http_code}' http://${ec2_ip}:${ec2_access_port}", returnStdout:true).trim()

                        if (responseCode == "200") {
                            echo "E2E test passed with HTTP response code: ${responseCode}"
                        } else {
                            error "E2E test failed with HTTP response code: ${responseCode}"
                        }
                    }
                }
        }
    }

    post{
        always{
            cleanWs()
        }

        failure {
            updateGitlabCommitStatus name: 'build', state: 'failed'
        }
        success {
            updateGitlabCommitStatus name: 'build', state: 'success'
        }

    }
}