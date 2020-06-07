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
                    git 'https://github.com/satinderthakur/April2020.git'
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
        stage('Terraform Apply'){
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
