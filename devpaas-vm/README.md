# DEVPAAS with VMs

## Scope & Goals
Scope of this project is to create a developer paas (Platform As A Service for Development) with all the needed components to operate Continuous Integration & Continuous Delivery for development of:
* Java project
* Android project
* Python project
* npm project

The DEV-PAAS platform provides the following services: 
* Continuous Integration Service based on Jenkins 
* Quality Manager Service based on SonarQube
* Repository Manager Service based on Nexus 
* Monitoring Service based on ELK

## Architectures

This platform is provided in some flavor so it could meet different user needs. 
The flavors considered here are:
* Single instance VM with internal reverse proxy: this is mostly a single developer option or a demo option to show how to use packer and terraform to create a VM that provide the 3 Main services needed by a developer. Pretty convenient on Virtualbox
* Single instance VM with external reverse proxy and db: this option is similar to the previous one but with  
* Distributed VMs: this option scales better in a cloud environment like Amazon, Google Compute Engine, etc. 

### Single Instance VM with internal reverse proxy

### Single Instance VM with external reverse proxy and db

### Distributed VMs


![Alt text](https://g.gravizo.com/source/custom_mark13?https%3A%2F%2Fraw.githubusercontent.com%2Fmarcomaccio%2Fdevpaas%2Fmaster%2Fdevpaas-vm%2FREADME.md)
<details> 
<summary></summary>
custom_mark13
@startuml;
title Dev PAAS vm architecture;
node nginx <<vm>> as nginx;
node gitlab <<vm>> as scm;
node agilfant <<vm>> as pms;
node sonarqube <<vm>> as qms;
node jenkins <<vm>> as cis;
node nexus <<vm>> as rms;
node elastic <<vm>> as elastic;
node logspout <<vm>> as logspout;
node kibana <<vm>> as kibana;
database mariadb_agilefant <<vm>>;
database mariadb_gitlab <<vm>>;
database mariadb_sonarqube <<vm>>;
nginx -left-> pms : "http 80";
pms -down-> mariadb_agilefant : tcp 3306;
nginx -down-> scm : "/gitlab http 80";
scm -down-> mariadb_gitlab : tcp 3306;
nginx -down-> cis : "/jenkins http 8080" ;
nginx -down-> qms : "/sonarqube http 9000" ;
qms -down-> mariadb_sonarqube;
nginx -right-> rms: "/nexus http 8081";
nginx --> logspout;
nginx --> kibana;
kibana --> elastic;
pms --> logspout;
cis --> scm : http 80;
cis --> qms : http 9000;
cis --> rms : http 8081;
cis --> logspout;
scm --> logspout;
qms --> logspout;
rms --> logspout;
mariadb_gitlab --> logspout;
mariadb_sonarqube --> logspout;
mariadb_agilefant --> logspout;
logspout -right-> elastic;
@enduml
custom_mark13
</details>

#Test

![Alt text](https://g.gravizo.com/svg?
@startuml;
title Dev PAAS Users;
actor :Customer:      as customer;
actor :Product Owner: as po;
actor :Scrum Master:  as sm;
actor :Developer:     as dev;
User <|-- po;
User <|-- sm;
User <|-- dev;
User <|-- customer;
@enduml)


TODO: 
Configure Kibana with NGINX as stated here https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-16-04


## Deployment procedures

### Single instance deployment with Internal Reverse Proxy

#### VirtualBox

#### Amazon

Creation of the Tenant

Creation of the Packer images

Creation of the VMs

Tests

#### GCP

Creation of the Tenant

Creation of the Packer images

Creation of the VMs

Tests

### Single instance deployment with External Reverse Proxy

#### VirtualBox

#### Amazon

Creation of the Tenant

Creation of the Packer images

Creation of the VMs

Tests

#### GCP

Creation of the Tenant

Creation of the Packer images

Creation of the VMs

Tests

### Distributed VMs

![Alt text](https://g.gravizo.com/source/custom_mark13?https%3A%2F%2Fraw.githubusercontent.com%2Fmarcomaccio%2Fdevpaas%2Fmaster%2Fdevpaas-vm%2FREADME.md)
<details> 
<summary></summary>
custom_mark13
@startuml;
title Dev PAAS Single VM architecture;
node nginx <<vm>> as nginx;
node jenkins <<vm>> as cis;
node sonarqube <<vm>> as qms;
node nexus <<vm>> as rms;
node elk <<vm>> as elk;
database mariadb_sonarqube <<vm>>;
nginx -down-> cis : "/jenkins http 8080";
nginx -down-> qms : "/sonarqube http 9000";
nginx -down-> rms: "/nexus http 8081";
nginx -down-> elk: "/kibana http 5601";
qms -down-> mariadb_sonarqube;
cis -left-> qms : http 9000;
cis -right-> rms : http 8081;
cis -up-> elk;
qms --> elk;
rms --> elk;
mariadb_sonarqube --> elk;
@enduml
custom_mark13
</details>

#### Amazon

Creation of the Tenant

Creation of the Packer images

Creation of the VMs

Tests

#### GCP