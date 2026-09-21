# 🚀 DevOps CI/CD Pipeline Application

A complete 3-tier production-grade application designed to master Continuous Integration and Continuous Deployment (CI/CD) with **React**, **Express.js**, **PostgreSQL**, **Docker**, **Docker Hub**, and **AWS EC2**.

---

## 🏗️ Architecture Overview

- **Frontend (`client/`)**: React (Vite) served through an **Nginx** reverse proxy on port `80`.
- **Backend (`server/`)**: Node.js & Express REST API on port `5000` with `/api/health` and task CRUD endpoints.
- **Database (`db/`)**: PostgreSQL 16 Alpine on port `5432` with auto-initialization schema (`init.sql`).
- **Automation (`.github/workflows/`)**:
  - `ci.yml`: Automated testing, linting, and Trivy security scanning on Pull Requests.
  - `cd.yml`: Automated build, push to Docker Hub, SSH deployment to AWS EC2, and health check validation.

---

## ⚡ Quick Start (Local Run with Docker Compose)

Make sure you have Docker Desktop installed, then run:

```bash
# Inside the ci-cd-pipeline-app folder:
docker compose up --build
```

Now open in your browser:
- **Frontend App**: [http://localhost](http://localhost)
- **Backend API**: [http://localhost:5000](http://localhost:5000)
- **Health Check**: [http://localhost:5000/api/health](http://localhost:5000/api/health)

To stop the containers:
```bash
docker compose down
```

---

## 🧪 Running Automated Tests Locally

### Backend Tests (Jest & Supertest)
```bash
cd server
npm install
npm test
```

### Frontend Tests (Vitest)
```bash
cd client
npm install
npm test
```

---

## 📚 Step-by-Step Educational Guides

Detailed beginner-friendly guides are located in the `docs/` folder:
1. `docs/01-concepts-made-simple.md` - CI vs CD, Git branching, Secrets.
2. `docs/02-run-locally.md` - Run and test locally step-by-step.
3. `docs/03-docker-explained.md` - Line-by-line breakdown of Dockerfiles & Compose.
4. `docs/04-docker-hub-setup.md` - Setting up Docker Hub repositories and Access Tokens.
5. `docs/05-aws-ec2-setup.md` - Launching and configuring an AWS EC2 instance.
6. `docs/06-github-actions-guide.md` - Configuring GitHub Secrets and deploying automatically.
7. `docs/07-troubleshooting-and-faq.md` - Common pitfalls, fixes, and interview tips.
