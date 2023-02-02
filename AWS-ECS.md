# AWS ECR


# couldn't find image, now


# https://aws.amazon.com/getting-started/hands-on/deploy-docker-containers/


# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Pre-requisite for accessing private application on Fargate with a load balancer


# LDAP=Lightweight Directory Access Protocol
# Phone book for services etc
<!-- The Lightweight Directory Access Protocol (LDAP /ˈɛldæp/) is an open, vendor-neutral, industry standard application protocol for accessing and maintaining distributed directory information services over an Internet Protocol (IP) network. -->


<!-- subnet-060b7c1dd68c05e6b
(10.0.0.0/24) | ECS jjupyter-analytics-app-host - Public Subnet 1 - us-west-1b
assign ipv6 on creation: Disabled -->


# 1/23
# Loosely following : https://krishna-thotakura.medium.com/deploy-on-ecs-fargate-a-docker-container-that-exposes-multiple-ports-5c00035558e3


Load balancer VPC

# Load balancer name: jjupyter-load-balancer2
# vpc-0c57789e1d918bd0e
# DNS: jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com
# Listeners: ports 80, 8888, forward to notebook-server-target-group

# Routing
# notebook-server-target-group
target type : IP
Protocol : HTTP
Port : 8888 

Register Targets <left blank for now. Will register when creating ECS service>
Successfully created load balancer

# Create cluster 
# jjupyter-cluster2 

# Create service
Launch type: FARGATE
task def jjupyter-notebook (revision 2)
jjupyter-notebook-service
Replica
Number of tasks : 1 

# Configure Network
Cluster VPC : vpc-0c57789e1d918bd0e
Subnets: 
    subnet-0ae93e7772e9aa347
    (10.0.1.0/24) | jjupyter-cluster2/Public - us-west-1c
    assign ipv6 on creation: Disabled

# Security groups > Edit
Select existing>
jjupyter2-load-balancer-sec-group / sg-066d79add9b7261b7
port 8888 my IP
port 80 my IP
> Should also include access to the application security group ip range on the VPC, as per 
https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html

Service security group will also need to access the security group that the load balancer is on (for listening/responding), but should be different, so as not to allow external traffic.

# Load balancing 
Application Load Balancer
Load balancer name: jjupyter-load-balancer2
<!-- container name:port  -->
Container to load balance
jjupyter:8888:8888
Add to load balancer> 
(immutable) Production listener port* : create new
(immutable) Production listener protocol* : HTTP
target group name : notebook-server-target-group

# Need to configure health check
Path is the path that is sent to the machine to check to make sure the machine is still running
Ideally, would set to a specific path for 200 response (but not the usual service path)
For Jupyter I set to /, so that if the notebook was running, it would return 200
Interval specifies how often the target group pings each server to check if it's alive

Next>

Do not adjust auto-scaling 

Review> Create service

View Service> Wait for task to start running successfully
Task status RUNNING
view task, view log, shows 
Jupyter Notebook 6.5.2 is running at:
http://127.0.0.1:8888
etc

trying 
jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com
503
jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com:8888
503
jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com:80
503

Change port 80 to return fixed response: You reached the load balancer now 
jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com:80 returns static response

# Now look at service and task has stopped! 
# Error in service/ task:  https://us-west-1.console.aws.amazon.com/ecs/home?region=us-west-1#/clusters/jjupyter-cluster2/tasks/77bad04de91547109dd6a9fe8a1c7e67/details
Task failed ELB health checks in (target-group arn:aws:elasticloadbalancing:us-west-1:696154665063:targetgroup/notebook-server-target-group/fd7bf25af14a44ae)

Service restarted new task
RUNNING
Now, go to jjupyter-load-balancer2-1035098532.us-west-1.elb.amazonaws.com:8888
Gateway timeout
Keep refreshing and task failed ELB health check - which suggests that the request is getting sent before it fails

Updating service. Adding 60s grace period 
Wait for task to get up and running with new grace period 
Same 504 gateway response 
Still failed health check - fixed see above 
So notebook is no longer crashing upon health check

Helpful article from Kunal
https://aws.amazon.com/premiumsupport/knowledge-center/504-error-alb/

 Resolution
Check your load balancers idle timeout and modify if necessary

Load balancer HTTP 504 errors can occur if the backend instance didn't respond to the request within the configured idle timeout period. By default, the idle timeout for Application Load Balancer is 60 seconds.

If CloudWatch metrics are enabled, check CloudWatch metrics for your Application Load Balancer. The HTTPCode_ELB_5XX metric indicates the 504 error originated from the load balancer. 
Yes - I see points here - suggesting issue is coming from Load Balancer

Updated load balancer security group/ACL setting to allow port 8888 for our security group which shows up in the drop-down dynamically

Health check killed my application as it was checking port 8888 which was already in use. Need to set something up so that it responds on another port.
