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
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/zibroo/jenkins-terraform"
                        }
                    }
                }
            }
        stage('Init') {
            steps {
                sh ' pwd;cd terraform/ ;terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh " pwd;cd terraform/ ;terraform plan  -out=plan.txt ;  terraform show -no-color plan.txt > tfplan.txt ; rm -rf plan.txt"
            }
        }       
        stage('Validate') {
            steps {
                sh " pwd;cd terraform/ ;terraform validate"
            }
        } 
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply --auto-approve"
            }
        }
    }

  }
