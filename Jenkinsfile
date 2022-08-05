pipeline {
  agent any;

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  environment {
    CONTAINER_NAME = 'docker-mods'
    DCKR_TZ = 'America/Denver'
  }

  stages {
    stage('Setup Environment') {
      steps {
        script {
          env.EXIT_STATUS = ''

          env.CURR_DATE = sh(
            script: '''date '+%Y-%m-%d_%H:%M:%S%:z' ''',
            returnStdout: true).trim()

          env.GITHASH_SHORT = sh(
            script: '''git log -1 --format=%h''',
            returnStdout: true).trim()

          env.GITHASH_LONG = sh(
            script: '''git log -1 --format=%H''',
            returnStdout: true).trim()
        }
      }
    }
    stage('Buildx') {
      agent {
        label 'x86_64'
      }

      steps {
        echo "Running on node: ${NODE_NAME}"
        withDockerRegistry(credentialsId: 'teknofile-dockerhub', url: "https://index.docker.io/v1/") {
          sh '''
            docker buildx create --name tkf-builder-${GITHASH_SHORT} --bootstrap --use
            docker buildx build \
              --platform linux/arm64,linux/amd64 \
              -t teknofile/${CONTAINER_NAME}:${GITHASH_SHORT} \
              -t teknofile/${CONTAINER_NAME}:${GITHASH_LONG} \
              -t teknofile/${CONTAINER_NAME}:${BRANCH_NAME} \
              . \
              --push
            docker buildx rm -f tkf-builder-${GITHASH_SHORT}
          '''
        }
      }
    }
  }
  post {
    always {
      node(null) {
        echo 'Cleaning up.'
        deleteDir() /* clean up our workspace */
        cleanWs()
      }
    }
  }
}
