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
                sh "terraform get  ."
                sh "terraform plan ."
            }
        }


    } //end of stage: VPC Network Preparation

    stage('Golden Image Creation') {
        parallel(

            'Nginx Image': {
                echo  'Create NGINX Image'
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
                            "images/jenkins/packer-jenkins-rhel6.json"
                    }
                }

            },
            'Artifactory Image': {
                echo  'Create Artifactory VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                    }
                }
            }
            ,
            'SonarQube Image': {
                echo  'Create Sonarqube VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

                    }
                }
            },
            'MySQL Server Image' {
                echo  'Create MySQL VM Image'

                dir('devpaas-vm/packer') {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

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