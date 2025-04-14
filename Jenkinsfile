pipeline {
  agent any
  environment {
    DOCKER_HUB_REPO = 'salim2025'
    // Credential Jenkins préconfiguré pour Docker Hub
    DOCKER_HUB_CRED = credentials('DOCKER_HUB_PASS')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build & Push Docker Images (DEV)') {
      steps {
        script {
          // Construction et push de movie-service
          dir('movie-service') {
            def imageName = "${env.DOCKER_HUB_REPO}/movie-service:latest"
            sh "docker build -t ${imageName} ."
            sh "docker login -u ${env.DOCKER_HUB_REPO} -p ${DOCKER_HUB_CRED}"
            sh "docker push ${imageName}"
          }
          // Construction et push de cast-service
          dir('cast-service') {
            def imageName = "${env.DOCKER_HUB_REPO}/cast-service:latest"
            sh "docker build -t ${imageName} ."
            sh "docker login -u ${env.DOCKER_HUB_REPO} -p ${DOCKER_HUB_CRED}"
            sh "docker push ${imageName}"
          }
        }
      }
    }
    stage('Deploy to Dev') {
      steps {
        // Déploiement dans le namespace "dev" en utilisant Helm
        sh "helm upgrade --install jenkins-devops-exams ./charts --namespace dev --create-namespace --set environment=dev"
      }
    }
    stage('Deploy to QA') {
      steps {
        sh "helm upgrade --install jenkins-devops-exams ./charts --namespace qa --create-namespace --set environment=qa"
      }
    }
    stage('Deploy to Staging') {
      steps {
        sh "helm upgrade --install jenkins-devops-exams ./charts --namespace staging --create-namespace --set environment=staging"
      }
    }
    stage('Deploy to Prod') {
      steps {
        // Attente d'une confirmation manuelle pour déclencher le déploiement en production
        input message: 'Confirmez le déploiement en PROD', ok: 'Deploy'
        sh "helm upgrade --install jenkins-devops-exams ./charts --namespace prod --create-namespace --set environment=prod"
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
