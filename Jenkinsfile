pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    parameters {
        choice(name: 'Action', choices: ['Apply','Destroy'], description: 'pick something' )
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
            when {
                expression {
                    params.Action == 'Apply'
                }
            }
            steps {
                sh """
                cd 01-vpc
                terraform plan
                """
            }
        }
        stage ('Depoly') {
            when {
                expression {
                    params.Action == 'Apply'
                }
            }
            input {
                message "should we continue?"
                ok "yes, we should"
            }
            steps {
                sh """
                cd 01-vpc
                terraform apply -auto-approve
                """
            }
        }
        stage ('Destroy') {
            when {
                expression {
                    params.Action == 'Destroy'
                }
            }
            steps {
                sh """
                cd 01-vpc
                terraform destroy -auto-approve
                """
            }
        }
    }

    post {
        always {
            echo 'I will run this pipeline, whether it is success or failure'
            deleteDir()
        }
        success {
            echo 'I will run this pipeline, when it is success'
        }
        failure {
            echo 'I will run this pipeline, when it is failure'
        }
    }
}