pipeline {
    agent any

    environment {
        // 1. Updated to your Docker Hub username
        DOCKER_USER = "keerthanabm"
        
        // 2. This must match the ID you created in Jenkins Credentials (Manage Jenkins > Credentials)
        REGISTRY_CREDENTIALS = 'docker-hub-creds'
        
        // 3. Updated to your own project names
        IMAGE_NAME = "my-python-app"
        CONTAINER_NAME = "keerthana-container"
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
                // Using DOCKER_BUILDKIT=0 to avoid the buildx metadata error we saw earlier
                sh "DOCKER_BUILDKIT=0 docker build -t ${DOCKER_USER}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Running Python Syntax Check...'
                // This assumes you have a file named app.py in your GitHub repo
                sh "python3 -m py_compile app.py"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // This logs into Docker Hub using your Jenkins credentials
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
                // Stop and remove the old container so the new one can use the same port
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${DOCKER_USER}/${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            echo '✅ Success! Your image is on Docker Hub and running locally at http://localhost:5000'
        }
        failure {
            echo '❌ Pipeline Failed. Check the Console Output for login errors or missing files.'
        }
    }
}
