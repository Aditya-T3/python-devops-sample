#!/bin/bash
set -e

echo "🚀 Updating system packages..."
sudo apt-get update -y

echo "📦 Installing base dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release \
                       software-properties-common python3 python3-pip

# -------------------------
# 🐳 Install Docker
# -------------------------
echo "🐳 Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER   # let current user run docker without sudo

# -------------------------
# ⚙️ Install Jenkins
# -------------------------
echo "⚙️ Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -------------------------
# 🧪 Install Python dependencies
# -------------------------
echo "🧪 Installing Python requirements..."
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt
else
    echo "⚠️ requirements.txt not found, skipping Python dependency installation."
fi

# -------------------------
# ✅ Final Info
# -------------------------
echo "✅ Setup complete!"
echo "➡️ Jenkins running at: http://localhost:8080"
echo "🔑 To get Jenkins admin password, run:"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
docker --version
python3 --version
pytest --version || echo "pytest installed only in virtualenv / user site."
