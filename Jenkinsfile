pipeline {
    agent any
     stages {
       stage('Build') {
           agent any
           steps {
                   sh 'sh "sudo chown root:jenkins /run/docker.sock"'
                   sh 'mkdir -p /usr/src/app'
                   sh 'mkdir -p /usr/src/app/src'
                   sh 'cp -Rp src /usr/src/app/'
                   sh 'cp -Rp pom.xml /usr/src/app/'
                   sh 'mvn -f /usr/src/app/pom.xml clean package'
                   sh 'docker build .'
                      }
       }
      
       stage('Publish') {
           environment {
               registryCredential = 'dockerhub'
           }
           steps{
               script {
                   def appimage = docker.build registry + ":$BUILD_NUMBER"
                   docker.withRegistry( '', registryCredential ) {
                       appimage.push()
                       appimage.push('latest')
                   }
               }
           }
       }
       stage ('Deploy') {
           steps {
               script{
                   def image_id = registry + ":$BUILD_NUMBER"
                   sh "ansible-playbook  playbook.yml --extra-vars \"image_id=${image_id}\""
               }
           }
       }
   }
}

