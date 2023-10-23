pipeline {
    agent {
        kubernetes {
          // Define the label used to select a Kubernetes node to run the job
          yaml """
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        app: jenkins-slave
    spec:
      containers:
        - name: jnlp
          image: jenkins/jnlp-slave:latest
          securityContext:
            privileged: true
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
