pipeline {
   agent any
     stages {
       stage('Build') {
           agent any
           steps {
                   //sh 'echo "af007f6b3b8945f595a61e637bcf5746" | sudo -S mkdir /usr/src/app'
                   sh 'cp -r src /usr/src/app/'
                   sh 'cp  pom.xml /usr/src/app/'
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
