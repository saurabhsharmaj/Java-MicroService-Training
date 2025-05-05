pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-agent
spec:
  containers:
    - name: jnlp
      image: jenkins/inbound-agent:latest
      args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
      volumeMounts:
        - name: docker-socket
          mountPath: /var/run/docker.sock
  volumes:
    - name: docker-socket
      hostPath:
        path: /var/run/docker.sock
        type: Socket
"""
        }
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        SONAR_HOST_URL = 'http://192.168.33.142:31000'  // Your SonarQube NodePort service
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/rajdeepsingh642/micro-service.git'
            }
        }

        stage('File System Scan') {
            steps {
                sh '''
                    apk add --no-cache curl unzip
                    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
                    mv trivy /usr/local/bin/
                    trivy fs --format table -o trivy-fs-report.html .
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonar') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=micro-service \
                        -Dsonar.projectKey=micro-service \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.java.binaries=.
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: true, credentialsId: 'sonar-token'
            }
        }

        stage('Build Docker Image and Tag') {
            steps {
                script {
                    sh "docker build -t rajdeepsingh642/micro-service:latest ."
                }
            }
        }

        stage('Docker Image Scan') {
            steps {
                sh '''
                    trivy image --format table -o trivy-image-report.html rajdeepsingh642/micro-service:latest
                '''
            }
        }

        stage('Docker Image Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push rajdeepsingh642/micro-service:latest
                        '''
                    }
                }
            }
        }
    }
}
