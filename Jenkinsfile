pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage ('test') {
            steps {
                sh """
                ls -ltr
                """
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