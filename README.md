## NOTES

### Day 03:

---

#### Tasks

* Create a simple web server


### Day 04:

---

#### Learnings

* terraform graph
    * Creates a dependency graph in graph language [dot](https://graphviz.org/doc/info/lang.html)
    * [Learn Dot language](https://www.ocf.berkeley.edu/~eek/index.html/tiny_examples/thinktank/src/gv1.7c/doc/dotguide.pdf)

#### Tasks

* Create the security groups without egress rules, and try to troubleshoot
* 


### Day 14:

---

#### Learnings

* Terraform Datasource
    * Used to get information from the provider
    * Kind on API to fetch the 
    * Example:
    ```json
        data "aws_instance" "my-web-app" {
            instance_id = aws_instance.web-app[0].id
        }
    ```
    * Documentation for data source under each service in provider documentation


### Day 15:

---

#### Mid training Assignment

##### Pre-requisite

1. should have 3 environments (dev, stage and prod)
2. maintain proper directory structure for isolation using file layout
3. shoud have different backend folder structure for each enviornment
4. create ALB along in front of asg
5. you must pass user data script using file function to install web server
6. ASG should have scaling policy and scaling scedule
7. ALB must have custom health check
8. tfvars according to diff enviornment (hint: instance type or other)
9. must use variables
10. must have output
11. asg and alb must have custom sg
12. create one more environment called test from dev environment using workspace isolation