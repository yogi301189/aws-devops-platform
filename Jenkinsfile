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
        stage('Terraform Init') {
            steps {
                bat 'terraform init -input=false'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }
    }
}