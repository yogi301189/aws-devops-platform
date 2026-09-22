pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Format') {
            steps {
                bat 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }
    }
}