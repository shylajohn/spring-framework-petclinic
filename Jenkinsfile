pipeline{       
  agent any
  stages {
     
      stage('test -') {
            steps {
                sh 'pwd'
                sh 'whoami'
            }
        }
       stage('Build') {
          
           steps {
                
                   sh 'pwd'
                   //sh 'cd /usr/src/'
                   //sh 'pwd'
                   //sh 'mkdir -p /usr/src/app/'
                   
                   //sh 'cp -r $WORKSPACE /usr/src/app/'
                   //sh 'cp -r pom.xml /usr/src/app/'
                   sh 'mvn -f pom.xml clean package'
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

