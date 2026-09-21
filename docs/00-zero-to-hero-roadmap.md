# 🗺️ 7-Day DevOps CI/CD Zero-to-Hero Roadmap

Welcome to your personalized roadmap! 🚀
If you have never built a CI/CD pipeline before, **don't panic**. Follow this 7-day schedule at your own pace (1 to 2 hours per day), and by the end of the week, you will have a live, fully automated cloud deployment on AWS to show off on your resume and portfolio. 🌟

---

## 📅 Roadmap Overview at a Glance

```
Day 1: 🧠 The Big Picture (CI vs CD & Core Concepts)
   │
Day 2: ⚛️ Run the Full-Stack App Locally (React + Express + PostgreSQL)
   │
Day 3: 🐳 Master Docker & Multi-Stage Containers
   │
Day 4: 🚢 Set Up Docker Hub (The Container Warehouse)
   │
Day 5: ☁️ Launch and Prepare Your AWS EC2 Cloud Server
   │
Day 6: ⚡ Write GitHub Actions YAML & Trigger First Automated Deployment
   │
Day 7: 💼 Master Rollbacks, Monitoring & Ace the DevOps Interview!
```

---

## 🗓️ Day-by-Day Learning Plan

### 📍 Day 1: The Mindset & Fundamentals 🧠
- [ ] Read **[01-concepts-made-simple.md](./01-concepts-made-simple.md)**
- [ ] Understand the difference between **Continuous Integration (CI)** and **Continuous Deployment (CD)**.
- [ ] Learn what GitHub Actions **Runners**, **Jobs**, and **Steps** are using the *Restaurant Kitchen Analogy* 🍳.
- [ ] Understand why we protect secrets with **GitHub Secrets** 🔐.
- 🎯 **Milestone**: You can explain to a friend what CI/CD is without using confusing jargon!

---

### 📍 Day 2: Meet the 3-Tier Application ⚛️🟢🐘
- [ ] Read **[02-application-breakdown.md](./02-application-breakdown.md)**
- [ ] Explore the folder structure inside `ci-cd-pipeline-app/`.
- [ ] Test the backend `/api/health` endpoint and understand why every DevOps engineer needs health checks 🩺.
- [ ] Run the app locally with Docker Compose: `docker compose up --build`.
- [ ] Interact with the live UI in your browser at `http://localhost`.
- 🎯 **Milestone**: You saw all 3 tiers (React, Express, PostgreSQL) running together on your own laptop!

---

### 📍 Day 3: Containerization Magic with Docker 🐳
- [ ] Read **[03-docker-and-containers.md](./03-docker-and-containers.md)**
- [ ] Understand why Docker solves the *"it works on my machine"* problem 💻.
- [ ] Learn how **Layer Caching** makes builds lightning fast ⚡.
- [ ] Learn how **Multi-Stage Builds** shrink React image size from 500MB down to 25MB 📉.
- [ ] Learn how **Nginx** routes frontend and API requests seamlessly without CORS errors 🌐.
- 🎯 **Milestone**: You understand every single line of a `Dockerfile` and `docker-compose.yml`!

---

### 📍 Day 4: Docker Hub Container Registry 🚢
- [ ] Read **[04-docker-hub-setup.md](./04-docker-hub-setup.md)**
- [ ] Create a free account on [hub.docker.com](https://hub.docker.com/).
- [ ] Create two public repositories: `devops-server` and `devops-client`.
- [ ] Generate a secure **Personal Access Token (PAT)** 🔑.
- 🎯 **Milestone**: You have a secure cloud repository ready to receive your container images!

---

### 📍 Day 5: AWS EC2 Cloud Server Launch ☁️
- [ ] Read **[05-aws-ec2-setup.md](./05-aws-ec2-setup.md)**
- [ ] Log into the AWS Free Tier console.
- [ ] Launch an Ubuntu `t2.micro` EC2 instance 🖥️.
- [ ] Download and securely store your `.pem` SSH key 🗝️.
- [ ] Configure the AWS Security Group Firewall (Port 22 for SSH, Port 80 for Web) 🛡️.
- [ ] Install Docker and Docker Compose on EC2 using our 3 quick copy-paste commands ⚡.
- 🎯 **Milestone**: Your cloud server is online and waiting for automated deployments!

---

### 📍 Day 6: The Pipeline in Action ⚡🤖
- [ ] Read **[06-writing-ci-cd-pipelines.md](./06-writing-ci-cd-pipelines.md)**
- [ ] Read **[07-git-and-branching-strategy.md](./07-git-and-branching-strategy.md)**
- [ ] Add the 5 required **GitHub Secrets** into your repository settings 🔒.
- [ ] Understand how `.github/workflows/ci.yml` runs tests and scans for security vulnerabilities with **Trivy** 🛡️.
- [ ] Understand how `.github/workflows/cd.yml` pushes to Docker Hub, connects via SSH to EC2, and restarts the containers 🚀.
- [ ] Run `git push` to your GitHub repo and watch the GitHub Actions tab turn green! 🟢
- [ ] Visit `http://<YOUR-EC2-PUBLIC-IP>` in your browser and see your live production website! 🎉
- 🎯 **Milestone**: You just completed your first 100% automated CI/CD pipeline!

---

### 📍 Day 7: Monitoring, Rollbacks & Interview Prep 💼
- [ ] Read **[08-monitoring-and-rollback.md](./08-monitoring-and-rollback.md)**
- [ ] Learn how to check live container logs on EC2 📜.
- [ ] Practice rolling back to an earlier version using Git commit SHA tags 🔄.
- [ ] Read **[09-devops-interview-masterclass.md](./09-devops-interview-masterclass.md)**
- [ ] Rehearse the 15 most common DevOps interview questions and memorize your project elevator pitch 🎤.
- [ ] Add this project to your LinkedIn, GitHub portfolio, and resume 📄.
- 🎯 **Milestone**: You are fully prepared to talk about CI/CD like a seasoned DevOps professional!

---

## 🏆 Your Reward
Once you finish this roadmap, you will have transitioned from:
> ❌ *"I only know basic Docker commands on my laptop."*

To:
>  *"I can architect, test, scan, containerize, and continuously deploy full-stack applications to cloud infrastructure automatically on every git push!"*

Let's begin! 👉 **[Start Day 1: 01-concepts-made-simple.md](./01-concepts-made-simple.md)**
