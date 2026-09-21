# ☁️ Step 5: AWS EC2 Cloud Server Launch (Free Tier)

Welcome to Day 5! 🚀 Today you are launching a real virtual computer in Amazon's cloud data center: an **AWS EC2 (Elastic Compute Cloud)** instance.

---

## 🗺️ What We Are Building on AWS

```
                           THE INTERNET 🌐
                                 │
           ┌─────────────────────┴─────────────────────┐
           │                                           │
    Port 22 (SSH)                                Port 80 (HTTP)
    GitHub Actions Automation                    Web Browsers & Users
           │                                           │
           ▼                                           ▼
┌─────────────────────────────────────────────────────────────┐
│ ☁️ AWS EC2 Instance (Ubuntu Linux - Free Tier)               │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │ 🐳 Docker Engine                                    │   │
│   │                                                     │   │
│   │   [prod_frontend] ──► [prod_backend] ──► [prod_pg]  │   │
│   │   (React / Nginx)      (Express API)     (Postgres) │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Part 1: Launch Your EC2 Instance

1. Log in to your [AWS Management Console](https://aws.amazon.com/console/).
2. In the top search bar, search for **EC2** and click on the EC2 service.
3. Make sure your AWS region (top right, e.g. *US East (N. Virginia)* or *ap-south-1 (Mumbai)*) is selected.
4. Click the big orange **"Launch instance"** button. 🚀

### Configure the Machine:
- **Name**: `devops-production-server`
- **Application and OS Images (AMI)**: Select **Ubuntu** (Choose `Ubuntu Server 24.04 LTS` or `22.04 LTS`, 64-bit x86). Look for the green badge: *Free tier eligible*.
- **Instance type**: Select `t2.micro` (or `t3.micro` depending on region). *Free tier eligible*.

---

## 🔑 Part 2: Create Your SSH Key Pair

The SSH Key is the digital master key you use to log into your Linux server:

1. Scroll down to **Key pair (login)**.
2. Click **Create new key pair**.
3. Settings:
   - **Key pair name**: `devops-ec2-key`
   - **Key pair type**: `RSA`
   - **Private key file format**: Select `.pem` 🗝️.
4. Click **Create key pair**.
5. 💾 A file named `devops-ec2-key.pem` will automatically download to your computer.
   - Move this file to a safe folder on your computer.
   - **Never share or commit this file to GitHub!**

---

## 🛡️ Part 3: Configure Network & Security Group (Firewall)

AWS blocks all incoming internet traffic by default. We must open **Port 22** (for SSH) and **Port 80** (for Web users):

1. Under **Network settings**, click **Edit**.
2. Keep *Auto-assign public IP* set to **Enable**.
3. Under **Firewall (security groups)**, choose *Create security group*:
   - **Security group name**: `devops-web-sg`
   - **Description**: `Allow SSH and Web HTTP traffic`

Add these **3 Inbound Rules**:

| Rule # | Type | Port | Source | Why is this needed? |
| :---: | :--- | :---: | :--- | :--- |
| **1** | **SSH** | `22` | `0.0.0.0/0` (Anywhere) | Lets GitHub Actions and you connect via SSH |
| **2** | **HTTP** | `80` | `0.0.0.0/0` (Anywhere) | Lets anyone view your React website |
| **3** | **Custom TCP** | `5000` | `0.0.0.0/0` (Anywhere) | Direct access to backend API / health endpoint |

4. Click the orange **Launch instance** button at the bottom right! 🎉

---

## 💻 Part 4: Connect to Your New Server

1. In the EC2 Dashboard, click **Instances**.
2. Find your instance `devops-production-server` and verify its state is **Running** 🟢.
3. Click on the instance and copy its **Public IPv4 address** (e.g. `54.210.120.45`).

### 🖱️ Easiest Connection Method (Browser-based):
- Select the instance checkbox.
- Click **Connect** (top right).
- Select **EC2 Instance Connect**.
- Click the orange **Connect** button.
- *A black Linux terminal window will open right inside your web browser!* 🖥️

---

## 🐳 Part 5: Install Docker & Docker Compose on EC2

Now that you are inside the EC2 terminal, run these commands to turn your instance into a container host:

```bash
# 1. Update Ubuntu software packages
sudo apt update && sudo apt upgrade -y

# 2. Install Docker and Docker Compose plugin
sudo apt install -y docker.io docker-compose-v2

# 3. Enable Docker daemon to start on reboot
sudo systemctl enable --now docker

# 4. Allow the 'ubuntu' user to run Docker commands without sudo
sudo usermod -aG docker ubuntu

# 5. Apply the new group permissions immediately
newgrp docker

# 6. Create our deployment folder
mkdir -p ~/devops-app
```

### ✅ Verify the Installation:
Type these two test commands:
```bash
docker --version
docker compose version
```

You should see:
```text
Docker version 24.x.x (or 26.x.x)
Docker Compose version v2.x.x
```

---

## 📋 The 3 Golden Values You Need for GitHub

Before closing your terminal, write down these 3 values:

1. **`EC2_HOST`**: Your EC2 Public IPv4 address (e.g., `54.210.120.45`).
2. **`EC2_USER`**: `ubuntu`
3. **`EC2_SSH_KEY`**: The complete text inside your downloaded `devops-ec2-key.pem` file.
   - Open `devops-ec2-key.pem` with Notepad on Windows or TextEdit on Mac.
   - It looks like:
     ```text
     -----BEGIN RSA PRIVATE KEY-----
     MIIEowIBAAKCAQEA0r1f...
     ...
     -----END RSA PRIVATE KEY-----
     ```
   - Copy **everything**, including the BEGIN and END header lines!

---

## ⏭️ Ready for Day 6?
Your cloud server is ready and waiting. Now let's write our GitHub Actions workflows and deploy automatically!  
👉 **[Go to Step 6: 06-writing-ci-cd-pipelines.md](./06-writing-ci-cd-pipelines.md)**
