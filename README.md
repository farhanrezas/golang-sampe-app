# golang-sampe-app
This is only an example of the Golang App. 
No integrated DB or API from this app.

For the deployment of this app, we use:
- K8s cluster using Minikube
- Jenkins 2.414.2 that deployed under the Minikube

This app totally built using Golang. For the Jenkins deployment, we used helm with the updated Jenkins chart.
We also build and test using a built-in approach from Golang, that's go build and go test.
Then store it in the local registry.
At the final stage, it will implement the deployment.yaml to deploy in the Minikube cluster.
