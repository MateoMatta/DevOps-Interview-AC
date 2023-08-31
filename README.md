# DevOps-Interview-AC
This repository serves as answer of the challenge proposed on the interview.

It has been created a basic web site that serves of example to be deployed, in order to implement and show the use of Hashicorp Terraform as Infrastructure as a Code tool and other tools.
All of this was deployed on
- AWS as Cloud Platform
- GitHub Actions as CI/CD
- S3 as TFSTATE files repository (with versionining)
- Ansible as Configuration Management tool to construct the base Docker image for the webserver from scratch
- Some Linux/bash scripts to handle some configurations, API calls to AWS and tests to check .NetCore and Java provisioning
- Modified configurations for Apache, to show as a particular web page and not a default page
- 

The solution has been configured with a new VPC, Subnet, Internet gateway, Route table, Security Group, LB, Autoscaling Group of 2 EC2 instances, S3 and its proper personalized Launch configuration with a bash script that configures the web server.


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

  * When the whole pipeline ends, wait from 30 to 90 seconds for the health check recognizes the the EC2 pool is OK and work properly.
  * Once the process is completed, Workflow console will show the output of the LoadBalancer's DNS. Look at the end of the "Terraform apply" step, inside "Terraform plan of infrastructure" for the value "lb_url".

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

### Citation
All the code rights to the developers mentioned below.

    @development{Demo,
        author    = Mateo Matta}, 
        title     = {DevOps interview demo}
    }


```chmod 700 ./candidate.pem```

- Log in with SSH inside the machine.
```ssh -i "candidate.pem" ubuntu@xxx.xxx.xxx.xxx```
