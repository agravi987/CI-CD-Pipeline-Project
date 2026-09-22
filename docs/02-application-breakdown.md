# ⚛️ Step 2: Application Breakdown & Local Run

In this step, we will explore the **3-Tier Architecture** of our application and run it locally on your computer with a single command! 💻✨

---

## 🏗️ The 3-Tier Architecture Explained

Our project is divided into three distinct layers (tiers) that work in harmony:

```
┌──────────────────────────────────────────────────────────┐
│  Tier 1: ⚛️ Frontend (React 18 + Vite)                    │
│  - User interface where users click buttons & view tasks │
│  - Served ultra-fast by an Nginx web server on Port 80   │
└────────────────────────────┬─────────────────────────────┘
                             │ 🌐 HTTP API Requests (/api/...)
                             ▼
┌──────────────────────────────────────────────────────────┐
│  Tier 2: 🟢 Backend (Express.js REST API)                │
│  - Business logic, authentication & request validation   │
│  - Listens on Port 5000                                  │
│  - Provides live health monitoring at /api/health        │
└────────────────────────────┬─────────────────────────────┘
                             │ 🔍 SQL Queries via pg pool
                             ▼
┌──────────────────────────────────────────────────────────┐
│  Tier 3: 🐘 Database (PostgreSQL 16)                     │
│  - Relational database storing tasks table               │
│  - Listens internally on Port 5432                       │
│  - Auto-initializes schema via init.sql                  │
└──────────────────────────────────────────────────────────┘
```

---

## 📂 Folder Tour: Where Does Everything Live?

Open the `ci-cd-pipeline-app/` folder in your code editor (like VS Code):

```
ci-cd-pipeline-app/
├── ⚛️ client/
│   ├── src/
│   │   ├── App.jsx             # The main UI (Dashboard + Tasks + Live Health)
│   │   ├── index.css           # Modern dark-mode styling
│   │   └── App.test.jsx        # Vitest automated UI test
│   ├── nginx.conf              # Reverse proxy routing /api to Express
│   ├── Dockerfile              # Multi-stage production container build
│   └── package.json
│
├── 🟢 server/
│   ├── src/
│   │   ├── app.js              # Express app, CORS, routes (/api/health, /api/tasks)
│   │   ├── server.js           # Server startup script & graceful shutdown
│   │   └── db.js               # PostgreSQL connection pool
│   ├── tests/
│   │   └── api.test.js         # Jest & Supertest automated API tests
│   ├── Dockerfile              # Secure Alpine container build (non-root user)
│   └── package.json
│
├── 🐘 db/
│   └── init.sql                # SQL commands to create 'tasks' table & initial data
│
├── 🐳 docker-compose.yml       # Starts all 3 tiers locally on your machine
└── ☁️ docker-compose.prod.yml  # Used on AWS EC2 to pull images from Docker Hub
```

---

## 🩺 The Secret Weapon: The `/api/health` Endpoint

Why does every DevOps engineer talk about **Health Checks**?
Because without a health check, you are flying blind! 🙈

If a server crashes or the database connection is lost, you want an automated system to detect it in seconds.

### Let's inspect `server/src/app.js`:
```javascript
app.get('/api/health', async (req, res) => {
  let dbStatus = 'disconnected';
  try {
    // 1. Send a quick test query to PostgreSQL
    const dbRes = await pool.query('SELECT NOW()');
    if (dbRes && dbRes.rows.length > 0) dbStatus = 'connected';
  } catch (err) {
    dbStatus = `error: ${err.message}`;
  }

  const isHealthy = dbStatus === 'connected';

  // 2. Return HTTP 200 (OK) if database responds, or 503 (Error) if it failed
  res.status(isHealthy ? 200 : 503).json({
    status: isHealthy ? 'UP' : 'DEGRADED',
    timestamp: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
    database: dbStatus,
    environment: process.env.NODE_ENV || 'development'
  });
});
```

### When everything is healthy, it returns:
```json
{
  "status": "UP",
  "timestamp": "2026-09-21T23:30:00.000Z",
  "uptimeSeconds": 48,
  "database": "connected",
  "environment": "development"
}
```

> [!TIP]
> In Step 6, our **Continuous Deployment (CD) pipeline** will automatically curl this endpoint after deploying to AWS EC2! If it doesn't return `"status": "UP"`, the pipeline reports a deployment failure! 🚨

---

## 🚀 How to Run the Entire App Locally in 60 Seconds

You don't need to manually install Node or PostgreSQL. **Docker Compose** does all the heavy lifting!

### Step 1: Open Your Terminal
Open PowerShell, Command Prompt, or terminal, and navigate to the project:
```bash
cd "d:\Current Projects\Cloud and DevOps Projects\ci-cd-pipeline-project\ci-cd-pipeline-app"
```

### Step 2: Launch with Docker Compose
Run this single command:
```bash
docker compose up --build
```

### 📺 What Docker Does Behind the Scenes:
1. 📥 Pulls `postgres:16-alpine` and mounts `db/init.sql` to create your database tables.
2. 🔨 Builds the Express API container and connects it to PostgreSQL.
3. 🔨 Builds the React app and configures Nginx on Port 80.
4. 🌐 Creates an internal virtual network called `devops_network` so containers can talk to each other securely!

---

## 🌐 Open Your Browser and Test

Once you see `🚀 DevOps Backend API running on port 5000` in your terminal, open:

| What to Open | URL | What You Should See |
| :--- | :--- | :--- |
| ⚛️ **Frontend UI** | [http://localhost](http://localhost) | The dark-mode dashboard with real-time green health badges and interactive task list! |
| 🩺 **Backend Health API** | [http://localhost:5000/api/health](http://localhost:5000/api/health) | JSON response with `"status": "UP"` and `"database": "connected"` |
| 📋 **Tasks API** | [http://localhost:5000/api/tasks](http://localhost:5000/api/tasks) | JSON array of tasks loaded from PostgreSQL |

### 🛑 How to Stop the App:
Press `Ctrl + C` in your terminal, or run:
```bash
docker compose down
```

---

## 🧪 Testing the Application Locally (Before CI Runs)

In a real job, you should always run tests locally before pushing code to GitHub!

### 1. Test the Backend (Jest & Supertest):
```bash
cd server
npm install
npm test
```
✅ You will see 6 passing tests validating the health check, tasks listing, validation, and error handling!

### 2. Test the Frontend (Vitest):
```bash
cd ../client
npm install
npm test
```
✅ You will see Vitest render the React component and verify that the header and badges display properly!

---

## 📸 Proof of Work: Screenshots

> [!TIP]
> **Capture your proof of work!** Save your screenshots into `docs/screenshots/` and link them here:

### 🖼️ Screenshot 1: Application Running Locally in Browser
<!-- Replace with your screenshot path once taken -->
![Local Application Dashboard](./screenshots/01-local-app-running.png)
*Caption: React Frontend + Express Backend + PostgreSQL running locally at http://localhost with healthy badges.*

### 🖼️ Screenshot 2: Automated Tests Passing in Terminal
<!-- Replace with your screenshot path once taken -->
![Automated Tests Passing](./screenshots/02-local-tests-passing.png)
*Caption: Jest and Supertest test suite passing with 6/6 green tests.*

---

## ⏭️ Ready for Day 3?
Now let's examine the Dockerfiles and see how multi-stage builds work:  
👉 **[Go to Step 3: 03-docker-and-containers.md](./03-docker-and-containers.md)**
