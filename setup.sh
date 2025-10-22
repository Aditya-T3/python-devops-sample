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
sudo usermod -aG docker $USER   # Allow current user to use docker without sudo

# -------------------------
# ☕ Install Java (Jenkins requires Java 17+)
# -------------------------
echo "☕ Installing Java 17..."
sudo apt-get install -y openjdk-17-jdk
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
java -version

# -------------------------
# ⚙️ Install Jenkins
# -------------------------
echo "⚙️ Installing Jenkins..."
# Fetch and dearmor Jenkins GPG key into keyring (resolves NO_PUBKEY errors)
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | \
    sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Ensure correct permissions
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chmod -R 755 /var/lib/jenkins

# Enable & start Jenkins service
sudo systemctl daemon-reload
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
# 🧰 Verify Jenkins port and restart if needed
# -------------------------
echo "🔎 Checking Jenkins port availability..."
if sudo ss -tuln | grep -q ':8080'; then
    echo "✅ Port 8080 is open for Jenkins."
else
    echo "⚠️ Jenkins might not be listening on 8080 yet, restarting..."
    sudo systemctl restart jenkins
    sleep 5
    if sudo ss -tuln | grep -q ':8080'; then
        echo "✅ Jenkins is now running on port 8080."
    else
        echo "❌ Jenkins failed to bind to port 8080. Check logs with:"
        echo "   sudo journalctl -u jenkins -xe"
    fi
fi
# -------------------------
# 🧪 Setup Python Path and Run Tests
# -------------------------
export PYTHONPATH=$PYTHONPATH:$(pwd)
pytest -v
# -------------------------
# ✅ Final Info
# -------------------------
echo ""
echo "✅ Setup complete!"
echo "➡️ Jenkins running at: http://localhost:8080"
echo "🔑 To get Jenkins admin password, run:"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "🧾 Versions installed:"
docker --version
java -version
python3 --version
pytest --version || echo "pytest installed only in virtualenv / user site."
jenkins --version || echo "Jenkins version can be checked via web interface."