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
                echo 'Testing HTML syntax...'
                sh 'grep -q "<html>" ${HTML_SRC} && echo "HTML looks valid!"'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying HTML to EC2 instance...'

                // Use Jenkins credentials for IP and SSH key
                withCredentials([
                    string(credentialsId: 'server_ip', variable: 'EC2_PUBLIC_IP'),
                    sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'EC2_SSH_KEY')
                ]) {
                    sh """
                        echo "Deploying to EC2 at ${EC2_PUBLIC_IP}"
                        scp -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ${HTML_SRC} ${SSH_USER}@${EC2_PUBLIC_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ${SSH_USER}@${EC2_PUBLIC_IP} 'sudo mv /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx'
                    """
                }
            }
        }
    }
}
