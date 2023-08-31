pipeline{
    
    agent any 
    tools { 
        maven 'Maven 3.9.4'
        jdk 'jdk8' 
    }
    stages {
        stage ('Initialize') {
            steps {
                sh 
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                
            }
        }
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
    }                
}
