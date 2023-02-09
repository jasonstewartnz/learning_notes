

# https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-interactive/
# runing on interactive terminal - so have not installed locally 
minikube version

minikube start

# Great! You now have a running Kubernetes cluster in your online terminal. Minikube started a virtual machine for you, and a Kubernetes cluster is now running in that VM.
# command line interface, kubectl

# view cluster info
kubectl cluster-info

# to view nodes 
kubectl get nodes

# NAME       STATUS   ROLES                  AGE     VERSION
# minikube   Ready    control-plane,master   9m48s   v1.20.2

# https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/
# Once you have a running Kubernetes cluster, you can deploy your containerized applications on top of it. 
# To do so, you create a Kubernetes Deployment configuration.
# the Kubernetes control plane schedules the application instances included in that Deployment to run on individual Nodes in the cluster.
# When you create a Deployment, you'll need to specify the container image for your application and the number of replicas that you want to run.
# you can change that later 

# https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-interactive/
# A Pod is the basic execution unit of a Kubernetes application. Each Pod represents a part of a workload that is running on your cluster. Learn more about Pods.

# The common format of a kubectl command is: kubectl action resource.

kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
# > deployment kubernetes-bootcamp created
kubernetes get deployments

# The proxy can be terminated by pressing control-C and won't show any output while its running. 
echo -e "\n\n\n\e[92mStarting Proxy. After starting it will not output a response. Please click the first Terminal Tab\n"; 
kubectl proxy

# You can see all those APIs hosted through the proxy endpoint. For example, we can query the version directly through the API using the curl command:
curl http://localhost:8001/version

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# Troubleshooting with kubectl
    # kubectl get - list resources
    # kubectl describe - show detailed information about a resource
    # kubectl logs - print the logs from a container in a pod
    # kubectl exec - execute a command on a container in a pod


kubectl get pods
kubectl describe pods

# Pods are running in an isolated, private network - 
# so we need to proxy access to them so we can debug and interact with them. 
# To do this, we'll use the kubectl proxy command to run a proxy in a second terminal window
echo -e "\n\n\n\e[92mStarting Proxy. After starting it will not output a response. Please click the first Terminal Tab\n"; kubectl proxy

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# 
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
# > Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-fb5c67579-wqjr5 | v=1

# for locally hosted, I should be able to paste into browser

kubectl logs $POD_NAME

#We can execute commands directly on the container once the Pod is up and running. For this, we use the exec command and use the name of the Pod as a parameter. Let’s list the environment variables:
kubectl exec $POD_NAME -- env
# list files in root
kubectl exec $POD_NAME -- ls -lAF
# start bash session
kubectl exec -ti $POD_NAME -- bash

# Services
# Although each Pod has a unique IP address, those IPs are not exposed outside the cluster without a Service.
kubectl get services

kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

# Create an environment variable called NODE_PORT that has the value of the Node port assigned:
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

curl $(minikube ip):$NODE_PORT
kubectl describe deployment

# Let’s use this label to query our list of Pods. We’ll use the kubectl get pods command with -l as a parameter, followed by the label values:
kubectl get pods -l app=kubernetes-bootcamp
# get pod name
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME
# to apply a new label
kubectl label pods $POD_NAME version=v1

kubectl delete service -l app=kubernetes-bootcamp

# Next, let’s scale the Deployment to 4 replicas. We’ll use the kubectl scale command, followed by the deployment type, name and desired number of instances:
kubectl scale deployments/kubernetes-bootcamp --replicas=4

## Contents of server.js on getting started node
# var http = require('http');
# var requests=0;
# var podname= process.env.HOSTNAME;
# var startTime;
# var host;
# var handleRequest = function(request, response) {
#   response.setHeader('Content-Type', 'text/plain');
#   response.writeHead(200);
#   response.write("Hello Kubernetes bootcamp! | Running on: ");
#   response.write(host);
#   response.end(" | v=1\n");
#   console.log("Running On:" ,host, "| Total Requests:", ++requests,"| App Uptime:", (new Date() - startTime)/1000 , "seconds", "| Log Time:",new Date());
# }
# var www = http.createServer(handleRequest);
# www.listen(8080,function () {
#     startTime = new Date();;
#     host = process.env.HOSTNAME;
#     console.log ("Kubernetes Bootcamp App Started At:",startTime, "| Running On: " ,host, "\n" );
# });