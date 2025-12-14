#!/bin/bash

# Multi-Architecture EC2 Deployment Script for RevTicket Microservices
set -e

echo "🚀 Starting multi-architecture EC2 deployment for RevTicket Microservices..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. Please log out and log back in, then run this script again."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed."
fi

# Get EC2 public IP automatically
EC2_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "localhost")
echo "📍 Detected EC2 Public IP: $EC2_PUBLIC_IP"

# Update .env.ec2 with actual IP
sed -i "s/YOUR_EC2_PUBLIC_IP_HERE/$EC2_PUBLIC_IP/g" .env.ec2

echo "🔧 Configuring services for EC2..."

# Stop any existing containers
docker-compose --env-file .env.ec2 down -v 2>/dev/null || true

# Pull latest multi-architecture images
echo "📥 Pulling latest multi-architecture Docker images..."
docker-compose --env-file .env.ec2 pull

# Start services
echo "🏗️ Starting services..."
docker-compose --env-file .env.ec2 up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 60

# Check service health
echo "🔍 Checking service health..."
for port in {8080..8091}; do
  if curl -s http://localhost:$port/actuator/health >/dev/null 2>&1; then
    echo "✅ Service on port $port is healthy"
  else
    echo "❌ Service on port $port is not responding"
  fi
done

echo "🎉 Multi-architecture deployment completed!"
echo "📱 Frontend: http://$EC2_PUBLIC_IP:4200"
echo "🔗 API Gateway: http://$EC2_PUBLIC_IP:8080"
echo "🔍 Consul: http://$EC2_PUBLIC_IP:8500"

echo ""
echo "📋 Management commands:"
echo "  Logs: docker-compose --env-file .env.ec2 logs -f"
echo "  Stop: docker-compose --env-file .env.ec2 down"
echo "  Restart: docker-compose --env-file .env.ec2 restart"