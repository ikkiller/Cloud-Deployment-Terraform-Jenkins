pipeline {
    agent any

    environment {
        HTML_SRC = 'Code/Index.html'
        SSH_USER = 'ubuntu'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building project...'
                sh 'echo "Build step - preparing HTML file"'
            }
        }

        stage('Test') {
            steps {
                echo 'Running dummy test...'
                sh 'bash scripts/dummy_test.sh'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying HTML to EC2 instance...'

                withCredentials([
                    string(credentialsId: 'server_ip', variable: 'EC2_PUBLIC_IP'),
                    file(credentialsId: 'SSH_KEY', variable: 'EC2_SSH_KEY')
                ]) {
                    sh """
                        echo "Deploying to EC2 at ${EC2_PUBLIC_IP}"
                        scp -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ${HTML_SRC} ${SSH_USER}@${EC2_PUBLIC_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ${SSH_USER}@${EC2_PUBLIC_IP} 'sudo mv /tmp/Index.html /var/www/html/Index.html && sudo systemctl restart nginx'
                    """
                }
            }
        }
    }
}
