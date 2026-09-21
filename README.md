# 🥉 DevOps CI/CD Pipeline Project: Zero to Hero 🚀

Welcome to your complete **CI/CD Pipeline Project**! This project guides you step-by-step from *"I know basic Docker"* to *"I can automate full-stack software delivery to the cloud like a DevOps engineer"*. 🌟

---

## 📂 Project Architecture & Structure

```
ci-cd-pipeline-project/
├── 🚀 ci-cd-pipeline-app/         # Full-Stack Application & CI/CD Workflows
│   ├── .github/workflows/
│   │   ├── ci.yml                 # 🧪 Lint, Unit Tests & 🛡️ Trivy Security Scanning
│   │   └── cd.yml                 # 🐳 Build, Push to Docker Hub & ☁️ Deploy to EC2
│   ├── client/                    # ⚛️ React 18 (Vite) + Nginx Reverse Proxy + Dockerfile
│   ├── server/                    # 🟢 Express.js REST API + /api/health + Jest Tests
│   ├── db/
│   │   └── init.sql               # 🐘 PostgreSQL Table Schema & Seed Data
│   ├── docker-compose.yml         # 💻 Local Development Orchestrator
│   ├── docker-compose.prod.yml    # ☁️ Production AWS EC2 Orchestrator
│   └── .gitignore
│
└── 📚 docs/                       # 📖 10-Part Step-by-Step Learning Masterclass
    ├── 00-zero-to-hero-roadmap.md # 🗺️ 7-Day Beginner Learning Roadmap with milestones
    ├── 01-concepts-made-simple.md # 🧠 CI vs CD explained with Pizza Restaurant analogy
    ├── 02-application-breakdown.md# ⚛️ 3-Tier Architecture, /api/health & local test run
    ├── 03-docker-and-containers.md# 🐳 Multi-Stage Docker builds (500MB -> 25MB) & Nginx
    ├── 04-docker-hub-setup.md     # 🚢 Setting up Docker Hub & Access Tokens (PAT)
    ├── 05-aws-ec2-setup.md        # ☁️ Launching Free Tier EC2, Firewalls & Docker Engine
    ├── 06-writing-ci-cd-pipelines.md # ⚡ GitHub Secrets, YAML breakdown & live deployment
    ├── 07-git-and-branching-strategy.md # 🌿 Feature branches, Pull Requests & PR Protection
    ├── 08-monitoring-and-rollback.md # 🩺 Live logs, health checks & 60-second rollbacks
    └── 09-devops-interview-masterclass.md # 💼 Resume bullet points & top 10 interview answers
```

---

## ⚡ Quick Start: Run Locally in 60 Seconds

Make sure you have **Docker Desktop** installed on your computer:

```bash
# 1. Navigate to the application folder
cd "ci-cd-pipeline-app"

# 2. Start all 3 tiers with 1 command!
docker compose up --build
```

Now open your web browser:
- ⚛️ **Frontend UI**: [http://localhost](http://localhost)
- 🩺 **Backend Health API**: [http://localhost:5000/api/health](http://localhost:5000/api/health)
- 📋 **Database Tasks API**: [http://localhost:5000/api/tasks](http://localhost:5000/api/tasks)

---

## 🗺️ Step-by-Step Learning Guide

Follow the guides in order to build your pipeline and deploy to AWS EC2:

1. 🗺️ **[00-zero-to-hero-roadmap.md](./docs/00-zero-to-hero-roadmap.md)** - 7-Day Plan with milestones & checklists.
2. 🧠 **[01-concepts-made-simple.md](./docs/01-concepts-made-simple.md)** - What is CI/CD, Runners, Jobs, and Secrets?
3. ⚛️ **[02-application-breakdown.md](./docs/02-application-breakdown.md)** - How React, Express, and PostgreSQL interact.
4. 🐳 **[03-docker-and-containers.md](./docs/03-docker-and-containers.md)** - Line-by-line Dockerfile breakdown and Nginx reverse proxy.
5. 🚢 **[04-docker-hub-setup.md](./docs/04-docker-hub-setup.md)** - Creating image repositories and Access Tokens.
6. ☁️ **[05-aws-ec2-setup.md](./docs/05-aws-ec2-setup.md)** - Launching AWS EC2 Ubuntu instance and installing Docker.
7. ⚡ **[06-writing-ci-cd-pipelines.md](./docs/06-writing-ci-cd-pipelines.md)** - Adding GitHub Secrets, triggering pipelines, and going live!
8. 🌿 **[07-git-and-branching-strategy.md](./docs/07-git-and-branching-strategy.md)** - Git branches, Pull Requests, and CI status checks.
9. 🩺 **[08-monitoring-and-rollback.md](./docs/08-monitoring-and-rollback.md)** - Inspecting live logs and rolling back bad releases in seconds.
10. 💼 **[09-devops-interview-masterclass.md](./docs/09-devops-interview-masterclass.md)** - Resume bullet points, elevator pitch, and interview questions.

---

🎉 **Start your journey here**: 👉 **[docs/00-zero-to-hero-roadmap.md](./docs/00-zero-to-hero-roadmap.md)**
