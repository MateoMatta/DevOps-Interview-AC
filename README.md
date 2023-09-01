# DevOps-Interview-AC
This repository serves as answer of the challenge proposed on the interview.

It has been created a basic web site that serves of example to be deployed, in order to implement and show the use of Hashicorp Terraform as Infrastructure as a Code tool and other tools.
All of this was deployed on
- AWS as Cloud Platform
- GitHub Actions as CI/CD, to run serverless and robust pipelines
- S3 as TFSTATE files repository with versionining
- Personalized configuration of Dockerfile to run Apache as web server
- Modified configurations for Apache, to show as a particular web page and not a default page
- Ansible as Configuration Management tool to construct the base Docker image for the webserver from scratch. Particularly this works in a "masterless" way. Every EC2 machine runs by itself some .yaml playbooks.
- Some Linux/bash scripts to handle some configurations, API calls to AWS and tests to check .NetCore and Java provisioning
- To establish connection from the Docker containers (inside EC2 instances), it's possible to have a Security Group resource *[aws_security_group]*. This, in order to allow private connection from the subnet inside the VPC that contains EC2 machines with Docker containers running, to access the RDS MySQL database created. The next example shows net configurations to perform this.

   ```ingress {```

     ```from_port       = 3306```

    ```to_port         = 3306```

     ```protocol        = "tcp"```

     ```cidr_blocks = ["172.xxx.xxx.xxx/32"]```

   ```}```

   ```egress {```

     ```from_port   = 0```

     ```to_port     = 0```

     ```protocol    = "-1"```

     ```cidr_blocks = ["0.0.0.0/0"]```

   ```}```
   
 ```}```

- The solution has been configured with a new VPC, Subnet, Internet gateway, Route table, Security Group, LoadBalancer, MySQL RDS database, Autoscaling Group of 2 EC2 instances, ECR for Docker images registry service, S3 storage solution and a personalized Launch Configuration with a bash script that configures the web server.

CICD worfklow allows to check too if the container is built correctly; by pulling, running, go to a localhost:80 internally seeing the response of the web and (later) deleting the base image.
  - This step can be excluded of the workflow
  


### Prerequisites
- *Secrets configured in GitHub Actions: AWS_ACCESS_KEY_ID, AWS_ACCOUNT_ID, AWS_ACCOUNT_ID, PEM_CANDIDATE_KEY (.pem key to access through SSH to EC2 instances internally )*
- *Variables configured in GitHub Actions: AWS_REGION*
- Access to GitHub repository that owns GitHub Actions workflows



### Implementation
1. Go to the GitHub project on your browser.

[https://github.com/MateoMatta/DevOps-Interview-AC.git](https://github.com/MateoMatta/DevOps-Interview-AC.git)
  
  
2. Then go to GitHub Actions page in the project.

[https://github.com/MateoMatta/DevOps-Interview-LG/actions](https://github.com/MateoMatta/DevOps-Interview-AC/actions)
  
  
3. Select one of the Workflows on the left side of the page. In this case, to deploy the infrastructure select "CICD".
   * Note: particularly this project is executed manually, but it can be configured in the Workflow template to be activated if there's a trigger of "pull request" or another one if it's needed.
5. Then push the button "Run workflow"
6. Select now the actual workflow run (the one that has a yellow moving icon)
7. Select the first step of the workflow. You can view in real time how the pipelne is being executed.
8. Wait until all of the steps get done and show a green dot on the left.



### Notes

  * When the whole pipeline ends, wait from 30 to 90 seconds for the health check recognizes the the EC2 pool is OK and work properly.
  * Once the process is completed, Workflow console will show the output of the LoadBalancer's DNS. Look at the end of the "Terraform apply" step, inside "Terraform plan of infrastructure" for the value "lb_url".
  * Don't worry if there is an error in "Terraform State" step, it will be ignored as expected. It happens when the infrastructure doesn't exist initially when the workflow is executed. The error says:

  ```Error: Invalid target address```
```│ ```
```│ No matching objects found. To view the available instances, use "terraform```
```│ state list". Please modify the address to reference a specific instance.```
  


### Wipe
Finally, once you're done seeing the result, delete the whole infrastructure built.
1. Go back to GitHub Actions page in the project as in step 2. of Implementation.
   
[https://github.com/MateoMatta/DevOps-Interview-LG/actions](https://github.com/MateoMatta/DevOps-Interview-AC/actions)

3. Select TERRAFORM-DESTROY workflow on the left side of the page.
4. Then push the button "Run workflow"
5. Select now the actual workflow run (the one that has a yellow moving icon)
6. Select the first step of the workflow. You can view in real time how the pipelne is being executed.
7. Wait until all of the steps get done and show a green dot on the left.

*  If you want to make sure everything is wiped out, re-run the workflow.



### Notes

  * Don't worry if there is an error in "Terraform State" step, it will be ignored as expected. It happens when the infrastructure doesn't exist initially when the workflow is executed. The error says:

  ```| Error: Invalid target address```
  ```│ ```
  ```│ No matching objects found. To view the available instances, use "terraform```
  ```│ state list". Please modify the address to reference a specific instance.```
  


### Test for .NetCore compilation

1. Login on any EC2 machine of the Autoscaling Group pool by typing:

```ssh -i "candidate.pem" ubuntu@<PUBLIC_IP>```

- Then, type "yes" with your keyboard, and press Enter button.

```yes```

2. Now, execute the next script made with Bash to show that you can compile a .NetCore application.

```sh /srv/app/Infrastructure/scripts/netCoreCompilationTest.sh```



### Test for Java compilation

1. Login on any EC2 machine of the Autoscaling Group pool by typing:

```ssh -i "candidate.pem" ubuntu@<PUBLIC_IP>```

- Then, type "yes" with your keyboard, and press Enter button.

```yes```

2. Now, execute the next script made with Bash to show that you can compile a Java application.

```sh /srv/app/Infrastructure/scripts/javaCompilationTest.sh```



### VS Code provisioning

* You can check if Visual Studio is installed, by prompting in the CLI on any linux EC2 machine:

```code --version```



### Citation
All the code rights to the developers mentioned below.

    @development{Demo,
        author    = Mateo Matta}, 
        title     = {DevOps interview demo}
    }

