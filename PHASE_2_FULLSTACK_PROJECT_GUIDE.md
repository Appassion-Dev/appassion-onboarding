# Phase 2: Creating Your First Full Stack AI-Assisted Project

After completing Phase 1, you have all the foundational tools installed. Now you'll create your first real full stack project: a React frontend connected to a local Supabase database.

**Estimated Time: 30-45 minutes**

---

## Table of Contents

- [What You'll Build](#what-youll-build)
- [System Requirements](#system-requirements)
- [Using VS Code's Integrated Terminal](#using-vs-codes-integrated-terminal)
- [Step 1: Create the Project Folder](#step-1-create-the-project-folder)
- [Step 2: Initialize Git](#step-2-initialize-git)
- [Step 3: Create a .gitignore](#step-3-create-a-gitignore)
- [Step 4: Create the React + Vite Frontend](#step-4-create-the-react--vite-frontend)
  - [Step 4.1: Scaffold the Frontend](#step-41-scaffold-the-frontend)
- [Step 5: Set Up Local Supabase](#step-5-set-up-local-supabase)
  - [Step 5.1: Initialize Supabase](#step-51-initialize-supabase)
  - [Step 5.2: Start Local Supabase](#step-52-start-local-supabase)
  - [Step 5.3: Install the Supabase Agent Skill](#step-53-install-the-supabase-agent-skill)
  - [Step 5.4: Generate the Schema with Copilot](#step-54-generate-the-schema-with-copilot)
  - [Step 5.5: Generate Seed Data with Copilot](#step-55-generate-seed-data-with-copilot)
- [Step 6: Connect Frontend to Supabase](#step-6-connect-frontend-to-supabase)
  - [Step 6.1: Install the React Agent Skill](#step-61-install-the-react-agent-skill)
  - [Step 6.2: Create the Environment Variables File](#step-62-create-the-environment-variables-file)
  - [Step 6.3: Generate TypeScript Types from the Database](#step-63-generate-typescript-types-from-the-database)
  - [Step 6.4: Generate the Frontend with Copilot](#step-64-generate-the-frontend-with-copilot)
- [Step 7: Start the Frontend](#step-7-start-the-frontend)
- [Step 8: Create a README](#step-8-create-a-readme)
- [Step 9: Initial Commit & Publish to GitHub](#step-9-initial-commit--publish-to-github)
- [Step 10: Deploy to Production](#step-10-deploy-to-production)
  - [Step 10.1: Push Schema to Supabase Cloud](#step-101-push-schema-to-supabase-cloud)
  - [Step 10.2: Get Your Cloud Credentials](#step-102-get-your-cloud-credentials)
  - [Step 10.3: Deploy Frontend to Vercel](#step-103-deploy-frontend-to-vercel)

---

## What You'll Build

By the end of this phase, you'll have:
- **React + Vite frontend** running at `localhost:5173`
- **Local Supabase database** running via Docker
- **Frontend connected to backend** via the Supabase JS client
- **GitHub Copilot configured** for your project
- **Project published** to GitHub

**Project structure:**
```
my-first-fullstack/
├── frontend/           # React + Vite app
│   ├── src/
│   ├── package.json
│   └── .env.local      # local Supabase credentials (never committed)
├── supabase/           # Created automatically by `supabase init`
│   ├── config.toml
│   ├── migrations/
│   └── functions/
├── .gitignore
└── README.md
```

---

## System Requirements

**Prerequisites**: Complete Phase 1 installation guide
- Git, GitHub account, VS Code, Node.js, npm installed
- GitHub Copilot subscription active
- Supabase account created (from Phase 1, Step 7)
- Docker Desktop running

---

## Using VS Code's Integrated Terminal

All shell commands in this guide run in VS Code's **integrated terminal** — a PowerShell prompt built directly into the editor. This keeps you in one window with code and terminal side by side.

**To open the integrated terminal:**
- Press **Ctrl+`** (backtick — the key below Escape)
- Or go to **Terminal → New Terminal** in the menu bar

VS Code opens a PowerShell terminal pre-set to your project's root folder. **Run all commands from this terminal unless a step says otherwise.**

> **Tip**: Open a second terminal pane with the **+** button in the terminal panel. You'll need two terminals in Step 8 — one for Supabase, one for the frontend dev server.

---

## Step 1: Create the Project Folder

Open PowerShell (Start menu → type `powershell`) and run:

```powershell
mkdir C:\Projects\my-first-fullstack
cd C:\Projects\my-first-fullstack
code .
```

This creates the folder and opens it in VS Code. From this point, use the **integrated terminal** (`Ctrl+``) for all commands.

> **VS Code GUI alternative**: **File → Open Folder** → navigate to `C:\Projects` → **New Folder** → `my-first-fullstack` → **Select Folder**.

---

## Step 2: Initialize Git

In the integrated terminal:

```powershell
git init
```

> **VS Code GUI alternative**: Click **Source Control** (`Ctrl+Shift+G`) → **"Initialize Repository"**.

---

## Step 3: Create a .gitignore

This is the first file you create — before any code — so nothing sensitive ever accidentally gets committed.

In the terminal:

```powershell
New-Item .gitignore
code .gitignore
```

Paste the following and save (`Ctrl+S`):

```
# Frontend dependencies (re-installed via npm install)
frontend/node_modules/

# Environment variables (contain API keys — never commit)
.env
.env.local
.env*.local

# MCP config (contains API tokens — never commit)
.vscode/mcp.json

# Build output
frontend/dist/

# Installed Packages
frontend/node_modules/

# Supabase local runtime data
supabase/.branches/
supabase/.temp/

# OS files
.DS_Store
Thumbs.db
```

---

## Step 4: Create the React + Vite Frontend

### Step 4.1: Scaffold the Frontend

In the terminal:

```powershell
npm create vite@latest frontend -- --template react
```
When prompted, select yes:
```powershell
◇  Install with npm and start now?
│  Yes
```

Vite scaffolds the app, installs dependencies, and starts the dev server automatically.

Verify it runs by clicking on the link `http://localhost:5173` with `Ctrl + left click`. 
Or manually type `http://localhost:5173` in your browser.
You should see the default Vite + React page. 
![Vite dev server started](screenshots/vite-started.png)
  
Press `Ctrl+C` in the shell to stop it when done.

---

## Step 5: Set Up Local Supabase

### Step 5.1: Initialize Supabase

After pressing `Ctrl+C` to stop the Vite dev server, your terminal is still inside the `frontend/` folder. Navigate back to the project root first:

```powershell
cd ..
```

Confirm you're in the right place — the prompt should show `C:\Projects\my-first-fullstack>`. Then run:

```powershell
supabase init
```

This creates a `supabase/` folder with:
- `config.toml` — local Supabase configuration
- `migrations/` — database schema files
- `functions/` — serverless edge functions

### Step 5.2: Start Local Supabase

Make sure Docker Desktop is running, then:

```powershell
supabase start
```

This pulls Docker images on first run (may take a few minutes), then starts a full local Supabase stack. When complete, you'll see output like:

![Supabase Started](screenshots\supabase-started.png)

**Copy the `Publishable` key** — you'll need it in the next step.

> **Note**: Supabase Studio (local admin UI) is now running at `http://localhost:54323`.

You can save the whole output to a text file for future reference.

### Step 5.3: Install the Supabase Agent Skill

From this point we'll use **agentic development** — rather than writing SQL by hand, we ask GitHub Copilot to generate it using a skill that knows Supabase Postgres best practices.

In the terminal, install the skill into your project:

```powershell
npx skills add supabase/agent-skills
```

The CLI will prompt you twice. Answer as follows:

**1. Select your agent — choose Claude Code:**
```
◆  Select agents to install for
│  ── Additional agents ─────────────────────────────
│
│   ○ Augment (.augment/skills)
│ ❯ ● Claude Code (.claude/skills)
│
│  ↑↓ move, space select, enter confirm
```
Press `Enter` to skip and again to confirm.

**2. Select installation scope — choose Project:**
```
◆  Installation scope
│  ● Project (Install in current directory (committed with your project))
│  ○ Global
```
**Project** should already be selected. Press `Enter` to confirm.

> **Why Project?** Installing at the project level commits the skill rules alongside your code in `.agents/skills/`. Every developer who clones the repo gets the same Copilot behavior automatically. Global installs only affect your machine.

This installs the [supabase-postgres-best-practices](https://github.com/supabase/agent-skills) skill locally into `.agents /skills/`. Copilot will automatically reference it when working on database-related tasks in this project.

> **What is a skill?** A skill is a set of rules and patterns that Copilot loads before generating code. The Supabase skill teaches Copilot things like: use `(select auth.uid())` in RLS policies (not bare `auth.uid()`), always index foreign key columns, prefer `bigint identity` over `serial`, use `timestamptz` not `timestamp`, etc.

### Step 5.4: Generate the Schema with Copilot

Before writing any code, we'll define what we're building: a **notes app** where each user has their own private notes. Users can create, read, update, and delete their own notes — but cannot see anyone else's. This is a common real-world pattern: a personal workspace scoped to the authenticated user.

The data model is simple:
- `users` — one row per authenticated user (linked to Supabase Auth)
- `notes` — many notes per user, each with a title and content

Row Level Security (RLS) enforces the privacy at the database level, so even if the frontend has a bug, users can never access each other's data.

Open GitHub Copilot Chat (`Ctrl+Alt+I`) and type this prompt exactly:

```
/supabase-postgres-best-practices create a test project schema, include users, notes tables. each user will have multiple notes. add rls policies for users to be able to edit their own notes only.
```

Copilot will generate a migration file in `supabase/migrations/` with:
- A `users` table extending `auth.users`
- A `notes` table with a foreign key to `users`
- An index on `notes.user_id` (required for fast JOINs and RLS)
- Separate `SELECT`, `INSERT`, `UPDATE`, and `DELETE` RLS policies using the performance-safe `(select auth.uid())` pattern

Once generated, apply the migration to your local database:

```powershell
supabase db reset
```

> **`db reset`** recreates the local database from scratch and runs all migrations in `supabase/migrations/` in order. Safe to use during development — your local data will be wiped and rebuilt from the schema.

### Step 5.5: Generate Seed Data with Copilot

The schema is set up, but the database is empty. To test the frontend without having to sign up and create notes manually, we'll seed the database with a few test users and notes.

Open GitHub Copilot Chat (`Ctrl+Alt+I`) and type this prompt:

```
/supabase-postgres-best-practices generate supabase/seed.sql for a notes app
```

Copilot should generate `supabase/seed.sql` with:
- `INSERT` statements into `auth.users` for 3 test users with fixed UUIDs and hashed passwords
- `UPDATE` statements on `public.users` to set `full_name` (the trigger creates the row, this fills in the rest)
- Several notes per user with realistic content and varied timestamps

Review the file before running it. Then apply it to your local database:

```powershell
supabase db reset
```

`supabase db reset` automatically runs `supabase/seed.sql` if the file exists — no extra flag needed. You now have real data to look at when you open the frontend.

> **Tip**: Seed data is for local development only. `supabase/seed.sql` is committed to git so every developer on the team starts with the same test data. **Never** run `supabase db reset` against a production database.

---

## Step 6: Connect Frontend to Supabase

### Step 6.1: Install the React Agent Skill

Just like we used a skill to generate the database schema, we'll use a skill to generate the frontend — one that knows React and Vercel best practices.

In the terminal:

```powershell
npx skills add vercel-labs/agent-skills
```

The CLI will prompt you twice. Answer the same way as before:

**1. Select your agent — skip additional agents:**
```
◆  Select agents to install for
│  ── Additional agents ─────────────────────────────
│
│   ○ Augment (.augment/skills)
│ ❯ ○ Claude Code (.claude/skills)
│
│  ↑↓ move, space select, enter confirm
```
Press `Enter` to skip — no additional agents need to be selected.

**2. Select installation scope — choose Project:**
```
◆  Installation scope
│  ● Project (Install in current directory (committed with your project))
│  ○ Global
```
Press `Enter` to confirm **Project**.

This installs the `vercel-react-best-practices` skill into `.claude/skills/`. Copilot will use it to generate idiomatic React code with correct patterns for data fetching, loading states, error handling, and component structure.

### Step 6.2: Create the Environment Variables File

Credentials are instance-specific — they can't be generated by Copilot. You need to get them from your running Supabase instance.

**Where to find your `Publishable` key:**

**Option A — From the `supabase start` output** (Step 5.2):
If you saved it, copy it. It's labelled `Publishable` under **Authentication Keys** in the output.

**Option B — Run `supabase status`** (if you've already closed that terminal):
```powershell
supabase status
```
This reprints the full connection info including the `Publishable` key.

**Option C — Supabase Studio**:
Open `http://localhost:54323` → **Project Settings** (gear icon) → **API** → copy the `Publishable` key under **Authentication Keys**.

---

Once you have the key, create the file:

```powershell
New-Item frontend\.env.local
code frontend\.env.local
```

Paste the following, replacing the placeholder with your actual `Publishable` key:

```
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=paste_your_publishable_key_here
```

Save with `Ctrl+S`.

> **Security**: `.env.local` is already in your `.gitignore`. This file is never committed — every developer creates their own from their local `supabase start` output.

### Step 6.3: Generate TypeScript Types from the Database

Supabase can introspect your local database and generate a TypeScript types file that mirrors your schema exactly. This gives Copilot (and you) full type safety when writing frontend code — autocompletion on table names, column names, and return types.

In the terminal from the /supabase folder:

```powershell
supabase gen types typescript --local > ../frontend/src/database.types.ts
```

This reads the live schema from your running local Supabase instance and writes `frontend/src/database.types.ts` with a complete type definition for every table, view, and function.

> **Re-run this command** whenever you change the schema (add a column, create a table, etc.) to keep the types in sync with the database.

> **Tip**: Add this to your Quick Reference — it's a command you'll run often during development.

### Step 6.4: Generate the Frontend with Copilot

This step uses a two-phase agentic workflow: **Plan first, then implement**. Planning lets you review what Copilot intends to build before it touches any files.

---

#### Phase 1 — Plan

Switch Copilot Chat to **Plan mode**: click the mode dropdown in the chat panel and select **Plan** (or press `Ctrl+Alt+I` to open chat, then change the mode selector from "Ask" to "Plan").

Type this prompt:

```
/vercel-react-best-practices Build a notes app frontend with Supabase Auth. Users should be able to sign up, log in, and manage their own private notes.
Use generated database types. Use existing .env file. Update readme with detailed explanations of what has been created wnd why.
```

Copilot will respond with a **plan**: a list of files it intends to create or modify, the component structure, and the data flow. **Read through it carefully.** If anything is missing or wrong, ask Copilot to revise the plan before proceeding.

---

#### Phase 2 — Implement

Once you're satisfied with the plan, switch to **Agent mode**: click the mode selector and choose **Agent**, or click the **"Implement"** button that appears below the plan in the chat.

Copilot will create and write all the files automatically:
- `frontend/src/supabase.js` — Supabase client
- `frontend/src/database.types.ts` — already generated in Step 6.3
- `frontend/src/pages/AuthPage.jsx` — sign-up / login form
- `frontend/src/pages/NotesPage.jsx` — notes list, add form, delete
- `frontend/src/App.jsx` — routing and auth guard

Review created files and study readme.md - it should explain the logic behind each change. 

---

## Step 7: Start the Frontend

Supabase is still running from Step 5. All you need to do is start the React dev server.

Your terminal is currently inside the `supabase/` folder. Navigate to the frontend:

```powershell
cd ..\frontend
npm run dev
```

Open `http://localhost:5173`. You'll land on the sign-up / login page.

**Create a test account:**
1. Click **Sign up**
2. Enter an email and password (e.g. `test@example.com` / `password123`)
3. You'll be redirected to the notes page — logged in and ready

**Try the app:**
- Add a note using the form
- Delete a note
- Sign out and sign back in — your notes persist in the local database

Your frontend is now reading and writing live data from local Supabase.

---

## Step 8: Create a README

Press `Ctrl+C` to stop the dev server. Your terminal is inside `frontend/` — navigate back to the project root:

```powershell
cd ..
```

Open Copilot Chat (`Ctrl+Alt+I`) in **Agent mode** and type:

```
Create a README.md for this project. It should explain what the app does, the tech stack, the folder structure, and how to run it locally from scratch. Include all the commands needed — starting Supabase, generating types, and starting the frontend. Keep it practical and developer-focused.
```

Copilot will generate `README.md` based on your actual project files. Review it and ask for adjustments if needed.

---

## Step 9: Initial Commit & Publish to GitHub

Choose the path that suits you — both get the same result.

---

### Path A: Terminal only

Make sure you're in the project root. The prompt should show `C:\Projects\my-first-fullstack>`. If not:

```powershell
cd C:\Projects\my-first-fullstack
```

Stage and commit:

```powershell
git add .
git commit -m "Initial commit: React + Vite frontend with Supabase backend"
```

Create the GitHub repo and push in one command:

```powershell
gh repo create my-first-fullstack --public --source=. --remote=origin --push
```

---

### Path B: VS Code UI only

**Commit using VS Code:**
1. Click **Source Control** (`Ctrl+Shift+G`) in the sidebar
2. Click **+** next to **Changes** to stage all files
3. Type `Initial commit: React + Vite frontend with Supabase backend` in the message box
4. Click **✓ Commit**

**Publish to GitHub:**
1. In the Source Control panel, click **"Publish Branch"**
2. VS Code will prompt you to sign in to GitHub if not already signed in
3. Choose **Public** when asked for visibility
4. VS Code creates the repository on GitHub and pushes automatically — no terminal needed

---

**Verify**: Open `https://github.com/your-username/my-first-fullstack` in your browser.

---

## Step 10: Deploy to Production

Your app runs locally — now ship it. The frontend goes to Vercel, the database goes to Supabase Cloud.

---

### Step 10.1: Push Schema to Supabase Cloud

**Create a Supabase Cloud project:**
1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **New project**
3. Choose a name (e.g. `my-first-fullstack`) and a strong database password — **save this password**, you'll need it
4. Select a region close to you
5. Click **Create new project** and wait ~2 minutes for it to provision

**Link your local project to the cloud project:**

In the terminal (from the project root):

```powershell
supabase login
supabase link
```

`supabase link` will prompt you to select your project from the list. Select `my-first-fullstack`.

**Push your migrations:**

```powershell
supabase db push
```

This runs all your migration files against the cloud database. Your schema — tables, RLS policies, indexes — is now live in production.

> **Note**: `supabase db push` does not push seed data. Seed data is for local development only.

---

### Step 10.2: Get Your Cloud Credentials

You need the production API URL and `Publishable` key for the Vercel environment variables.

1. Go to your Supabase Cloud project dashboard
2. Click **Project Settings** (gear icon) → **Data API**
3. Copy:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **Publishable** key under **Project API keys**

Keep these handy — you'll paste them into Vercel in the next step.

---

### Step 10.3: Deploy Frontend to Vercel

**Import your GitHub repo:**
1. Go to [vercel.com](https://vercel.com) and sign in with GitHub
2. Click **Add New → Project**
3. Find `my-first-fullstack` in the list and click **Import**
4. Set the **Root Directory** to `frontend`
5. Under **Environment Variables**, add:
   - `VITE_SUPABASE_URL` → your Supabase Cloud Project URL
   - `VITE_SUPABASE_ANON_KEY` → your Supabase Cloud `Publishable` key
6. Click **Deploy**

Vercel builds your React app and gives you a live URL (e.g. `https://my-first-fullstack.vercel.app`).

> **Tip**: Every time you push to the `main` branch on GitHub, Vercel rebuilds and redeploys automatically.

---

**Verify**: Open your Vercel URL in the browser, sign up with a new account, create a note — it's running on real infrastructure.

---

### Step 10.4: Deploy Agentically with MCP (Optional)

Instead of clicking through dashboards, you can deploy entirely through Copilot Agent mode using MCP servers — Copilot talks directly to Supabase and Vercel on your behalf.

**Connect Supabase MCP:**

The Supabase MCP server is hosted at `https://mcp.supabase.com/mcp` and handles authentication automatically via OAuth (no tokens needed). 
Create a file in the project root `.vscode/settings.json`, add:

```json
"mcpServers": {
  "supabase": {
    "url": "https://mcp.supabase.com/mcp?project_ref=your_project_ref"
  }
}
```

Replace `your_project_ref` with your actual Supabase project reference (found in your Supabase Cloud project URL: `https://your_project_ref.supabase.co`).

> **For local development**: You can also use `http://localhost:54321/mcp` when running `supabase start` — this connects Copilot directly to your local Supabase instance.

> **Security**: The MCP server is read-only by default. If you need write access for deployments, you'll be prompted to authorize via browser login.

Reload VS Code (`Ctrl+Shift+P` → "Developer: Reload Window") to activate MCP.

**Now deploy with a single agent prompt:**

Open Copilot Chat (`Ctrl+Alt+I`) in **Agent mode** and type:

```
Use the Supabase MCP tools to help me deploy: Create a new Supabase project called "my-first-fullstack", list the tables in the database to confirm the schema pushed correctly, then tell me the project URL and anon key I need for Vercel environment variables.
```

Copilot will use the Supabase MCP server to query the database and retrieve your credentials. Copy the credentials from the chat output, then deploy to Vercel:

```
Deploy this project to Vercel. The root directory is `frontend`. Set these environment variables:
VITE_SUPABASE_URL=<url from previous step>
VITE_SUPABASE_ANON_KEY=<key from previous step>
```

> **Available MCP tools**: The Supabase MCP server provides tools for listing tables, migrations, running SQL, generating TypeScript types, deploying Edge Functions, managing projects, and more. See [supabase.com/docs/guides/getting-started/mcp](https://supabase.com/docs/guides/getting-started/mcp) for the full list.

The agentic path is faster for repeat deployments and gives you a prompt history you can reuse across projects.

---

## Quick Reference

```powershell
# Start local development
supabase start                      # Start Supabase (from project root)
cd frontend ; npm run dev           # Start React dev server

# Stop
supabase stop                       # Stop Supabase
# Ctrl+C in the frontend terminal

# Git
git status
git add .
git commit -m "message"
git push

# Database
supabase migration new <name>      # Create a new migration
supabase db push                   # Push migrations to Supabase Cloud
supabase db reset                  # Reset local DB to migrations
supabase gen types typescript --local > frontend/src/database.types.ts  # Regenerate types after schema changes

# Frontend
cd frontend
npm install                        # Install dependencies
npm run build                      # Build for production
```

---

## Troubleshooting

### `supabase start` fails
Make sure Docker Desktop is open and running before running `supabase start`.

### Frontend shows blank page or error after `npm run dev`
Check that `frontend/.env.local` exists and contains the correct `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` values from the `supabase start` output (use the `Publishable` key).

### Port 5173 already in use
```powershell
cd frontend
npm run dev -- --port 5174
```

### Can't push to GitHub
Make sure you authenticated GitHub CLI in Phase 1:
```powershell
gh auth status
```

---

## Next: Deploying to Production

See **Phase 3: Deploying Full Stack to the Cloud** for:
- Deploying the frontend to Vercel
- Linking and pushing your local Supabase schema to Supabase Cloud
- Setting up environment variables in production
- CI/CD pipeline

---

**Phase 2 Complete!**

You now have a working full stack app running locally — React reads live data from a local PostgreSQL database via Supabase. Ready to ship it? Continue to Phase 3.

---

**Last Updated**: March 2026
**Version**: 1.0-Windows

---

## System Requirements

**Prerequisites**: Complete Phase 1 installation guide
- Git, GitHub account, VS Code, Node.js, npm installed
- GitHub Copilot subscription active
- Supabase account created (from Phase 1, Step 7)

---

## Using VS Code's Integrated Terminal

All shell commands in this guide run in VS Code's **integrated terminal** — a PowerShell prompt built directly into the editor. This keeps you in one window with code and terminal side by side.

**To open the integrated terminal:**
- Press **Ctrl+`** (backtick — the key below Escape)
- Or go to **Terminal → New Terminal** in the menu bar

VS Code opens a PowerShell terminal pre-set to your project's root folder. **Run all commands from this terminal unless a step says otherwise.**

> **Tip**: Split the terminal into two panes with `Ctrl+Shift+5`. You'll need this in Step 12 to run Supabase and the frontend dev server at the same time.

---

## Understanding Monorepos

A **monorepo** (monolithic repository) is a single Git repository that contains multiple related projects/packages. Instead of separate repos for frontend, backend, database code, etc., they live together but stay logically separated.

**Benefits**:
- **Single source of truth** — one repo for the entire application
- **Unified dependencies** — shared packages managed in one place
- **Atomic commits** — frontend + backend changes in a single commit
- **Easier refactoring** — change shared code once, updates everywhere
- **Simplified CI/CD** — one pipeline handles building everything

**Our structure** (using npm workspaces):
```
my-first-fullstack/
├── package.json (root workspace config)
├── apps/
│   ├── frontend/          # React + Vite (deployed to Vercel)
│   │   ├── package.json
│   │   ├── src/
│   │   └── vite.config.js
│   └── backend/           # Supabase functions & DB schema
│       ├── package.json
│       └── supabase/
├── packages/              # Shared code
│   └── types/            # Shared TypeScript types
└── .gitignore
```

---

## Step 1: Create the Monorepo Root Folder

Open PowerShell (Start menu → type `powershell`) and run:

```powershell
mkdir C:\Projects\my-first-fullstack
cd C:\Projects\my-first-fullstack
code .
```

This creates the folder and opens it directly in VS Code. VS Code will reload with the new workspace.

> **VS Code GUI alternative**: Open VS Code → **File → Open Folder** → navigate to `C:\Projects` → **New Folder** → name it `my-first-fullstack` → **Select Folder**.

---

## Step 2: Initialize Git & Create Root Package.json

### Step 2.1: Initialize Git

Open the integrated terminal (`Ctrl+``) and run:

```powershell
git init
```

> **VS Code GUI alternative**: Click **Source Control** (`Ctrl+Shift+G`) → **"Initialize Repository"**.

### Step 2.2: Create Root package.json with Workspaces

In the terminal:

```powershell
New-Item package.json
code package.json
```

Paste the following into the file:

```json
{
  "name": "my-first-fullstack",
  "version": "1.0.0",
  "description": "A full stack project with React frontend and Supabase backend",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ]
}
```

This tells npm to treat `apps/` and `packages/` folders as separate workspaces (projects) that share dependencies.

Save with `Ctrl+S`.

> **VS Code GUI alternative**: In **Explorer** (`Ctrl+Shift+E`), click the **New File** icon → name it `package.json` → paste content → save.

---

## Step 3: Create the Frontend (React + Vite)

### Step 3.1: Create the Frontend Folder Structure

In the terminal:

```powershell
mkdir apps\frontend
```

> **VS Code GUI alternative**: Right-click in **Explorer** → **New Folder** → `apps`, then inside `apps/` → **New Folder** → `frontend`.

### Step 3.2: Initialize React + Vite

In the terminal (from your project root):

```powershell
npm create vite@latest apps/frontend -- --template react
```

When prompted, confirm the project name and framework. Then install dependencies:

```powershell
npm install
```

This scaffolds a complete React + Vite app inside `apps/frontend/`.

### Step 3.3: Update Frontend package.json

The Vite template creates its own `package.json`. Keep it as-is — it already has the right name (`frontend`) for the workspace.

---

## Step 4: Create the Backend Integration Folder

The backend in this setup is primarily Supabase functions + database schema. We'll create a folder for managing those.

### Step 4.1: Create Backend Folder Structure

In the terminal:

```powershell
mkdir apps\backend\supabase\functions
mkdir apps\backend\supabase\migrations
```

PowerShell creates all intermediate folders automatically.

> **VS Code GUI alternative**: Right-click `apps/` in Explorer → **New Folder** → `backend`, then create `supabase/functions/` and `supabase/migrations/` inside it.

### Step 4.2: Create Backend package.json

In the terminal:

```powershell
New-Item apps\backend\package.json
code apps\backend\package.json
```

Paste the following and save (`Ctrl+S`):

```json
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Supabase backend for full stack project",
  "scripts": {
    "start": "supabase start",
    "stop": "supabase stop",
    "studio": "supabase studio url",
    "migrations": "supabase migrations list"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.38.0"
  }
}
```

This package doesn't have many dependencies, but we add the Supabase JS client for future use.

---

## Step 5: Create Shared Types Package

Monorepos shine when frontend and backend share types. Let's create a shared types package.

### Step 5.1: Create Packages Folder Structure

```
packages/
└── types/
    ├── package.json
    └── index.ts
```

In the terminal:

```powershell
mkdir packages\types
```

> **VS Code GUI alternative**: Right-click the Explorer root → **New Folder** → `packages`, then inside `packages/` → **New Folder** → `types`.

### Step 5.2: Create Types package.json

In the terminal:

```powershell
New-Item packages\types\package.json
code packages\types\package.json
```

Paste the following and save:

```json
{
  "name": "@my-first-fullstack/types",
  "version": "1.0.0",
  "description": "Shared TypeScript types",
  "main": "index.ts",
  "private": true
}
```

### Step 5.3: Add Sample Types

In the terminal:

```powershell
New-Item packages\types\index.ts
code packages\types\index.ts
```

Paste the following and save:

```typescript
// User types shared between frontend and backend
export interface User {
  id: string;
  email: string;
  full_name: string;
  created_at: string;
}

export interface Profile {
  user_id: string;
  avatar_url?: string;
  bio?: string;
}

export type Message = {
  id: string;
  content: string;
  user_id: string;
  created_at: string;
};
```

These types can be imported in both frontend and backend code.

---

## Step 6: Root .gitignore

In the terminal:

```powershell
New-Item .gitignore
code .gitignore
```

Paste the following and save:

```
# Dependencies
node_modules/

# Environment variables
.env
.env.local
.env*.local

# MCP config (contains API tokens)
.vscode/mcp.json

# Build outputs
dist/
build/
.next/

# Supabase local
.supabase/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
```

---

## Step 7: Install Root Dependencies

Back to PowerShell at your project root:

```powershell
npm install
```

npm reads `package.json` and the `workspaces` config, then installs dependencies for all three packages (`apps/frontend`, `apps/backend`, `packages/types`).

---

## Step 8: Update Frontend to Use Shared Types

### Step 8.1: Update Frontend package.json

Open the file in the terminal:

```powershell
code apps\frontend\package.json
```

Find this section:
```json
"dependencies": {
  "react": "^18.2.0",
  "react-dom": "^18.2.0"
}
```

Add the shared types:
```json
"dependencies": {
  "react": "^18.2.0",
  "react-dom": "^18.2.0",
  "@my-first-fullstack/types": "workspace:*"
}
```

The `workspace:*` tells npm to use the local version from `packages/types/`.

### Step 8.2: Update Frontend App Component

Open the file in the terminal:

```powershell
code apps\frontend\src\App.jsx
```

Replace its contents with:

```jsx
import { User } from '@my-first-fullstack/types';
import './App.css';

function App() {
  // Example: You can now use shared types here
  const currentUser: User = {
    id: "123",
    email: "user@example.com",
    full_name: "John Doe",
    created_at: new Date().toISOString(),
  };

  return (
    <div className="App">
      <h1>Welcome, {currentUser.full_name}!</h1>
      <p>This is your full stack project.</p>
    </div>
  );
}

export default App;
```

---

## Step 9: Set Up Local Supabase

### Step 9.1: Initialize Supabase Locally

In PowerShell at your project root:

```powershell
supabase init
```

This creates a `supabase/` folder at your project root with:
- `config.toml` — local config
- `migrations/` — database migration files
- `functions/` — serverless functions

### Step 9.2: Start Local Supabase

```powershell
supabase start
```

This will:
1. Download Supabase Docker images (first run only)
2. Start PostgreSQL locally
3. Start Supabase Studio (local admin UI)
4. Print connection details

You'll see output like:
```
Started supabase local development server.

API URL: http://localhost:54321
ANON_KEY: eyJ...
SERVICE_ROLE_KEY: eyJ...
```

### Step 9.3: Create a Sample Table

Supabase Studio is now running at `http://localhost:54321`. Open it and:

1. Click **SQL Editor** in the left sidebar
2. Click **New Query**
3. Paste:

```sql
CREATE TABLE profiles (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES auth.users(id),
  full_name text,
  avatar_url text,
  bio text,
  created_at timestamp DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = user_id);
```

4. Click **Run**

---

## Step 10: Create Root README

In the terminal:

```powershell
New-Item README.md
code README.md
```

Paste in the following starter template and save:

```markdown
# my-first-fullstack

A full stack web application built with React + Vite (frontend), Supabase (backend), and deployed to Vercel + Supabase Cloud.

## Stack

- **Frontend**: React 18, TypeScript, Vite, CSS Modules
- **Backend**: Supabase PostgreSQL
- **Deployment**: Vercel (frontend), Supabase Cloud (backend)
- **Monorepo**: npm workspaces

## Project Structure

```
my-first-fullstack/
├── apps/
│   ├── frontend/       # React + Vite app
│   └── backend/        # Supabase configuration
├── packages/
│   └── types/          # Shared TypeScript types
└── supabase/           # Local Supabase config
```

## Getting Started

### Prerequisites
- Node.js 18+
- Supabase CLI
- Docker (for local Supabase)

### Install Dependencies

```bash
npm install
```

### Start Local Development

**Terminal 1 — Start local Supabase:**
```bash
supabase start
```

**Terminal 2 — Start frontend dev server:**
```bash
cd apps/frontend
npm run dev
```

The frontend will be available at `http://localhost:5173`.

### Stop Local Supabase

```bash
supabase stop
```

## Environment Variables

Create `.env.local` in `apps/frontend/`:

```
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=<your_anon_key_from_supabase_start>
```

(Get these from the `supabase start` output)

## Shared Types

The `packages/types/` package contains shared TypeScript types used by frontend and backend. Update these types here and they're automatically available in both apps.

```typescript
// apps/frontend/src/App.jsx
import { User, Profile } from '@my-first-fullstack/types';
```

## Deploying

### Frontend to Vercel

```bash
cd apps/frontend
vercel
```

### Backend to Supabase Cloud

1. [Create a Supabase project](https://supabase.com/dashboard) on the cloud
2. Link this project:

```bash
supabase link --project-ref your_project_ref
```

3. Push migrations:

```bash
supabase db push
```

## Next Steps

- [ ] Add authentication with Supabase Auth
- [ ] Build data fetching layer in frontend
- [ ] Create Supabase functions for business logic
- [ ] Set up CI/CD pipeline
- [ ] Deploy to production
```

---

## Step 11: Initial Commit

In the terminal:

```powershell
git add .
git commit -m "Initial commit: monorepo structure with React frontend and Supabase backend"
```

> **VS Code GUI alternative**: Open **Source Control** (`Ctrl+Shift+G`) → click **+** next to **Changes** to stage all → type the commit message → click **✓ Commit**.

---

## Step 12: Local Development Workflow

Now you have a working local setup. Here's how to develop:

### Running Everything Locally

**Terminal 1 — Supabase backend:**
```powershell
supabase start
# Prints:
# API URL: http://localhost:54321
# ANON_KEY: eyJ...
```

**Terminal 2 — React frontend:**
```powershell
cd apps/frontend
npm run dev
# Opens http://localhost:5173
```

### Connecting Frontend to Local Backend

Create `apps/frontend/.env.local`:

```
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=<paste_anon_key_from_terminal_1>
```

Update `apps/frontend/src/App.jsx` to connect to Supabase:

```jsx
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
);

export default function App() {
  // Now you can use supabase.from('profiles').select() etc.
  return <div>Connected to Supabase!</div>;
}
```

---

## Step 13: GitHub Copilot Setup for Full Stack

### Create .github/copilot-instructions.md

In the terminal:

```powershell
mkdir .github
New-Item .github\copilot-instructions.md
code .github\copilot-instructions.md
```

Paste the following and save:

```markdown
# Full Stack Project Instructions

## Stack
- Frontend: React 18, TypeScript, Vite, CSS Modules
- Backend: Supabase PostgreSQL
- Deployment: Vercel (frontend), Supabase Cloud (backend)
- Monorepo: npm workspaces

## Conventions
- Use TypeScript for all new files
- Components go in `apps/frontend/src/components/`
- Database functions in `apps/backend/supabase/functions/`
- Shared types in `packages/types/index.ts`
- Environment variables use `VITE_` prefix (frontend) or are database secrets

## Workspace Development
- Always run `npm install` from root (not individual apps)
- Frontend dev: `cd apps/frontend && npm run dev`
- Backend dev: `supabase start` from root
- When adding shared types, update `packages/types/index.ts`

## Database
- Edit schema in Supabase Studio: `http://localhost:54321`
- Create migrations: `supabase migration new <name>`
- Push to cloud: `supabase db push`
```

### Update MCP Configuration

Create (or update) `.vscode/mcp.json` for this project. In the terminal:

```powershell
mkdir -Force .vscode
New-Item -Force .vscode\mcp.json
code .vscode\mcp.json
```

Paste the following, replacing all placeholder values:

```json
{
  "servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token"
      }
    },
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--supabase-url", "http://localhost:54321",
        "--supabase-key", "eyJ..." 
      ]
    }
  }
}
```

---

## Quick Reference: PowerShell Command Cheat Sheet

Common commands you'll use during development:

```powershell
# Git
git status
git add .
git commit -m "message"
git push
git pull

# Node & npm (from project root)
npm install                    # Install all dependencies
npm run dev                    # Start dev server
npm run build                  # Build for production
npm test                       # Run tests
npm install -g <package>      # Install globally

# Workspace commands (from root)
npm install -w apps/frontend  # Install in specific workspace
npm run dev -w apps/frontend  # Run dev in specific workspace

# VS Code
code .                         # Open current directory
code <file>                    # Open specific file

# Docker
docker ps                      # List running containers
docker ps -a                   # List all containers
docker logs <container-name>   # View container logs

# Supabase (local)
supabase start                 # Start local instance
supabase stop                  # Stop local instance
supabase status                # Check status
supabase migration new <name>  # Create new migration

# Vercel
vercel                         # Deploy (interactive)
vercel env pull                # Pull environment variables
vercel logs                    # View deployment logs
```

---

## Troubleshooting

### "Cannot find module '@my-first-fullstack/types'"

This means npm workspaces weren't properly set up. Try:

```powershell
npm install
```

from the root folder again.

### "Supabase start" fails

Make sure Docker is running. Start Docker Desktop and try again:

```powershell
supabase start
```

### Frontend can't connect to local Supabase

Verify `.env.local` exists in `apps/frontend/` with correct URL and keys from `supabase start` output.

### Port 5173 (Vite) already in use

Kill the process or use a different port:

```powershell
cd apps/frontend
npm run dev -- --port 5174
```

---

## Next: Deploying to Production

See **Phase 3: Deploying Full Stack to the Cloud** for:
- Deploying frontend to Vercel
- Deploying backend (migrations + functions) to Supabase Cloud
- Setting up CI/CD pipeline
- Monitoring and debugging in production

---

**Phase 2 Complete!**

You now have a fully functional monorepo with React frontend and Supabase backend running locally. Ready to move to production? Continue to Phase 3.

---

**Last Updated**: March 2026
**Version**: 1.0-Windows
