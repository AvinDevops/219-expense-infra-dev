pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage ('Init') {
            steps {
                sh """
                cd 01-vpc
                terraform init -reconfigure
                """
            }
        }
        stage ('Plan') {
            steps {
                echo 'This is test plan'
            }
        }
        stage ('Depoly') {
            steps {
                echo 'This is test Deploy'
            }
        }
    }

    post {
        always {
            echo 'I will run this pipeline, whether it is success or failure'
        }
        success {
            echo 'I will run this pipeline, when it is success'
        }
        failure {
            echo 'I will run this pipeline, when it is failure'
        }
    }
}