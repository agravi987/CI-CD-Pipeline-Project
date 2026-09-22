# 🚨 Step 10: Docker Compose Troubleshooting Guide (Real-World Errors & Fixes)

Errors while running `docker compose up --build` are **the #1 rite of passage** for every DevOps beginner! 🎓  
In production DevOps, debugging Docker errors is 50% of the job. This guide breaks down the exact error you encountered, why it happened, and how to fix other common Docker pitfalls. 🛠️✨

---

## 💥 Case Study: The `npm ci` Lockfile Error

### 🛑 The Error Message You Saw:
```text
#13 [server 4/5] RUN npm ci --only=production
#13 1.623 npm error code EUSAGE
#13 1.623 npm error The `npm ci` command can only install with an existing package-lock.json or
#13 1.623 npm error npm-shrinkwrap.json with lockfileVersion >= 1. Run an install with npm@5 or
#13 1.623 npm error later to generate a package-lock.json file, then try again.
#13 ERROR: process "/bin/sh -c npm ci --only=production" did not complete successfully: exit code: 1
```

---

### 🧐 Why Did This Happen? (`npm ci` vs `npm install`)

Beginners often ask: *"What is the difference between `npm install` and `npm ci`?"*

| Command | What It Does | Does It Require `package-lock.json`? |
| :--- | :--- | :---: |
| **`npm install`** 📦 | Reads `package.json`, installs packages, and **creates** a `package-lock.json` if one is missing. | ❌ No |
| **`npm ci`** (Clean Install) 🧼 | Strictly requires an existing `package-lock.json`. It deletes `node_modules` and does an exact byte-for-byte install. | ✅ **YES (Mandatory!)** |

#### The Root Cause:
In a brand new project where `npm install` hasn't been run on the host computer yet, there is no `package-lock.json` file inside `server/` or `client/`.  
When Docker ran `RUN npm ci`, npm panicked and said:  
> *"You asked for a clean install (`ci`), but you didn't give me a `package-lock.json` to verify!"*

---

### 💡 The Solution (How We Fixed It):

We updated both Dockerfiles to use `npm install`:

#### In `ci-cd-pipeline-app/server/Dockerfile`:
```dockerfile
# ❌ Before (Failed because package-lock.json didn't exist):
# RUN npm ci --only=production

# ✅ After (Works seamlessly with or without lockfile):
RUN npm install --omit=dev
```

#### In `ci-cd-pipeline-app/client/Dockerfile`:
```dockerfile
# ❌ Before:
# RUN npm ci

# ✅ After:
RUN npm install
```

> [!TIP]
> Notice `--omit=dev` instead of `--only=production`? Modern npm (v8+) prefers `--omit=dev` to skip devDependencies like test runners and compilers.

---

## ⚠️ Warning 2: `the attribute version is obsolete`

### 🛑 The Warning Message:
```text
level=warning msg="docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
```

### 🧐 Why Did This Happen?
In legacy Docker Compose (v1), writing `version: '3.8'` at the top of the file was required.  
In modern **Docker Compose V2** (the Docker Compose plugin `docker compose`), the compose specification is unified, and the top-level `version` key is deprecated.

### 💡 The Solution:
Simply delete the `version: '3.8'` line from `docker-compose.yml` and start directly with `services:`.

---

## 🚫 Error 3: `no configuration file provided: not found`

### 🛑 The Error Message:
```text
no configuration file provided: not found
```

### 🧐 Why Did This Happen?
Docker Compose searches for a file named `docker-compose.yml` in the **current terminal directory**.  
If you ran `docker compose up --build` inside `ci-cd-pipeline-project/` instead of `ci-cd-pipeline-app/`, Docker couldn't find the file!

### 💡 The Solution:
We created a top-level `docker-compose.yml` directly in `ci-cd-pipeline-project/`!  
Now, running `docker compose up --build` works **from both locations**:
1. From `ci-cd-pipeline-project/`
2. Or from `ci-cd-pipeline-project/ci-cd-pipeline-app/`

---

## 🔒 Error 4: `bind: address already in use: 0.0.0.0:80` (or `5432` / `5000`)

### 🛑 The Error Message:
```text
Error response from daemon: driver failed programming external connectivity on endpoint devops_frontend:
Bind for 0.0.0.0:80 failed: port is already allocated
```

### 🧐 Why Did This Happen?
Another application on your computer is already using Port 80 (common culprits on Windows: Skype, IIS, Apache/XAMPP, or another Docker container).

### 💡 The Solution:
1. **Find and stop what is using Port 80 on Windows**:
   Open PowerShell as Administrator:
   ```powershell
   netstat -ano | findstr :80
   ```
2. **Or change the external port in `docker-compose.yml`**:
   Change:
   ```yaml
   ports:
     - "80:80"
   ```
   To a different port like:
   ```yaml
   ports:
     - "8080:80"
   ```
   Then open `http://localhost:8080` in your browser! 🌐

---

## 🐘 Error 5: Database Connection Timeout / Disconnected

### 🛑 Symptoms:
- Frontend loads, but tasks don't show up.
- Health check shows: `"database": "disconnected"`.

### 🧐 Why Did This Happen?
PostgreSQL takes 3 to 5 seconds to initialize its storage on first boot. If the Express backend starts before PostgreSQL is ready to accept connections, the backend connection crashes.

### 💡 The Solution:
Our `docker-compose.yml` uses a Docker **Healthcheck** with `condition: service_healthy`:

```yaml
postgres:
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U postgres -d devops_db"]
    interval: 5s
    timeout: 5s
    retries: 5

server:
  depends_on:
    postgres:
      condition: service_healthy # Express waits until Postgres is 100% ready!
```

---

## 🧹 The "Nuclear Reset" Command (When Nothing Else Works)

If containers ever get stuck in a weird state, run this clean-slate reset:

```bash
# 1. Stop all containers and remove volumes & networks
docker compose down -v --remove-orphans

# 2. Rebuild fresh without cache
docker compose up --build
```

---

## 📸 Proof of Work: Screenshots

> [!TIP]
> **Capture your proof of work!** Save your screenshots into `docs/screenshots/` and link them here:

### 🖼️ Screenshot 1: Successful Docker Compose Build
<!-- Replace with your screenshot path once taken -->
![Successful Docker Compose Build](./screenshots/14-docker-compose-build-success.png)
*Caption: Terminal displaying successful container compilation after resolving the npm ci lockfile requirement.*

### 🖼️ Screenshot 2: All Local Containers Running Healthy
<!-- Replace with your screenshot path once taken -->
![Docker Compose PS](./screenshots/15-docker-compose-ps-healthy.png)
*Caption: Terminal running docker compose ps showing postgres (healthy), backend, and frontend active.*

---

## 🎯 Summary Checklist

- [x] Know the difference between `npm install` and `npm ci`.
- [x] Understand why `version: '3.8'` is deprecated in Compose V2.
- [x] Understand how `docker compose` locates configuration files.
- [x] Know how to fix port collisions and database initialization delays.

You now possess real debugging skills that most beginners struggle with for weeks! 🏆
