# bv-test
The terraform has been formed to the v0.12 

to make it work. 
First we need to execute terraform_infra 
Since there are a lot of dependencies trough variables, spliting the terraform was necessary. (depends on was not working)

After executing the terraform_infra 
We can execute the terraform_deploy which will create the WP site and the ALB for the site. 

TO DO: Automation steps. 
Creating a Jenkins job on a jenkins server. Creating a Jenkins.groovy job and set the jenkins job to monitor the repository for changes. 
Jenkins.groovy have steps to execute the terraform with the correct steps.