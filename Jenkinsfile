pipeline {
    agent {
        kubernetes {
            // Define the label used to select a Kubernetes node to run the job
            label 'minikube'
        }
    }
    environment {
        GO_VERSION = "1.18.1"  // Update with your desired Go version
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh "curl -O -L https://golang.org/dl/go1.18.1.linux-amd64.tar.gz | tar -C /usr/local -xz"
                sh 'export PATH=$PATH:/usr/local/go/bin'
                sh 'go version'
		sh 'go get github.com/gorilla/mux'
                sh 'go build -o go-sample-app'
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
