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
                sh 'docker build -t calculator-app .'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker run --rm calculator-app pytest -v --junitxml=results.xml'
            }
        }
    }

    post {
        always {
            script {
                if (fileExists('results.xml')) {
                    junit 'results.xml'
                } else {
                    echo '⚠️ No test results found.'
                }
            }
        }
        success {
            echo '✅ Build and tests completed successfully!'
        }
        failure {
            echo '❌ Build or tests failed. Check the test results for details.'
        }
    }
}
