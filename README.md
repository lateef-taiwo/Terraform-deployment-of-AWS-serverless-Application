# Terraform-deployment-of-AWS-serverless-Application
This repository is for the creation of AWS serverless application using Terraform and AWS serverless services such as Lambda, API Gateway, DynamoDB, Amazon Cognito, CodeCommit, Amplify, Route53, IAM,S3. 

## This Project is a Multi-repo project with Terraform code in this repository and the App code is in the repository below:
  https://github.com/lateef-taiwo/Wild-Rydes
    
    
![image](./images/Architectural%20Diagram%20Week8.jpg)


### Deploying  the serverless services using terraform.

      terrform init
      terraform plan
      terraform apply -auto-approve


### Deploying the Application
Navigate to the app code repository,
https://github.com/lateef-taiwo/Wild-Rydes

Modify the index.html file or any other front end files convenient for you to make changes to.
 
      git add .
      git commit -m "commit message"
      git push 