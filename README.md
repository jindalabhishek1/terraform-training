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