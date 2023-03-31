pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
    stage('Credentials') {
            steps {
                sh ' export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID'
                sh ' export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY'

            }
        }
        stage('Init') {
            steps {
                sh ' terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh " terraform plan -no-color -out=tfplan.txt"
                sh "pwd"
            }
        }       
        stage('Validate') {
            steps {
                sh " terraform validate"
            }
        } 
    //     stage('Approval') {
    //        when {
    //            not {
    //                equals expected: true, actual: params.autoApprove
    //            }
    //        }

    //        steps {
    //            script {
    //                 input message: "Do you want to apply the plan?",
    //                 parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: readFile 'tfplan.txt')]
    //            }
    //        }
    //    }

    //     stage('Apply') {
    //         steps {
    //             sh " terraform apply --auto-approve"
    //         }
    //     }
    }

  }
