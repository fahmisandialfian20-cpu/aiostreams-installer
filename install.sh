#!/bin/bash
set -e

echo "===[ AIOSTREAMS INSTALLER ]==="

sudo apt update -y
sudo apt install -y curl docker.io docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

sudo mkdir -p /opt/aiostreams
sudo tee /opt/aiostreams/docker-compose.yml >/dev/null <<'EOF'
version: '3.3'
services:
  aiostreams:
    image: ghcr.io/ruru-org/aiostreams:latest
    container_name: aiostreams
    restart: unless-stopped
    ports:
      - "3005:3005"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - AIOSTREAMS_ADMIN_EMAIL=${AIOSTREAMS_ADMIN_EMAIL}
      - AIOSTREAMS_ADMIN_PASSWORD=${AIOSTREAMS_ADMIN_PASSWORD}
      - JWT_SECRET=${JWT_SECRET}
EOF

echo "Masukkan DATABASE_URL Neon/Supabase:"
read DATABASE_URL
echo "Masukkan admin email:"
read AIOSTREAMS_ADMIN_EMAIL
echo "Masukkan admin password:"
read AIOSTREAMS_ADMIN_PASSWORD
JWT_SECRET=$(openssl rand -hex 32)

export DATABASE_URL
export AIOSTREAMS_ADMIN_EMAIL
export AIOSTREAMS_ADMIN_PASSWORD
export JWT_SECRET

sudo -E docker compose -f /opt/aiostreams/docker-compose.yml up -d

echo "================================================"
echo "AIOSTREAMS berhasil diinstall!"
echo "Akses: http://IP-KAMU:3005"
echo "Admin Email: $AIOSTREAMS_ADMIN_EMAIL"
echo "Admin Password: $AIOSTREAMS_ADMIN_PASSWORD"
echo "================================================"
