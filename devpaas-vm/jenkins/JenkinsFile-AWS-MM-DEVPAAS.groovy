#!groovy

node() {

    stage('Checkout & Environment Prep'){
        git 'https://github.com/marcomaccio/devpaas.git'
    } //end of stage: Checkout & Environment Prep

    stage('VPC Network Preparation') {

    } //end of stage: VPC Network Preparation

    stage('Specialized Image Creation') {
        parallel(){

        }
    } //end of stage: Specialized Image Creation

    stage('VMs Instantiation') {

    } //end of stage: VMs Instantiation

    stage('Services Test ') {

    } //end of stage: Services Test
}