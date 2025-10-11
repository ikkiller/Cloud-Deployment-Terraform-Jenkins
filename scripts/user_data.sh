#!/bin/bash

apt update -y
apt install -y nginx unzip curl

systemctl enable nginx
systemctl start nginx

cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
  <head><title>Hello</title></head>
  <body>
    <h1>Hello from Terraform + Nginx (Ubuntu)!</h1>
    <p>This instance was provisioned using Terraform on Ubuntu 24.04.</p>
  </body>
</html>
EOF

#Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

#Verify AWS CLI installation path
AWS_PATH=$(which aws)
echo "AWS CLI installed at: $AWS_PATH"

#monitoring script for ubuntu user
cat <<'EOF' > /home/ubuntu/check_nginx.sh
#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
if curl -s --head http://localhost | grep "200 OK" > /dev/null; then
    /usr/local/bin/aws cloudwatch put-metric-data \
        --metric-name HTTPCheckFailed \
        --namespace "Custom/WebService" \
        --value 0 \
        --dimensions InstanceId=$INSTANCE_ID
else
    /usr/local/bin/aws cloudwatch put-metric-data \
        --metric-name HTTPCheckFailed \
        --namespace "Custom/WebService" \
        --value 1 \
        --dimensions InstanceId=$INSTANCE_ID
fi
EOF

#Ensure script ownership and permissions
chown ubuntu:ubuntu /home/ubuntu/check_nginx.sh
chmod +x /home/ubuntu/check_nginx.sh

#Add cron job for ubuntu user (run every minute with logging)
#(crontab -u ubuntu -l 2>/dev/null; echo "* * * * * /home/ubuntu/check_nginx.sh >> /home/ubuntu/check_nginx.log 2>&1") | crontab -u ubuntu -

#Add cron job for ubuntu user (run every minute without logging)
(crontab -u ubuntu -l 2>/dev/null; echo "* * * * * /home/ubuntu/check_nginx.sh") | crontab -u ubuntu -
