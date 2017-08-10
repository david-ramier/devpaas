#!groovy

//  AWS_PROFILE
//  AWS_SSH_KEYPAIR_NAME
//  AWS_REGION
//  AWS_VPC_CDIR
//  AWS_SUBNET_PRIV_CIDR
//  AWS_SUBNET_PUB_CIDR
//  MM_PUBLIC_IP

//  AWS_JUMPBOX_INSTANCE_NAME
//  AWS_JUMPBOX_IMAGE_ID
//  AWS_JUMPBOX_FLAVOR_NAME

//  AWS_REVPRX_INSTANCE_NAME
//  AWS_REVPRX_IMAGE_ID
//  AWS_REVPRX_FLAVOR_NAME

//  AWS_FE_SRV_INSTANCE_NAME
//  AWS_FE_SRV_IMAGE_ID
//  AWS_FE_SRV_FLAVOR_NAME

//  AWS_API_SRV_INSTANCE_NAME
//  AWS_API_SRV_IMAGE_ID
//  AWS_API_SRV_FLAVOR_NAME

//  AWS_DB_INSTANCE_NAME
//  AWS_DB_IMAGE_ID
//  AWS_DB_FLAVOR_NAME


node() {

    def  awsProfile                         = null
    def  awsSSHKeyPairName                  = null
    def  awsRegion                          = null
    def  awsVPCCIDR                         = null
    def  awsSubnetPrivateCIDR               = null
    def  awsSubnetPublicCIDR                = null
    def  awsICPublicIP                      = null

    def  awsJumpBoxInstanceName             = null
    def  awsJumpBoxImageId                  = null
    def  awsJumpBoxFlavorName               = null

    def  awsReverseProxyInstanceName        = null
    def  awsReverseProxyImageId             = null
    def  awsReverseProxyFlavorName          = null

    def  awsFrontEndServerInstanceName      = null
    def  awsFrontEndServerImageId           = null
    def  awsFrontEndServerFlavorName        = null

    def  awsHeadEndServerInstanceName       = null
    def  awsHeadEndServerImageId            = null
    def  awsHeadEndServerFlavorName         = null

    def  awsDataStoreServerInstanceName     = null
    def  awsDataStoreServerImageId          = null
    def  awsDataStoreServerFlavorName       = null

    def vpcId                               = null
    def subnetPublicId                      = null
    def subnetPrivateId                     = null
    def secGroupPackerBuilderId             = null

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

        def packerHome = tool name: 'packer-1.0.2', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
        env.PATH = "${packerHome}:${env.PATH}"

        echo "Setting up Terraform"

        def terraformfHome = tool name: 'terraform-0.9.11', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
        env.PATH = "${terraformfHome}:${env.PATH}"

        echo "Reading Parameters from seed job ... "
        awsProfile              =   params.AWS_PROFILE
        awsSSHKeyPairName       =   params.AWS_SSH_KEYPAIR_NAME
        awsRegion               =   params.AWS_REGION
        awsVPCCIDR              =   params.AWS_VPC_CDIR
        awsSubnetPrivateCIDR    =   params.AWS_SUBNET_PRIV_CIDR
        awsSubnetPublicCIDR     =   params.AWS_SUBNET_PUB_CIDR
        awsICPublicIP           =   params.MM_PUBLIC_IP

        awsJumpBoxInstanceName  =   params.AWS_JUMPBOX_INSTANCE_NAME
        awsJumpBoxImageId       =   params.AWS_JUMPBOX_IMAGE_ID
        awsJumpBoxFlavorName    =   params.AWS_JUMPBOX_FLAVOR_NAME

        awsReverseProxyInstanceName =   params.AWS_REVPRX_INSTANCE_NAME
        awsReverseProxyImageId      =   params.AWS_REVPRX_IMAGE_ID
        awsReverseProxyFlavorName   =   params.AWS_REVPRX_FLAVOR_NAME

        awsFrontEndServerInstanceName   =   params.AWS_FE_SRV_INSTANCE_NAME
        awsFrontEndServerImageId        =   params.AWS_FE_SRV_IMAGE_ID
        awsFrontEndServerFlavorName     =   params.AWS_FE_SRV_FLAVOR_NAME

        awsHeadEndServerInstanceName    =   params.AWS_API_SRV_INSTANCE_NAME
        awsHeadEndServerImageId         =   params.AWS_API_SRV_IMAGE_ID
        awsHeadEndServerFlavorName      =   params.AWS_API_SRV_FLAVOR_NAME

        awsDataStoreServerInstanceName  =   params.AWS_DB_INSTANCE_NAME
        awsDataStoreServerImageId       =   params.AWS_DB_IMAGE_ID
        awsDataStoreServerFlavorName    =   params.AWS_DB_FLAVOR_NAME

        echo "Job Parameters:  \n"

    } //end of stage: Checkout & Environment Prep

    stage('VPC Network Preparation') {

        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

            dir('devpaas-vm/terraform/providers/amazon-ebs/devpaas-distribute-vms-asg/vpc') {

                echo "Launch terraform init"

                sh "terraform init"

                echo "Launch terraform plan"

                sh "terraform plan -var 'project_name=mm-devpaas-asg' -var 'profile=$awsProfile' -var 'aws_ssh_key_name=$awsSSHKeyPairName' -var 'aws_deployment_region=$awsRegion'         "  +
                        "-var 'vpc_cidr=$awsVPCCIDR' -var 'subnet_private_cidr=$awsSubnetPrivateCIDR' -var 'subnet_public_cidr=$awsSubnetPublicCIDR'                                        "  +
                        "-var 'mm_public_ip=$awsICPublicIP'                                                                                                                                 "  +
                        "-var 'jumpbox_instance_name=$awsJumpBoxInstanceName'       -var 'jumpbox_image_id=$awsJumpBoxImageId'       -var 'jumpbox_flavor_name=$awsJumpBoxFlavorName'       "  +
                        "-var 'revprx_instance_name=$awsReverseProxyInstanceName'   -var 'revprx_image_id=$awsReverseProxyImageId'   -var 'revprx_flavor_name=$awsReverseProxyFlavorName'   "  +
                        "-var 'fe_srv_instance_name=$awsFrontEndServerInstanceName' -var 'fe_srv_image_id=$awsFrontEndServerImageId' -var 'fe_srv_flavor_name=$awsFrontEndServerFlavorName' "  +
                        "-var 'api_srv_instance_name=$awsHeadEndServerInstanceName' -var 'api_srv_image_id=$awsHeadEndServerImageId' -var 'api_srv_flavor_name=$awsHeadEndServerFlavorName' "  +
                        "-var 'db_instance_name=$awsDataStoreServerInstanceName'    -var 'db_image_id=$awsDataStoreServerImageId'    -var 'db_flavor_name=$awsDataStoreServerFlavorName' "

                echo "Launch terraform apply"

                sh "terraform apply -var 'project_name=mm-devpaas-asg' -var 'profile=$awsProfile' -var 'aws_ssh_key_name=$awsSSHKeyPairName' -var 'aws_deployment_region=$awsRegion' "                            +
                        "-var 'vpc_cidr=$awsVPCCIDR' -var 'subnet_private_cidr=$awsSubnetPrivateCIDR' -var 'subnet_public_cidr=$awsSubnetPublicCIDR'                                        "  +
                        "-var 'mm_public_ip=$awsICPublicIP'                                                                                                                                 "  +
                        "-var 'jumpbox_instance_name=$awsJumpBoxInstanceName'       -var 'jumpbox_image_id=$awsJumpBoxImageId'       -var 'jumpbox_flavor_name=$awsJumpBoxFlavorName'       "  +
                        "-var 'revprx_instance_name=$awsReverseProxyInstanceName'   -var 'revprx_image_id=$awsReverseProxyImageId'   -var 'revprx_flavor_name=$awsReverseProxyFlavorName'   "  +
                        "-var 'fe_srv_instance_name=$awsFrontEndServerInstanceName' -var 'fe_srv_image_id=$awsFrontEndServerImageId' -var 'fe_srv_flavor_name=$awsFrontEndServerFlavorName' "  +
                        "-var 'api_srv_instance_name=$awsHeadEndServerInstanceName' -var 'api_srv_image_id=$awsHeadEndServerImageId' -var 'api_srv_flavor_name=$awsHeadEndServerFlavorName' "  +
                        "-var 'db_instance_name=$awsDataStoreServerInstanceName'    -var 'db_image_id=$awsDataStoreServerImageId'    -var 'db_flavor_name=$awsDataStoreServerFlavorName' "

                vpcId           = sh(script: "terraform output aws_mm_devpaas_dv_vpc_id", returnStdout: true).trim()

                echo "VPC ID: $vpcId"

                subnetPublicId  = sh(script: "terraform output aws_mm_devpaas_dv_sb_public_id",  returnStdout: true).trim()

                echo "Public Subnet ID: $subnetPublicId"

                subnetPrivateId = sh(script: "terraform output aws_mm_devpaas_dv_sb_private_id", returnStdout: true).trim()

                echo "Private Subnet ID: $subnetPrivateId"

                secGroupPackerBuilderId = sh(script: "terraform output aws_mm_devpaas_dv_sg_packerbuilder_id", returnStdout: true).trim()

                echo "Security Group for Packer builder VMs: $secGroupPackerBuilderId"

            }
        }
    } //end of stage: VPC Network Preparation

    stage('Golden Image Creation') {

    } //end of stage: Specialized Image Creation

    stage('VMs Instantiation') {

        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

            dir('devpaas-vm/terraform/providers/amazon-ebs/devpaas-distribute-vms-asg/services') {

                echo "Launching VM Instances"

            }
        }

    } //end of stage: VMs Instantiation

    stage('Services Test ') {

        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {

            dir('devpaas-vm/terraform/providers/amazon-ebs/devpaas-distribute-vms-asg/services') {

                echo "Testing VM Instances"


            }
        }

    } //end of stage: Services Test
}