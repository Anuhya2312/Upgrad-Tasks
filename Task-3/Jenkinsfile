pipeline {
    agent any

    environment {
        IMAGE_NAME = 'anuhya23/vote'
        IMAGE_TAG = 'v23'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Anuhya2312/hello-world-repo.git', branch: 'main'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $IMAGE_NAME:$IMAGE_TAG .
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }
}
