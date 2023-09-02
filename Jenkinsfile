pipeline{
    
    agent any 
    
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
                   nexusUrl: 'http://172.18.0.5:8081', 
                   nexusVersion: 'nexus2', 
                   protocol: 'http', 
                   repository: 'Demoapp-release', 
                   version: '1.0.0'
             }        
         }
      } 
    
    }             

}
