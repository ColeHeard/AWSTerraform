# Cole's AWS Terraform Test
Version: 1.0
Date: 10/09/2022
Notes: Creating a scalable group of webhosts in AWS.

Prerequisites:
    Terraform
    Terraform vscode pluggin
    An AWS account.
    An AWS access key and secret key pair, set as environmental variables.

Commands:
1. export TF_VAR_aws_akey=*KEYVALUE*
2. export TF_VAR_aws_skey=*KEYVALUE*
3. cd app
4. terraform init
5. terraform plan -out app.tfplan
6. terraform apply "app.tfplan"
7. Visit the web address of the load balancer. You should see it at the end of the terraform apply output in your terminal. 
8. terraform destroy

