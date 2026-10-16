#!/bin/bash
# 1 · Instalar nginx
apt-get update -y
apt-get install -y nginx

# 2 · Certificado autofirmado
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 -subj "/CN=ubuntu-asir" \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt

# 3 · nginx en 443
cat > /etc/nginx/conf.d/https.conf <<'EOF'
server {
  listen 443 ssl;
  ssl_certificate     /etc/ssl/certs/nginx.crt;
  ssl_certificate_key /etc/ssl/private/nginx.key;
  root  /var/www/html;
  index index.html index.nginx-debian.html;
}
EOF

# 4 · Aplicar cambios
systemctl restart nginx
