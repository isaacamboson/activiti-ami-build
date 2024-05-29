#!/bin/bash


#Creating Necessary Directories 
sudo apt-get update
sudo mkdir -p /home/ubuntu/monitoring
sudo mkdir -p /home/ubuntu/.cache/helm
sudo mkdir -p /home/ubuntu/.kube
sudo mkdir -p /home/ubuntu/deployments
sudo mkdir -p /home/ubuntu/services
sudo mkdir -p /etc/apt/sources.list.d/
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo mkdir -p /etc/apt/keyrings/


#installing necessary addons
sudo apt install -y nfs-common 
sudo apt install -y awscli
sudo apt install mysql-client-core-8.0 -y

#installing CloudWatch Agent
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloud
sudo rpm -U ./amazon-cloudwatch-agent.rpm

cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
    "metrics": {
        "metrics_collected": {
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 30
            }
        }
    }
}
EOF

#Installing docker
sudo apt install docker.io -y

#installing Containerd

# Install and configure prerequisites
## load the necessary modules for Containerd
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Install containerd
sudo apt-get update

# Install packages needed to use the Kubernetes apt repository
sudo apt-get install -y apt-transport-https ca-certificates curl

#Installing Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.28.1-1.1 
sudo apt-get install -y kubeadm=1.28.1-1.1
sudo apt-get install -y kubectl=1.28.1-1.1 --allow-downgrades
sudo apt-mark hold kubelet kubeadm kubectl

# #installing HELM
# snap install helm --classic 
# sudo chown -R ubuntu.ubuntu /home/ubuntu/.cache/helm

#Installing Prometheus
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add stable https://charts.helm.sh/stable
# helm repo update

# Apply sysctl params without reboot
sudo sysctl --system