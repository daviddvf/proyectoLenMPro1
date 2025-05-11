pipeline {
  agent any
  environment {
    TAG = "${env.BUILD_NUMBER}"
    DOCKER_REGISTRY = "daviddvf/proyectolenmpro"
  }
  options { timeout(time: 30, unit: 'MINUTES') }

  stages {
    stage('Checkout') {
      steps {
        git(
          url: 'https://github.com/daviddvf/proyectoLenMPro1.git',
          credentialsId: 'git-token',
          branch: 'main'
        )
      }
    }

    stage('Install & Test') {
      steps {
        sh 'pip install -r app/requirements.txt'
        sh 'pytest app --junitxml=results.xml || true'
      }
      post {
        always {
          junit 'results.xml'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_REGISTRY}:${TAG} ./app"
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'docker-token',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin'
          sh "docker push ${DOCKER_REGISTRY}:${TAG}"
        }
      }
    }

    stage('Build & Up') {
      steps {
        sh 'docker-compose build'
        sh 'docker-compose up -d'
      }
    }
  }

  post {
    success { echo '✅ Pipeline OK.' }
    failure { echo '❌ Pipeline falló.' }
  }
}
