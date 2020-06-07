pipeline
{
    agent any
    stages
    {
        stage('Checkout'){
            steps
            {
                script
                {
                    git 'https://github.com/satinderthakur/May2020.git'
                }
            }
        }
        stage('Docker Build'){
            steps{
                script{
                    docker.build('demo')
                }
            }
        }
        stage('Docker Push'){
            steps{
                script{
                    docker.withRegistry('https://235190073377.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:Demo'){
                        docker.image('demo').push('latest')
                    }
                }
            }
        }
        stage('Terraform Apply for ECS'){
			steps{
				script{
					bat'''
					
						terraform init
						terraform apply -auto-approve
					'''
				}
			}
		}
    }
} 
