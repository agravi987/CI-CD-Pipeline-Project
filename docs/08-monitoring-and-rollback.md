# 🩺 Step 8: Live Monitoring, Logs & Rollback Strategies

What separates a junior developer from a real DevOps engineer is what happens **after** deployment:
- *How do you know if the app is performing well?* 📊
- *Where do you look when an error occurs?* 📜
- *How do you roll back to safety in 60 seconds if a bad release slips through?* 🔄

---

## 📜 1. How to Monitor Containers & View Logs on EC2

When your app is running on AWS EC2, you can inspect it anytime using these essential Docker commands:

### A. Check Running Containers:
Connect to your EC2 instance and run:
```bash
docker ps
```
You will see all 3 containers with their status, ports, and names:
```text
CONTAINER ID   IMAGE                          STATUS         PORTS                NAMES
a1b2c3d4e5f6   johndoe/devops-client:latest   Up 10 minutes  0.0.0.0:80->80/tcp   prod_frontend
b2c3d4e5f6a1   johndoe/devops-server:latest   Up 10 minutes  0.0.0.0:5000->5000   prod_backend
c3d4e5f6a1b2   postgres:16-alpine             Up 10 minutes  5432/tcp             prod_postgres
```

---

### B. View Live Application Logs:
To stream real-time logs from all 3 services at once:
```bash
cd ~/devops-app
docker compose -f docker-compose.prod.yml logs -f
```

To see logs for just the Backend API:
```bash
docker logs -f prod_backend
```

To see logs for just PostgreSQL:
```bash
docker logs -f prod_postgres
```

---

### C. Inspect PostgreSQL Database Inside the Container:
Want to see the actual tasks stored in PostgreSQL on EC2?
```bash
docker exec -it prod_postgres psql -U postgres -d devops_db -c "SELECT * FROM tasks;"
```

---

## 🔄 2. How to Rollback a Bad Release (3 Methods)

Imagine you deploy a new feature, and 10 minutes later users report an unexpected bug. Don't panic! Here are the 3 industry-standard ways to rollback:

### ⚡ Method 1: The Git SHA Tag Rollback (Fastest & Cleanest)
Because our `cd.yml` pipeline tags every Docker build with its unique commit SHA (`${{ github.sha }}`), every previous version is preserved in Docker Hub!

1. Find the Git commit hash of the last working version (e.g. `9f8e7d6`).
2. SSH into your EC2 instance and run:
   ```bash
   cd ~/devops-app
   export IMAGE_TAG="9f8e7d6"
   docker compose -f docker-compose.prod.yml up -d
   ```
   *Within 5 seconds, your containers restart using the old stable image!* ⏱️

---

### 🖱️ Method 2: GitHub Actions Re-run (No Terminal Needed!)
1. Go to your GitHub repo $\rightarrow$ Click the **Actions** tab.
2. In the left sidebar, click on **CD Pipeline (Continuous Deployment)**.
3. Scroll down and click on the last **Green (Successful)** workflow run.
4. In the top right corner, click **Re-run all jobs**.
5. GitHub Actions will redeploy the known-good version automatically! 🟢

---

### 🌿 Method 3: `git revert` (The Enterprise Standard)
In corporate environments, any change to production should have a Git history trail.
To undo a bad commit:
```bash
# Reverts the last commit and creates a new undo-commit
git revert HEAD

# Push the revert to main!
git push origin main
```
This triggers the CD pipeline, which builds and deploys the reverted clean code automatically! 🚀

---

## 🛠️ Quick Troubleshooting Guide

| Issue | What Causes It? | The Fix |
| :--- | :--- | :--- |
| **`Connection timed out` on Port 22** | EC2 Security Group is missing Port 22 inbound rule. | Add Inbound Rule: `SSH (Port 22)` from `0.0.0.0/0`. |
| **`Connection refused` on Port 80** | EC2 Security Group is missing Port 80, or Nginx container crashed. | Add Inbound Rule: `HTTP (Port 80)` from `0.0.0.0/0`. Run `docker ps` to verify containers are running. |
| **`Permission denied (publickey)`** | SSH Key formatted incorrectly in GitHub Secrets. | Re-copy `devops-ec2-key.pem` making sure to include headers `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`. |
| **`database "devops_db" does not exist`** | PostgreSQL container initialized before `init.sql` mounted. | Run `docker compose -f docker-compose.prod.yml down -v` to reset data volume and recreate. |

---

## ⏭️ Ready for the Final Masterclass?
Prepare to impress recruiters and interviewers with your new CI/CD project:  
👉 **[Go to Step 9: 09-devops-interview-masterclass.md](./09-devops-interview-masterclass.md)**
