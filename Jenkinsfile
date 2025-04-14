pipeline {
  agent any
  environment {
    DOCKER_HUB_REPO = 'salim2025'
    // Credential Jenkins pour Docker Hub déjà configuré
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
          // Construction et push de l'image movie-service
          dir('movie-service') {
            def imageName = "${env.DOCKER_HUB_REPO}/movie-service:latest"
            sh "docker build -t ${imageName} ."
            sh "docker login -u ${env.DOCKER_HUB_REPO} -p ${DOCKER_HUB_CRED}"
            sh "docker push ${imageName}"
          }
          // Construction et push de l'image cast-service
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
        withCredentials([file(credentialsId: 'config', variable: 'KUBECONFIG')]) {
          sh "kubectl cluster-info"  // Vérification de l'accès au cluster
          sh "helm upgrade --install jenkins-devops-exams ./charts --namespace dev --create-namespace --set environment=dev"
        }
      }
    }
    stage('Deploy to QA') {
      steps {
        withCredentials([file(credentialsId: 'config', variable: 'KUBECONFIG')]) {
          sh "helm upgrade --install jenkins-devops-exams ./charts --namespace qa --create-namespace --set environment=qa"
        }
      }
    }
    stage('Deploy to Staging') {
      steps {
        withCredentials([file(credentialsId: 'config', variable: 'KUBECONFIG')]) {
          sh "helm upgrade --install jenkins-devops-exams ./charts --namespace staging --create-namespace --set environment=staging"
        }
      }
    }
    stage('Deploy to Prod') {
      steps {
        // Stage PROD en mode manuel
        input message: 'Confirmez le déploiement en PROD', ok: 'Deploy'
        withCredentials([file(credentialsId: 'config', variable: 'KUBECONFIG')]) {
          sh "helm upgrade --install jenkins-devops-exams ./charts --namespace prod --create-namespace --set environment=prod"
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
