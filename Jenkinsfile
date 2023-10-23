pipeline {
    agent {
        kubernetes {
          // Define the label used to select a Kubernetes node to run the j>
          yaml """
    apiVersion: v1
    kind: Pod
    metadata:
      name: jenkins-slave
      namespace: jenkins
      labels:
        jenkins/jenkins-jenkins-agent: "true"
        jenkins/label: minikube
        jenkins/label-digest: 66b07b5ce1ea579c2cd5e4d8525406b9c75380c2
    spec:
      containers:
        - name: jnlp
          image: jenkins/jnlp-slave:latest
          securityContext:
            privileged: true
            runAsUser: 0
            fsGroup: 0
          tty: true
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
      nodeSelector:
        kubernetes.io/os: linux
    """
        }
    }

    environment {
        GO_VERSION = "1.18.1"  // Update with your desired Go version
        GOPATH = '/var/jenkins_home/go'
    }

    stages {
        stage('Install Go') {
            steps {
                script {
                    sh "sleep 100"
                    sh "mkdir -p $GOPATH"
                    sh "curl -O -L https://golang.org/dl/go1.18.1.linux-amd64.tar.gz"
                    sh "tar -xvf go1.18.1.linux-amd64.tar.gz -C $GOPATH"
                    sh "export PATH=$GOPATH/go/bin:$PATH"
                }
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'go version'
                sh 'go get github.com/gorilla/mux'
                sh 'go build -o go-sample-app'
                sh './go-sample-app'
            }
        }

        stage('Test') {
            steps {
                sh 'go test ./...'
            }
        }

        stage('Push') {
            steps {
                script {
                    def image = docker.build("go-sample-app:${env.BUILD_NUMBER}")
                    image.inside {
                        sh 'cp golang-sample-app /app/golang-sample-app'
                    }
                    image.push()
                }
            }
        }

        stage('Deployment') {
            steps {
                sh 'kubectl apply -f deployment.yaml'  // Deploy your Kubernetes manifest
            }
        }
    }

    post {
        success {
            echo 'success'
        }
        always {
            echo 'tested'
        }
    }
}
