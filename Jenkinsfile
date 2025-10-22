pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Aditya-T3/python-devops-sample.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("calculator-app")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image("calculator-app").inside {
                        sh 'pytest -v --junitxml=results.xml'
                    }
                }
            }
        }
    }

    post {
        always {
            junit 'results.xml'
        }
        success {
            echo '✅ Build and tests completed successfully!'
        }
        failure {
            echo '❌ Build or tests failed. Check the test results for details.'
        }
    }
}
