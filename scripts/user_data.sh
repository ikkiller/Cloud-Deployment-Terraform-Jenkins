#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

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