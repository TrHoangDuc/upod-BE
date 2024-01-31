pipeline{
  agent any

  stages{
    stage('Cleanup'){
      steps {
        script {
          previousBuildNumber = currentBuild.number -1
          containerID = sh(returnStdout: true, script: "docker ps -a -q --filter ancestor=trhoangduc/deploy_be:${previousBuildNumber}.0")
          if(containerID != ""){
            sh "docker stop ${containerID}"
          }
        }
      }
    }

    stage('Checkout code'){
      steps {
        git branch: 'main', url: 'https://github.com/TrHoangDuc/upod-BE.git'
      }
    }

    stage('Build Docker image'){
      steps {
        script {
          def dockerfilePath = "./UPOD.API/Dockerfile"
          dockerImage = docker.build("trhoangduc/deploy_be:${BUILD_NUMBER}.0")
        }
      }
    }

    stage('Push Docker image to registry'){
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'DockerHub') {
            dockerImage.push()
          }
        }
      }
    }

    stage('Run Docker image'){
      steps {
        script {
           containerID = sh(returnStdout: true, script: "docker run -d -p 5173:5173 trhoangduc/deploy_be:${BUILD_NUMBER}.0")
           echo "Container ID: ${containerID}" 
        }
      }
    }
  }

}