#!groovy

node() {

    stage('Checkout & Environment Prep'){

        // TODO: change credentialId
        withCredentials([
                [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'marmac-marcomaccio-eu-west-1',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]
        ]) {

        }

        git branch: 'devpaas-vm-reorg',
                credentialsId: 'github-marcomaccio',
                url: 'https://github.com/marcomaccio/devpaas.git'

        echo "Setting up Packer"

        def packerHome = tool name: 'packer-1.0.0', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
        env.PATH = "${packerHome}:${env.PATH}"

        echo "Setting up Terraform"

        def terraformfHome = tool name: 'terraform-0.9.6', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
        env.PATH = "${terraformfHome}:${env.PATH}"



    } //end of stage: Checkout & Environment Prep

    stage('VPC Network Preparation') {

        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
            dir('devpaas-vm/terraform/providers/amazon-ebs/devpaas-distribute-vms/network') {
                sh "terraform plan -var 'aws_ssh_key_name=$AWS_SSH_KEYPAIR_NAME' -var 'aws_deployment_region=$AWS_REGION' "                            +
                        "-var 'vpc_cidr=$AWS_VPC_CDIR' -var 'subnet_private_cidr=$AWS_SUBNET_PRIV_CIDR' -var 'subnet_public_cidr=$AWS_SUBNET_PUB_CIDR' " +
                        "-var 'mm_public_ip=$MM_PUBLIC_IP' "                                    +
                        "-var 'jumpbox_instance_name=$AWS_JUMPBOX_INSTANCE_NAME' -var 'jumpbox_image_id=$AWS_JUMPBOX_IMAGE_ID' -var 'jumpbox_flavor_name=$AWS_JUMPBOX_FLAVOR_NAME' "  +
                        "-var 'revprx_instance_name=$AWS_REVPRX_INSTANCE_NAME'   -var 'revprx_image_id=$AWS_REVPRX_IMAGE_ID'   -var 'revprx_flavor_name=$AWS_REVPRX_FLAVOR_NAME' "        +
                        "-var 'fe_srv_instance_name=$AWS_FE_SRV_INSTANCE_NAME'   -var 'fe_srv_image_id=$AWS_FE_SRV_IMAGE_ID'   -var 'fe_srv_flavor_name=$AWS_FE_SRV_FLAVOR_NAME' "        +
                        "-var 'api_srv_instance_name=$AWS_API_SRV_INSTANCE_NAME' -var 'api_srv_image_id=$AWS_API_SRV_IMAGE_ID' -var 'api_srv_flavor_name=$AWS_API_SRV_FLAVOR_NAME' "  +
                        "-var 'db_instance_name=$AWS_DB_INSTANCE_NAME'           -var 'db_image_id=$AWS_DB_IMAGE_ID'           -var 'db_flavor_name=$AWS_DB_FLAVOR_NAME' "

                sh "terraform apply -var 'aws_ssh_key_name=$AWS_SSH_KEYPAIR_NAME' -var 'aws_deployment_region=$AWS_REGION' "                            +
                        "-var 'vpc_cidr=$AWS_VPC_CDIR' -var 'subnet_private_cidr=$AWS_SUBNET_PRIV_CIDR' -var 'subnet_public_cidr=$AWS_SUBNET_PUB_CIDR' " +
                        "-var 'mm_public_ip=$MM_PUBLIC_IP' "                                    +
                        "-var 'jumpbox_instance_name=$AWS_JUMPBOX_INSTANCE_NAME' -var 'jumpbox_image_id=$AWS_JUMPBOX_IMAGE_ID' -var 'jumpbox_flavor_name=$AWS_JUMPBOX_FLAVOR_NAME' "  +
                        "-var 'revprx_instance_name=$AWS_REVPRX_INSTANCE_NAME'   -var 'revprx_image_id=$AWS_REVPRX_IMAGE_ID'   -var 'revprx_flavor_name=$AWS_REVPRX_FLAVOR_NAME' "        +
                        "-var 'fe_srv_instance_name=$AWS_FE_SRV_INSTANCE_NAME'   -var 'fe_srv_image_id=$AWS_FE_SRV_IMAGE_ID'   -var 'fe_srv_flavor_name=$AWS_FE_SRV_FLAVOR_NAME' "        +
                        "-var 'api_srv_instance_name=$AWS_API_SRV_INSTANCE_NAME' -var 'api_srv_image_id=$AWS_API_SRV_IMAGE_ID' -var 'api_srv_flavor_name=$AWS_API_SRV_FLAVOR_NAME' "  +
                        "-var 'db_instance_name=$AWS_DB_INSTANCE_NAME'           -var 'db_image_id=$AWS_DB_IMAGE_ID'           -var 'db_flavor_name=$AWS_DB_FLAVOR_NAME' "
            }
        }


    } //end of stage: VPC Network Preparation

    stage('Golden Image Creation') {
        parallel(
            'NGINX Image': {
                echo  'Create NGINX VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                        sh "packer build -machine-readable --only=$PACKER_PROVIDERS_LIST $PACKER_DEBUG "    +
                                "-var 'aws_ssh_username=$AWS_SSH_USERNAME' "                                    +
                                "-var 'aws_ssh_keypair_name=$AWS_SSH_KEYPAIR_NAME' "                            +
                                "-var 'aws_ssh_private_key_file=$AWS_SSH_PRIVATE_KEY_FILE' "                    +
                                "-var 'aws_region=$AWS_REGION' "                                                +
                                "-var 'aws_vpc_id=$AWS_VPC_ID' "                                                +
                                "-var 'aws_subnet_id=$AWS_SUBNET_ID' "                                          +
                                "-var 'aws_source_image=$AWS_SOURCE_IMAGE'"                                     +
                                "-var 'aws_instance_type=$AWS_INSTANCE_TYPE' "                                  +
                                "images/nginx/packer-nginx-ubuntu.json"
                    }
                }
            },
            'Jenkins Master Image': {
                echo  'Create Jenkins Master VM Image'

                dir('devpaas-vm/packer'){
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                        sh "packer build -machine-readable --only=$PACKER_PROVIDERS_LIST $PACKER_DEBUG "    +
                            "-var 'aws_ssh_username=$AWS_SSH_USERNAME' "                                    +
                            "-var 'aws_ssh_keypair_name=$AWS_SSH_KEYPAIR_NAME' "                            +
                            "-var 'aws_ssh_private_key_file=$AWS_SSH_PRIVATE_KEY_FILE' "                    +
                            "-var 'aws_region=$AWS_REGION' "                                                +
                            "-var 'aws_vpc_id=$AWS_VPC_ID' "                                                +
                            "-var 'aws_subnet_id=$AWS_SUBNET_ID' "                                          +
                            "-var 'aws_source_image=$AWS_SOURCE_IMAGE'"                                     +
                            "-var 'aws_instance_type=$AWS_INSTANCE_TYPE' "                                  +
                            "images/jenkins/packer-jenkins-ubuntu.json"
                    }
                }

            },
            'Artifactory Image': {
                echo  'Create Nexus VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                        sh "packer build -machine-readable --only=$PACKER_PROVIDERS_LIST $PACKER_DEBUG "    +
                                "-var 'aws_ssh_username=$AWS_SSH_USERNAME' "                                    +
                                "-var 'aws_ssh_keypair_name=$AWS_SSH_KEYPAIR_NAME' "                            +
                                "-var 'aws_ssh_private_key_file=$AWS_SSH_PRIVATE_KEY_FILE' "                    +
                                "-var 'aws_region=$AWS_REGION' "                                                +
                                "-var 'aws_vpc_id=$AWS_VPC_ID' "                                                +
                                "-var 'aws_subnet_id=$AWS_SUBNET_ID' "                                          +
                                "-var 'aws_source_image=$AWS_SOURCE_IMAGE'"                                     +
                                "-var 'aws_instance_type=$AWS_INSTANCE_TYPE' "                                  +
                                "images/nexus/packer-nexus3-ubuntu.json"
                    }
                }
            },
            'SonarQube Image': {
                echo  'Create Sonarqube VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                        sh "packer build -machine-readable --only=$PACKER_PROVIDERS_LIST $PACKER_DEBUG "    +
                                "-var 'aws_ssh_username=$AWS_SSH_USERNAME' "                                    +
                                "-var 'aws_ssh_keypair_name=$AWS_SSH_KEYPAIR_NAME' "                            +
                                "-var 'aws_ssh_private_key_file=$AWS_SSH_PRIVATE_KEY_FILE' "                    +
                                "-var 'aws_region=$AWS_REGION' "                                                +
                                "-var 'aws_vpc_id=$AWS_VPC_ID' "                                                +
                                "-var 'aws_subnet_id=$AWS_SUBNET_ID' "                                          +
                                "-var 'aws_source_image=$AWS_SOURCE_IMAGE'"                                     +
                                "-var 'aws_instance_type=$AWS_INSTANCE_TYPE' "                                  +
                                "images/sonarqube/packer-sonarqube-ubuntu.json"
                    }
                }
            },
            'MySQL Server Image': {
                echo  'Create MySQL VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                    }
                }
            },
            'ELK Image': {
                echo  'Create ELK VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                        sh "packer build -machine-readable --only=$PACKER_PROVIDERS_LIST $PACKER_DEBUG "    +
                                "-var 'aws_ssh_username=$AWS_SSH_USERNAME' "                                    +
                                "-var 'aws_ssh_keypair_name=$AWS_SSH_KEYPAIR_NAME' "                            +
                                "-var 'aws_ssh_private_key_file=$AWS_SSH_PRIVATE_KEY_FILE' "                    +
                                "-var 'aws_region=$AWS_REGION' "                                                +
                                "-var 'aws_vpc_id=$AWS_VPC_ID' "                                                +
                                "-var 'aws_subnet_id=$AWS_SUBNET_ID' "                                          +
                                "-var 'aws_source_image=$AWS_SOURCE_IMAGE'"                                     +
                                "-var 'aws_instance_type=$AWS_INSTANCE_TYPE' "                                  +
                                "images/elk/packer-elk-ubuntu.json"
                    }
                }
            }
        )
    } //end of stage: Specialized Image Creation

    stage('VMs Instantiation') {

    } //end of stage: VMs Instantiation

    stage('Services Test ') {

    } //end of stage: Services Test
}