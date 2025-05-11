pipeline {
  agent any
  environment {
    COMPOSE = "/usr/local/bin/docker-compose"
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/daviddvf/proyectoLenMPro1.git', credentialsId: 'git-token', branch: 'main'
      }
    }
    stage('Build & Up') {
      steps {
        sh "${COMPOSE} build"
        sh "${COMPOSE} up -d db"      // levanta DB primero
        sh "${COMPOSE} up -d app"     // levanta App
      }
    }
    stage('Migrations & Tests') {
      steps {
        // Corre tests dentro del contenedor de app
        sh "${COMPOSE} exec app python manage.py test"
      }
    }
    stage('Smoke Test') {
      steps {
        sh 'curl -f http://localhost:8000/ || exit 1'
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: '**/app/**/*.py', fingerprint: true
      cleanWs()
    }
  }
}
