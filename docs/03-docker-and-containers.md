# 🐳 Step 3: Docker & Containerization Deep-Dive

Welcome to Day 3! 🌟 Today you will master the technology that revolutionized modern cloud deployments: **Docker Containers**. 📦

---

## ❓ The Problem Docker Solves: "Works on My Machine!"

Have you ever said or heard this?
> 👨‍💻 *"It runs fine on my laptop, but when we moved it to the AWS server, it crashed!"*

Why does this happen?
- Maybe your laptop has Node 20, but the cloud server has Node 16.
- Maybe your laptop has specific environment variables or Linux libraries that the server lacks.

### 💡 The Solution: The Shipping Container Analogy
Before 1956, dock workers spent days manually loading bananas, lumber, barrels, and sacks onto cargo ships. 🚢
Then someone invented the **standardized shipping container**. Any container fits on any truck, train, or ship worldwide.

**Docker does the exact same thing for software:**
It packages your code, Node.js runtime, system libraries, configuration, and dependencies into an immutable **Docker Image**. If it runs on your laptop, **it is guaranteed to run identically on AWS EC2!** 🌍

---

## 📜 1. Deconstructing the Backend `Dockerfile`

Open `ci-cd-pipeline-app/server/Dockerfile`. Let's examine every single line:

```dockerfile
# -------------------------------------------------------------
# 1. Base Image: Start with official lightweight Alpine Linux + Node.js 20 (~50MB)
# -------------------------------------------------------------
FROM node:20-alpine

# -------------------------------------------------------------
# 2. Working Directory: Create and move into /app inside container
# -------------------------------------------------------------
WORKDIR /app

# -------------------------------------------------------------
# 3. Layer Caching: Copy package manifests FIRST
# -------------------------------------------------------------
COPY package*.json ./

# -------------------------------------------------------------
# 4. Install Dependencies: Install ONLY production packages
# -------------------------------------------------------------
RUN npm ci --only=production

# -------------------------------------------------------------
# 5. Copy Source Code: Copy our API source files into the container
# -------------------------------------------------------------
COPY src/ ./src/

# -------------------------------------------------------------
# 6. Security Hardening: Switch away from root user to 'node' user
# -------------------------------------------------------------
USER node

# -------------------------------------------------------------
# 7. Documentation: Declare that container listens on port 5000
# -------------------------------------------------------------
EXPOSE 5000

# -------------------------------------------------------------
# 8. Entrypoint Command: Run the app when the container starts
# -------------------------------------------------------------
CMD ["node", "src/server.js"]
```

### 🧠 Why did we copy `package*.json` before `src/`?
Docker builds images in **layers**.
- Every command (`FROM`, `COPY`, `RUN`) creates a cached layer.
- If a layer hasn't changed, Docker **skips it** in the next build!
- In your daily work, you change code in `src/` 99% of the time, but you rarely add new npm packages.
- Because `package*.json` hasn't changed, Docker reuses the cached `npm ci` layer! Your builds take **2 seconds** instead of 2 minutes! ⚡

---

## 📉 2. Multi-Stage Docker Build: Shrinking React by 95%!

Look inside `ci-cd-pipeline-app/client/Dockerfile`.
Here we use a superpower called a **Multi-Stage Build**:

```
┌─────────────────────────────────────────────────────────────┐
│ 🏗️ STAGE 1: BUILDER (node:20-alpine) ~ 500 MB               │
│ - Installs Node.js & Vite dev dependencies                  │
│ - Compiles React JSX and CSS into minified HTML/JS/CSS      │
│ - Output folder: /app/dist                                  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               │ ✂️ Discards Node.js, npm, & node_modules!
                               │ 📋 Copies ONLY the /dist folder!
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 🚀 STAGE 2: PRODUCTION (nginx:alpine) ~ 25 MB               │
│ - Ultra-lightweight Nginx web server                        │
│ - Serves the static files on Port 80                        │
│ - Zero extra bloat, maximum security & blazing speed!       │
└─────────────────────────────────────────────────────────────┘
```

### The Code:
```dockerfile
# --- STAGE 1: The Builder ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- STAGE 2: The Production Server ---
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
# Copy the compiled website from Stage 1!
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

> [!TIP]
> **Interview Question Gold**: If an interviewer asks *"How do you optimize Docker image size?"*, tell them:  
> 1. Use Alpine-based base images (`node:20-alpine`).  
> 2. Use Multi-stage builds to discard development compilers from production.  
> 3. Use `.dockerignore` to avoid copying `node_modules` into the build context.

---

## 🌐 3. Nginx Reverse Proxy: The Traffic Policeman

In `ci-cd-pipeline-app/client/nginx.conf`:
```nginx
server {
    listen 80;
    root /usr/share/nginx/html;

    # 1. If a browser requests a page (e.g. / or /dashboard), serve React index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 2. If a browser makes an API call starting with /api/,
    # route it internally to the Express backend container!
    location /api/ {
        proxy_pass http://server:5000;
        proxy_set_header Host $host;
    }
}
```

This means your browser only ever talks to **Port 80**. Nginx handles forwarding API requests internally without any CORS headache! 🛡️

---

## ⚖️ 4. `docker-compose.yml` vs `docker-compose.prod.yml`

Why do we have two compose files?

| Feature | 🛠️ `docker-compose.yml` (Local Dev) | ☁️ `docker-compose.prod.yml` (EC2 Prod) |
| :--- | :--- | :--- |
| **How It Runs** | Builds images locally from code (`build: ./server`) | Pulls ready-made images from Docker Hub (`image: user/devops-server:latest`) |
| **Speed** | 1-2 minutes to compile | 5-10 seconds to download |
| **Server Load** | High CPU & RAM usage | Ultra-low CPU (perfect for AWS Free Tier EC2!) |
| **Restart Policy** | `unless-stopped` | `always` (automatically reboots if server restarts) |

---

## ⏭️ Ready for Day 4?
Now that our containers are ready, let's create our cloud registry on Docker Hub:  
👉 **[Go to Step 4: 04-docker-hub-setup.md](./04-docker-hub-setup.md)**
