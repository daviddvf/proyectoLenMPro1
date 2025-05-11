pipeline {
  agent any

  environment {
    // Apunta a la CLI de Compose v2 ya incluida en Docker
    COMPOSE = "docker compose"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/daviddvf/proyectoLenMPro1.git',
            credentialsId: 'git-token',
            branch: 'main'
      }
    }

    stage('Build & Up') {
      steps {
        // Ahora COMPOSE="docker compose"
        sh "${COMPOSE} build"
        sh "${COMPOSE} down --volumes --remove-orphans || true"
        sh "${COMPOSE} up -d db"
        sh "${COMPOSE} up -d app"
      }
    }

    stage('Migrations & Tests') {
      steps {
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
      // Limpia workspace con deleteDir() que ya está disponible
      deleteDir()
    }
  }
}