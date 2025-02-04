pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '30'))
  }

  agent {
    label 'nodejs'
  }

  environment {
    DESTINATION = "ghcr.io/msamec/msamec/showcase:${GIT_COMMIT}"
  }

  stages {
    stage('Install Dependencies') {
      steps {
        container('nodejs-22') {
          sh 'npm ci'
        }
      }
    }

    stage('Run test') {
      steps {
        container('nodejs-22') {
          sh 'npm run test'
        }
      }
    }

    stage('Run lint') {
      steps {
        container('nodejs-22') {
          sh 'npm run lint'
        }
      }
    }

    stage('Run formatter') {
      steps {
        container('nodejs-22') {
          catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
            sh 'npm run formatter'
          }
        }
      }
    }
  }
}
