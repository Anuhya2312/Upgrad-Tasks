pipeline {
  agent any

  stages {
    stage('Deploy to App EC2') {
      steps {
        sshagent(credentials: ['app-ssh-key']) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@10.10.2.90 '
              set -ex
              if [ ! -d ~/hello-world-repo ]; then
                git clone https://github.com/Anuhya2312/hello-world-repo.git ~/hello-world-repo
              fi
              cd ~/hello-world-repo
              git reset --hard
              git clean -fd
              git pull
              docker stop hello-container || true
              docker rm hello-container || true
              docker build -t hello-world-git .
              docker run -d -p 5000:5000 --name hello-container hello-world-git
            '
          """
        }
      }
    }
  }
}
