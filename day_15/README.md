## Mid training Assignment

### Pre-requisite

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