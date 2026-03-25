pipeline {
    agent any

    environment {
        // Your Docker Hub username
        DOCKER_USER = "keerthanabm"
        
        // The ID of the credentials you created in Jenkins
        REGISTRY_CREDENTIALS = 'docker-hub-creds'
        
        // This is what the image will be called on Docker Hub
        IMAGE_NAME = "dockerprg"
        
        // The name for the container running on your local machine
        CONTAINER_NAME = "my-docker-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📥 Pulling code from GitHub...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building Docker Image...'
                // Using DOCKER_BUILDKIT=0 to avoid the error we saw in your terminal earlier
                sh "DOCKER_BUILDKIT=0 docker build -t ${DOCKER_USER}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Running Python Syntax Check...'
                // This checks your app.py for errors
                sh "python3 -m py_compile app.py"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // This logs you into Docker Hub automatically
                    docker.withRegistry('', "${REGISTRY_CREDENTIALS}") {
                        echo '📤 Pushing Image to Docker Hub...'
                        sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy Local') {
            steps {
                echo '🚀 Refreshing Local Container...'
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${DOCKER_USER}/${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            echo '✅ Success! Your image is now on Docker Hub under keerthanabm/dockerprg'
        }
        failure {
            echo '❌ Pipeline Failed. Check the Console Output in Jenkins.'
        }
    }
}
