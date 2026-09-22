# 🐘 Step 11: Fixing "500 Internal Server Error" on `/api/tasks`

If your frontend shows a **500 Internal Server Error** on `/api/tasks` after deploying to AWS EC2, you have encountered one of the most classic real-world database deployment problems! 🎯

```text
Failed to load resource: the server responded with a status of 500 (Internal Server Error)
/api/tasks:1 Failed to load resource: the server responded with a status of 500 (Internal Server Error)
```

This guide explains **why** it happened and gives you the **exact 30-second fix**! ⏱️✨

---

## 🧐 Why Did This Happen?

1. **Why `/api/health` worked, but `/api/tasks` returned 500:**
   - When you hit `/api/health`, the backend runs `SELECT NOW();`. This tests if PostgreSQL is alive. It returned `status: UP`! 🟢
   - When you hit `/api/tasks`, the backend runs `SELECT * FROM tasks;`.
   - On PostgreSQL, it threw: `ERROR: relation "tasks" does not exist`! 💥
   - Because the `tasks` table was missing, Express caught the database error and responded with **500 (Internal Server Error)**.

2. **Why was the `tasks` table missing on EC2?**
   - PostgreSQL Docker containers only execute scripts placed in `/docker-entrypoint-initdb.d/` **ONCE**—on the very first millisecond when the data directory (`/var/lib/postgresql/data`) is created.
   - If PostgreSQL was launched on EC2 before `init.sql` was copied into `~/devops-app/`, PostgreSQL initialized an empty database and created the volume.
   - Any future container restarts **skip** `init.sql` because the volume is already initialized!

---

## ⚡ Solution 1: Immediate 30-Second Fix on EC2 (No Redeploy Needed!)

You can create the table directly inside your running PostgreSQL container on EC2:

1. Connect to your EC2 instance (via SSH or EC2 Instance Connect in AWS Console).
2. Copy and paste this single command into the EC2 terminal:

```bash
docker exec -i prod_postgres psql -U postgres -d devops_db -c "
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO tasks (title, description, completed) VALUES
('Learn CI/CD Fundamentals', 'Understand Continuous Integration and Deployment.', true),
('Build Docker Containers', 'Create multi-stage Docker builds.', true),
('Deploy to AWS EC2', 'Successfully live in production on AWS EC2!', true);
"
```

3. Refresh your browser at `http://<YOUR-EC2-IP>`:  
   🎉 **The 500 error vanishes and your tasks list loads immediately!**

---

## 🔄 Solution 2: Clean Volume Reset on EC2

If you want PostgreSQL to re-run `init.sql` from scratch:

```bash
cd ~/devops-app

# 1. Stop containers and destroy the old uninitialized database volume
docker compose -f docker-compose.prod.yml down -v

# 2. Make sure init.sql exists in the directory
ls -la init.sql

# 3. Start fresh
docker compose -f docker-compose.prod.yml up -d
```

---

## 🛡️ Solution 3: The Permanent Automated Code Fix (Built-in)

To prevent this from ever happening again, we updated the backend code in `server/src/db.js` and `server/src/app.js`:

1. **Auto-Schema Migration on Server Boot**:
   When the Express server boots up, it executes `CREATE TABLE IF NOT EXISTS tasks (...)` automatically.
2. **Self-Healing Endpoints**:
   If `/api/tasks` is called and PostgreSQL reports `relation "tasks" does not exist`, the backend catches the error, auto-creates the table on the fly, inserts the seed data, and retries the query seamlessly!

Once you commit and push the updated backend:
```bash
git add .
git commit -m "fix(db): add self-healing auto-initialization for tasks table"
git push origin main
```
GitHub Actions will deploy the self-healing container to EC2 automatically! 🚀

---

## 📸 Proof of Work: Screenshots

> [!TIP]
> **Capture your proof of work!** Save your screenshots into `docs/screenshots/` and link them here:

### 🖼️ Screenshot 1: 500 Error Resolved & Tasks Live in Browser
<!-- Replace with your screenshot path once taken -->
![500 Error Resolved](./screenshots/16-db-error-resolved-live-ui.png)
*Caption: Live EC2 application showing tasks retrieved and rendered without 500 Internal Server Error.*

### 🖼️ Screenshot 2: Database Schema & Seed Data Verified
<!-- Replace with your screenshot path once taken -->
![Database Schema Verified](./screenshots/17-db-table-verified.png)
*Caption: EC2 terminal showing psql SELECT query returning seeded tasks records from postgres container.*

