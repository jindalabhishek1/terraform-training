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


### Day 17:

---

#### Learnings

* How to upload an object
* If you change the content of the object, and the "etag" argument is not set, terraform will see no changes
    * To do so, we need to add "etag" attribute, which checks the integrity of the file by calculating MD5 hash of the file 
        and matching it with the etag calculated by AWS in the backend.
* How to upload a folder
    * Use "for_each" function and "fileset" function
    ```json
        resource "aws_s3_object" "test_object" {
            for_each  = fileset("./test_folder/", "**")
            bucket = aws_s3_bucket.test_bucket.bucket
            key    = "/test_folder/${each.value}" # destination file name
            source = "./test_folder/${each.value}"  # source file path
            etag   = filemd5("./test_folder/${each.value}") # calculating MD5 hash of the file locally and match that with etag in AWS side.
        }
    ```
    * Empty folders will not be uploaded, because fileset function only gets files
    * "**" helps in identifying the files in sub directory using "fileset" function
 
    
### Day 19:

---

#### Learnings

* We can use "aws_s3_bucket_website_configuration" terraform resource for configuring static website
* AWS by default puts "Content-Type: application/octet-stream" which will tell browser that it is a binary file so it will download the file
  instead of displaying the content in browser
    * To solve this use ``content_type = "text/html"`` while uploading the object from terraform

#### Tasks

* Create a s3 bucket with read object permission with bucket policy
* Create a bucket with static website hosting