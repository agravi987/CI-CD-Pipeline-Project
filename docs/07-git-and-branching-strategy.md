# 🌿 Step 7: Git Branching & Pull Request Workflows

Welcome to Day 7! 🚀
One of the most important lessons in DevOps is understanding that **CI/CD does not exist in a vacuum—it is tied directly to Git!**

In this guide, you will learn how professional software teams use Git branches and Pull Requests to automate deployments safely without breaking production. 🛡️

---

## 🔀 The Real-World Git Workflow (GitHub Flow)

In real companies, developers **NEVER** push directly to `main`.
Instead, they use the **GitHub Flow**:

```
                       [Feature Branch: feature/add-task-filter]
                                  ●───────●───────●
                                 /                 \
                                /                   ▼
  ───●─────────────────────────●───────────────────[PULL REQUEST]──► [MERGE TO MAIN]
   main (v1.0 - Live on AWS)                       🧪 CI Runs Tests     🚀 CD Deploys
                                                   🛡️ Trivy Scans       to AWS EC2!
```

---

## 🪜 Step-by-Step Practice: How to Add a Feature Safely

Let's walk through how you would make a change to this project like a professional engineer:

### 1. Create a New Branch for Your Work
Always start by branching off `main`:
```bash
git checkout main
git pull origin main
git checkout -b feature/update-header-title
```

### 2. Make a Simple Code Change
Open `client/src/App.jsx` and tweak the header:
```jsx
// Change:
<h1>🚀 DevOps CI/CD Pipeline Project</h1>
// To:
<h1>🌟 My First Production CI/CD Pipeline!</h1>
```

### 3. Commit and Push Your Feature Branch
```bash
git add client/src/App.jsx
git commit -m "feat: customize dashboard header title"
git push -u origin feature/update-header-title
```

---

## 🤖 4. Open a Pull Request on GitHub & Watch CI Trigger

1. Go to your GitHub repository in your browser.
2. You will see a yellow banner: **"feature/update-header-title had recent pushes"** $\rightarrow$ Click **Compare & pull request**.
3. Title: `feat: customize dashboard header title`.
4. Click **Create pull request**.

### 🔍 What Happens Now?
- The **CI Pipeline (`ci.yml`)** automatically wakes up! ⏰
- It runs `backend-test`, `frontend-test`, and `security-scan` on your branch.
- GitHub displays a yellow pending dot: `● CI Pipeline in progress...`
- Once tests pass, it turns into a glowing green checkmark: `✅ All checks have passed!`

> [!TIP]
> If a test failed, GitHub would show a red `❌` and protect your `main` branch from broken code!

---

## 🚢 5. Merge the Pull Request & Watch CD Deploy!

1. Click the green **Merge pull request** button $\rightarrow$ **Confirm merge**.
2. Merging into `main` automatically triggers the **CD Pipeline (`cd.yml`)**!
3. Go to the **Actions** tab to watch:
   - Docker Hub receives the new version.
   - EC2 downloads the new container.
   - Containers restart.
   - Health check verifies it's alive!
4. Refresh your browser at `http://<YOUR-EC2-PUBLIC-IP>` $\rightarrow$ You will see your new header live in production! 🎉

---

## 🔒 6. Setting Up Branch Protection Rules (Bonus Pro-Skill!)

How do companies make sure nobody accidentally pushes broken code directly to `main`?
They turn on **Branch Protection**:

1. In your GitHub repo, go to **Settings** $\rightarrow$ **Branches**.
2. Click **Add branch protection rule**.
3. **Branch name pattern**: `main`.
4. Check these 2 boxes:
   - ✅ **Require a pull request before merging**
   - ✅ **Require status checks to pass before merging** (search for `Test Backend API` and `Test Frontend React`).
5. Click **Create**.

Now it is physically impossible for anyone (including you!) to push broken code to `main` without tests passing first! 🏆

---

## ⏭️ Ready for Monitoring & Rollbacks?
Learn how to inspect logs and fix broken releases:  
👉 **[Go to Step 8: 08-monitoring-and-rollback.md](./08-monitoring-and-rollback.md)**
