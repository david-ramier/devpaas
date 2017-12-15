pipeline {

    agent any

    parameters {
        string(defaultValue: 'marmac-marcomaccio-eu-west-1',    description: 'AWS Credential Profile',                         name: 'AWS_PROFILE')
        string(defaultValue: 'marmac_marcomaccio_rsa',          description: 'AWS SSH Key Pair name',                          name: 'AWS_SSH_KEY_PAIR_NAME')

        string(defaultValue: 'eu-west-1',                       description: 'AWS Region in which deploy this infrastructure', name: 'AWS_REGION')

        string(defaultValue: '10.0.0.0/16', description: 'CIDR for the VPC',                       name: 'AWS_VPC_CDIR')
        string(defaultValue: '10.0.1.0/24', description: 'CIDR for the Public Subnet',             name: 'AWS_SUBNET_PUB_CIDR')
        string(defaultValue: '10.0.2.0/24', description: 'CIDR for the Private Subnet',            name: 'AWS_SUBNET_PRIV_CIDR')

        string(defaultValue: 'mm-dp-jumpbox', description: 'Instance name of the Jumpbox',           name: 'AWS_JUMPBOX_SRV_INSTANCE_NAME')
        string(defaultValue: 'ami-11be7268', description: 'AMI Image Id of the Jumpbox',            name: 'AWS_JUMPBOX_SRV_IMAGE_ID')
        string(defaultValue: 't2.micro', description: 'VM Flavor of the Jumpbox',               name: 'AWS_JUMPBOX_SRV_FLAVOR_NAME')

        string(defaultValue: 'mm-dp-revprx-srv', description: 'Instance name of the Reverse Proxy',     name: 'AWS_REVPROXY_SRV_INSTANCE_NAME')
        string(defaultValue: 'ami-5e884527', description: 'AMI Image Id of the Reverse Proxy',      name: 'AWS_REVPROXY_SRV_IMAGE_ID')
        string(defaultValue: 't2.micro', description: 'VM Flavor of the Reverse Proxy',         name: 'AWS_REVPROXY_SRV_FLAVOR_NAME')

        string(defaultValue: 'mm-dp-jenkins-srv', description: 'Instance name of the Jenkins',           name: 'AWS_JENKINS_SRV_INSTANCE_NAME')
        string(defaultValue: 'ami-4422e03d', description: 'AMI Image Id of the Jenkins',            name: 'AWS_JENKINS_SRV_IMAGE_ID')
        string(defaultValue: 't2.medium', description: 'VM Flavor of the Jenkins',               name: 'AWS_JENKINS_SRV_FLAVOR_NAME')

        string(defaultValue: 'mm-dp-nexus-srv', description: 'Instance name of the Nexus',             name: 'AWS_NEXUS_SRV_INSTANCE_NAME')
        string(defaultValue: 'ami-89814cf0', description: 'AMI Image Id of the Nexus',              name: 'AWS_NEXUS_SRV_IMAGE_ID')
        string(defaultValue: 't2.medium', description: 'VM Flavor of the Nexus',                 name: 'AWS_NEXUS_SRV_FLAVOR_NAME')

        string(defaultValue: 'mm-dp-sonarqube-srv', description: 'Instance name of the Sonarqube',         name: 'AWS_SONARQUBE_SRV_INSTANCE_NAME')
        string(defaultValue: 'ami-68884511', description: 'AMI Image Id of the Sonarqube',          name: 'AWS_SONARQUBE_SRV_IMAGE_ID')
        string(defaultValue: 't2.medium', description: 'VM Flavor of the Sonarqube',             name: 'AWS_SONARQUBE_SRV_FLAVOR_NAME')

    }

    environment {
        PACKER_HOME    = tool(name: 'packer-1.0.2', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation')
        TERRAFORM_HOME = tool(name: 'terraform-0.9.11', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation')
    }

    tools {
        maven 'm2-3.5.0'
        //packer 'packer-1.0.2'
        //terraform 'terraform-0.9.11'  need to investigate better on the syntax
    }

    stages {
        stage('Checkout-EnvPreparation') {
            agent none
            steps {
                withCredentials([
                        [
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'marmac-marcomaccio-eu-west-1',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                ]) {}

                git branch: 'devpaas-vm-reorg',
                        credentialsId: 'github-marcomaccio',
                        url: 'https://github.com/marcomaccio/devpaas.git'

                script {
                    awsICPublicIP = sh(script: 'dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short', returnStdout: true).trim()
                }

            }
        }
        stage('EC2 Deployment') {
            steps {
                wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                    dir('devpaas-vm/terraform/providers/amazon-ebs/devpaas-distribute-vms-asg/vpc') {

                        echo "Launch terraform init"

                        sh "${TERRAFORM_HOME}/terraform init"

                        echo "Launch terraform plan"

                        sh "${TERRAFORM_HOME}/terraform plan --out terraform.plan                                         " +
                                "-var 'project_name=mm-devpaas-asg'                                     " +
                                "-var 'profile=$AWS_PROFILE'                                            " +
                                "-var 'aws_ssh_key_name=$AWS_SSH_KEY_PAIR_NAME'                         " +
                                "-var 'aws_deployment_region=$AWS_REGION'                               " +
                                "-var 'vpc_cidr=$AWS_VPC_CDIR'                                          " +
                                "-var 'subnet_private_cidr=$AWS_SUBNET_PRIV_CIDR'                       " +
                                "-var 'subnet_public_cidr=$AWS_SUBNET_PUB_CIDR'                         " +
                                "-var 'mm_public_ip=${awsICPublicIP}'                                   " +
                                "-var 'jumpbox_instance_name=$AWS_JUMPBOX_SRV_INSTANCE_NAME'            " +
                                "-var 'jumpbox_image_id=$AWS_JUMPBOX_SRV_IMAGE_ID'                      " +
                                "-var 'jumpbox_flavor_name=$AWS_JUMPBOX_SRV_FLAVOR_NAME'                " +
                                "-var 'revprx_instance_name=$AWS_REVPROXY_SRV_INSTANCE_NAME'            " +
                                "-var 'revprx_image_id=$AWS_REVPROXY_SRV_IMAGE_ID'                      " +
                                "-var 'revprx_flavor_name=$AWS_REVPROXY_SRV_FLAVOR_NAME'                " +
                                "-var 'jenkins_srv_instance_name=$AWS_JENKINS_SRV_INSTANCE_NAME'        " +
                                "-var 'jenkins_srv_image_id=$AWS_JENKINS_SRV_IMAGE_ID'                  " +
                                "-var 'jenkins_srv_flavor_name=$AWS_JENKINS_SRV_FLAVOR_NAME'            " +
                                "-var 'nexus_srv_instance_name=$AWS_NEXUS_SRV_INSTANCE_NAME'            " +
                                "-var 'nexus_srv_image_id=$AWS_NEXUS_SRV_IMAGE_ID'                      " +
                                "-var 'nexus_srv_flavor_name=$AWS_NEXUS_SRV_FLAVOR_NAME'                " +
                                "-var 'sonarqube_srv_instance_name=$AWS_SONARQUBE_SRV_INSTANCE_NAME'    " +
                                "-var 'sonarqube_srv_image_id=$AWS_SONARQUBE_SRV_IMAGE_ID'              " +
                                "-var 'sonarqube_srv_flavor_name=$AWS_SONARQUBE_SRV_FLAVOR_NAME'        "

                        timeout(60) {
                            script {
                                env.TERRAFORM_PLAN_VALUE = input message: 'Do you think the Terraform plan looks good?',
                                        parameters: [choice(name: 'Tag on Docker Hub',
                                                choices: 'no\nyes',
                                                description: 'Choose "yes" if you want to deploy this build'
                                        )]
                            }
                        }

                        when {
                            environment name: 'TERRAFORM_PLAN_VALUE', value: 'yes'
                            echo "Launch terraform apply"

                            sh "${TERRAFORM_HOME}/terraform apply terraform.plan"
                        }
                    }
                }
            }

        }
        stage('Smoke Tests') {
            steps {
                echo "Here there will be the Smoke Test running ..."

            }
        }
    }
}