
pipeline{
    
    agent any 
     environment {
        NEXUS_URL = 'http://172.18.0.4:8081/repository/demoapp-docker/zamkeita'
        DOCKER_CREDENTIALS = credentials('nexus_hub_cred')
        DOCKER_IMAGE_NAME = 'docker-app-demo'
        DOCKER_IMAGE_TAG = "$JOB_NAME:v1.$BUILD_ID"
    }
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/zamkeita/App-Demo.git'
                }
            }
        }
        stage('UNIT Testing'){

            steps{

                script{

                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){

            steps{

                script{

                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }   
        
        stage('Quality Gate Status'){
                
            steps{
                    
                script{
                        
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                   }
                }
            }
        stage('upload war file to nexus'){
            steps{
                script{
                   def readPomVersion = readMavenPom file: 'pom.xml'
                   def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "Demoapp-snapshot" : "Demoapp-release"
                   nexusArtifactUploader artifacts: 
                   [
                      [
                          artifactId: 'springboot',
                          classifier: '', file: 'target/Uber.jar', 
                          type: 'jar'
                         ]
                       ], 
                   credentialsId: 'nexus-auth', 
                   groupId: 'com.example', 
                   nexusUrl: '172.18.0.4:8081', 
                   nexusVersion: 'nexus3', 
                   protocol: 'http', 
                   repository: nexusRepo, 
                   version: "${readPomVersion.version}"
             }        
         }
      } 
         stage('Docker image build'){

             steps{

                 script{

                     sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                     sh 'docker image tag $JOB_NAME:v1.$BUILD_ID zamkeita/$JOB_NAME:v1.$BUILD_ID'
                     sh 'docker image tag $JOB_NAME:v1.$BUILD_ID zamkeita/$JOB_NAME:latest'                
                   }
                }
            }
         stage('Docker image to nexus'){

             steps{

                 script{

                     withCredentials([string(credentialsId: DOCKER_CREDENTIALS, variable: 'DOCKER_CREDS')]) {
                        // Construire l'image Docker (si nécessaire)
                        sh "docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG ."

                        // Se connecter au registre Nexus Docker
                        sh "docker login -u admin -p $DOCKER_CREDS $NEXUS_URL"

                        // Poussez l'image vers Nexus
                        sh "docker push $NEXUS_URL/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"
                     }
                   }
                }
            }

    
    }             

}
