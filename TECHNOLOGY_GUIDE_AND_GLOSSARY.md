# Technology Guide & Glossary

A reference guide to understand the technologies in the AI-Assisted Full Stack Development Framework and how they relate to each other.

---

## Table of Contents
1. [Technology Dependency Map](#technology-dependency-map)
2. [Quick Glossary](#quick-glossary)
3. [How Components Work Together](#how-components-work-together)
4. [Installation Priority](#installation-priority)
5. [Technology Relationships](#technology-relationships)

---

## Technology Dependency Map

```
Your Computer (Windows/macOS/Linux)
│
├─ Git → GitHub (version control foundation)
│   │
│   └─ Enables all collaboration and deployment
│
├─ Node.js → npm (JavaScript runtime and package manager)
│   │
│   ├─ Vite (frontend build tool)
│   ├─ Next.js (full-stack framework)
│   ├─ npm packages (dependencies)
│   │
│   └─ Required by: VS Code extensions, build tools
│
├─ VS Code (IDE)
│   │
│   ├─ GitHub Copilot (AI code assistant) → [GitHub account required]
│   ├─ ESLint (code quality)
│   ├─ Prettier (code formatter)
│   ├─ Docker extension
│   │
│   └─ Integrates with: Git, Node.js, Docker CLI
│
├─ Copilot CLI (terminal AI)
│   │
│   └─ Requires: GitHub account + authentication
│
├─ Docker (optional for local Supabase)
│   │
│   └─ Runs Supabase locally during development
│       (Can skip if using cloud Supabase instance)
│
├─ Supabase (backend + database)
│   │
│   ├─ PostgreSQL database (hosted)
│   ├─ Authentication system
│   ├─ Real-time subscriptions
│   │
│   └─ Required by: Next.js backend code
│
├─ Vercel (deployment)
│   │
│   ├─ Hosts Next.js applications
│   ├─ Connects to: GitHub (auto-deploy on push)
│   ├─ Connects to: Environment variables (Supabase keys)
│   │
│   └─ CLI tool for local testing
│
└─ Agent Skills & MCP Servers
    │
    ├─ Work with: GitHub Copilot
    ├─ Can access: Local files, APIs, databases
    │
    └─ Extend: Copilot's capabilities for your domain
```

---

## Quick Glossary

### Version Control & Collaboration
- **Git**: Version control system that tracks code changes
- **GitHub**: Cloud platform for hosting Git repositories (where your code lives online)
- **Repository**: A Git project folder (contains all code history)
- **Commit**: Snapshot of your code at a point in time (like a save point)
- **Push**: Upload commits from your computer to GitHub
- **Pull**: Download commits from GitHub to your computer
- **Branch**: Parallel version of your code (for features, fixes, experiments)
- **Pull Request (PR)**: Propose changes to the main code; requires review before merging

### Development Environment
- **IDE (Integrated Development Environment)**: Software where you write code (VS Code)
- **Editor**: Text editor for writing code (VS Code is more than this)
- **Terminal/Console**: Command-line interface for running commands
- **Shell**: Command interpreter (PowerShell on Windows, Bash on macOS/Linux)

### AI & Coding Intelligence
- **AI Copilot**: Artificial intelligence that suggests code completions and helps debug
- **Copilot Chat**: Conversational interface with the AI (asks questions, get answers)
- **Copilot CLI**: AI assistance in your terminal (explains commands, suggests fixes)
- **Agent Skills**: Custom instructions that teach Copilot about your domain/conventions
- **MCP (Model Context Protocol) Server**: Extends AI with access to custom APIs/databases

### JavaScript & Runtime
- **Node.js**: JavaScript runtime that runs outside browsers (server-side)
- **npm (Node Package Manager)**: Package manager for JavaScript (installs libraries)
- **Package**: A reusable piece of code (library or tool) that you install via npm
- **package.json**: Configuration file listing your project's dependencies
- **node_modules/**: Folder containing all installed packages (don't commit to Git)

### Frontend Framework & Build Tools
- **Vite**: Lightning-fast frontend build tool and development server
- **Next.js**: React framework that adds backend capabilities (full-stack)
- **React**: JavaScript library for building user interfaces
- **SSR (Server-Side Rendering)**: Render HTML on the backend, then send to browser
- **SSG (Static Site Generation)**: Generate HTML at build time
- **API Route**: Backend endpoint in Next.js (like `/api/users`)

### Backend & Database
- **Backend**: Server-side code that handles business logic, database, authentication
- **Database**: Structured storage system for application data
- **PostgreSQL**: Powerful open-source relational database
- **Supabase**: Backend-as-a-Service (BaaS) providing PostgreSQL + auth + real-time
- **Schema**: Structure of database tables and relationships
- **Query**: Request to retrieve or modify data in database
- **Migration**: Script that changes database structure

### Deployment & Hosting
- **Vercel**: Deployment platform optimized for Next.js and serverless functions
- **Deployment**: Publishing your application to the internet
- **Environment Variables**: Configuration values (API keys, database URLs) that vary by environment
- **CI/CD (Continuous Integration/Continuous Deployment)**: Automated testing and deployment on every push
- **CDN (Content Delivery Network)**: Global network that caches and serves your content fast

### Local Development Tooling
- **Docker**: Tool for running services locally (like databases). Used to run Supabase PostgreSQL during development
- **Docker Compose**: Configuration file that defines how to run multiple services together (used by Supabase CLI)
- **Supabase Local**: Run your PostgreSQL database locally without cloud dependencies

### API & Data Exchange
- **API (Application Programming Interface)**: Set of rules for software to communicate
- **REST API**: Standard way to access data via HTTP (GET, POST, PUT, DELETE)
- **Endpoint**: Specific URL path for an API (e.g., `/api/users`)
- **Request**: Message sent to an API asking for data or action
- **Response**: Message returned by an API with data or status
- **JSON**: Lightweight format for exchanging structured data

### Development Workflow
- **Local Development**: Coding on your machine before deploying
- **Staging**: Test environment that mimics production
- **Production**: Live environment that real users access
- **Environment**: Different configurations for development, staging, production
- **Build**: Process of compiling and optimizing code for deployment
- **Dev Server**: Local server that runs your app during development

---

## How Components Work Together

### A Day in the Life of a Developer

```
9:00 AM - Start Your Morning
┌─ Open VS Code
├─ GitHub Copilot is ready (logged in GitHub account)
├─ Write code with Copilot assistance
└─ Copilot suggests completions, refactorings, documentations

10:00 AM - Testing Locally
┌─ Run dev server via npm: npm run dev
├─ Changes appear instantly (Vite's hot reload)
├─ Test your Next.js app at http://localhost:3000
├─ Make database queries to local Supabase (or via Vercel's Supabase project)
└─ Copilot helps debug errors in the terminal

12:00 PM - Ask Copilot Questions
┌─ Open Copilot Chat in VS Code
├─ Ask: "How do I implement authentication?"
├─ Ask: "What's wrong with this SQL query?"
├─ Ask: "Generate unit tests for this function"
└─ Copilot provides answers with code examples

1:00 PM - Need Help in Terminal?
┌─ Type a command in VS Code terminal
├─ Use Copilot CLI: copilot help
├─ It explains what failed and suggests fixes
└─ Quickly solve environment issues

3:00 PM - Save Your Work
┌─ Git add . (stage all changes)
├─ Git commit -m "Add user authentication" (save snapshot)
├─ Git push (upload to GitHub)
└─ GitHub shows your commit in project history

4:00 PM - Deploy to Production
┌─ Your push to GitHub triggers Vercel
├─ Vercel automatically builds your Next.js app
├─ Runs tests and checks (if configured)
├─ Deploys to global CDN
├─ Your app is live!
└─ GitHub Copilot can help fix deployment issues

5:00 PM - Production Running
┌─ App running on Vercel
├─ Database on Supabase (PostgreSQL)
├─ Users access via vercel_domain.app
├─ Real-time subscriptions work via Supabase
├─ Optional: Local Supabase (via Docker) running for next dev session
└─ Everything running with AI assistance!
```

---

## Installation Priority

### Critical (Must Install First)
```
1. Git ...................... Foundation for everything
2. Node.js ................... Runtime for tools and dev environment
3. VS Code ................... Your IDE for development
```

### Essential (Install Second)
```
4. GitHub Copilot ............ AI assistance (requires VS Code)
5. Copilot CLI ............... Terminal AI (requires Node.js)
6. npm global tools .......... Vite, Vercel, Supabase CLIs
```

### Important (Install Third)
```
7. Supabase Account .......... Backend and database
8. Vercel Account ............ Deployment and hosting
```

### Optional (Install If Needed)
```
9. Docker .................... Optional - for local Supabase development
```

### Advanced (Install When Needed)
```
10. Agent Skills .............. Custom AI capabilities
11. MCP Servers ............... Extend Copilot with custom APIs
12. Alternative tools ......... pnpm, Turbo, etc.
```

---

## Technology Relationships

### Git ↔ GitHub
```
Your Computer          GitHub Cloud
┌──────────────┐       ┌──────────────┐
│ Local Git    │ push  │ GitHub       │
│ Repository   │ ←──→  │ Repository   │
│              │ pull  │              │
└──────────────┘       └──────────────┘
```

### Node.js ↔ npm ↔ Vite & Next.js
```
Node.js (Runtime)
    ↓
npm (Package Manager)
    ↓ installs packages
Vite (Frontend Build)  +  Next.js (Full-Stack)
    ↓
Creates optimized bundles for web
```

### VS Code ↔ Copilot ↔ GitHub
```
Your Editor          AI Assistant        Your Account
┌──────────┐  ←→  ┌──────────┐  ←→  ┌──────────────┐
│ VS Code  │      │ Copilot  │      │ GitHub       │
│ ────     │      │ ────     │      │ Account      │
│ - Write  │      │ - Suggest│      │ - Auth tokens│
│ - Read   │      │ - Debug  │      │ - Skills     │
│ - Debug  │      │ - Explain│      │ - Repos      │
└──────────┘      └──────────┘      └──────────────┘
```

### Next.js ↔ Supabase ↔ Vercel
```
Frontend/Backend        Database                Hosting
┌──────────────┐       ┌──────────────┐       ┌──────────┐
│ Next.js      │       │ Supabase     │       │ Vercel   │
│ ────         │ ←────→│ ────         │ ←────→│ ────     │
│ - Pages      │       │ - PostgreSQL │       │ - CDN    │
│ - API routes │       │ - Auth       │       │ - Deploy │
│ - Auth       │       │ - Real-time  │       │ - Envs   │
└──────────────┘       └──────────────┘       └──────────┘
```

### Full Stack Flow
```
User in Browser
    ↓
[Vercel CDN] (fast global delivery)
    ↓
Next.js API Route
    ↓
Supabase (PostgreSQL)
    ↓
Database Query
    ↓
Data returned to frontend
    ↓
User sees result
```

### Local Supabase Setup (Optional with Docker)
```
Development Environment (Two Options)

Option 1: Cloud Supabase (Recommended for Beginners)
┌─────────────────────────────┐
│ Your App (Next.js)          │
│         ↓                   │
│ Vercel/Supabase API         │
│ (via internet)              │
└─────────────────────────────┘

Option 2: Local Supabase (Advanced - requires Docker)
┌──────────────────────────────────────┐
│ Your Computer (Docker Running)        │
├──────────────────────────────────────┤
│ Your App (Next.js)                   │
│         ↓                            │
│ Docker Container (Supabase)          │
│ - PostgreSQL (localhost:5432)        │
│ - API (localhost:54321)              │
│ - Studio UI (localhost:54323)        │
└──────────────────────────────────────┘
```

---

## Common Confused Pairs

### Git vs GitHub
- **Git**: Version control software (runs on your computer)
- **GitHub**: Website where you host Git repositories (in the cloud)
- **Analogy**: Git is like Microsoft Word (the software), GitHub is like Google Docs (the cloud platform)

### npm vs Node.js
- **Node.js**: JavaScript runtime (lets you run JS outside browsers)
- **npm**: Package manager that comes with Node.js (installs libraries)
- **Analogy**: Node.js is Python, npm is pip

### Vite vs Next.js
- **Vite**: Frontend build tool (optimizes React/Vue for browsers)
- **Next.js**: Full-stack framework (includes frontend + backend + deployment)
- **Use**: Vite for frontend-only projects, Next.js for full-stack apps

### Supabase vs Vercel
- **Supabase**: Backend as a Service (provides database + auth + real-time)
- **Vercel**: Deployment platform (hosts your frontend + backend)
- **Use**: Supabase for data persistence, Vercel for making it accessible to users

### Docker vs Virtual Machine
- **Docker**: Lightweight containers (shares OS, fast)
- **Virtual Machine**: Full OS emulation (heavyweight, slow)
- **Docker uses**: Images, lightweight, seconds to start
- **VM uses**: Snapshots, heavy, minutes to start

### Agent Skills vs MCP Servers
- **Agent Skills**: Custom instructions for Copilot (how to think about your domain)
- **MCP Servers**: Custom APIs that Copilot can call (extend what Copilot can do)
- **Skills**: Teach → **MCP**: Enable

---

## Before and After Installation

### Before Installation
```
┌─────────────────────────────────┐
│ Your Computer                   │
├─────────────────────────────────┤
│ - Text editor or IDE (maybe)    │
│ - No version control            │
│ - No JavaScript runtime         │
│ - No AI assistance              │
│ - No database access            │
│ - No deployment platform        │
│ - No node packages              │
│                                 │
│ Result: Can't develop modern    │
│ web applications effectively    │
└─────────────────────────────────┘
```

### After Installation (Phase 1 Complete)
```
┌──────────────────────────────────────┐
│ Your Computer - Full Stack Ready!    │
├──────────────────────────────────────┤
│ ✅ Git (version control)             │
│ ✅ VS Code + Copilot (IDE + AI)      │
│ ✅ Node.js & npm (runtime + packages)│
│ ✅ Vite & Next.js (build tools)      │
│ ✅ Docker (optional - local Supabase)│
│ ✅ Supabase CLI (backend access)     │
│ ✅ Vercel CLI (deployment access)    │
│ ✅ Copilot CLI (terminal AI)         │
│ ✅ Agent Skills (custom AI)          │
│ ✅ Accounts: GitHub, Supabase, etc.  │
│                                      │
│ Result: Ready to build professional│
│ full-stack AI-assisted apps!        │
└──────────────────────────────────────┘
```

---

## Technology by Category

### Version Control & Collaboration
- Git (local version control)
- GitHub (remote repository + collaboration)

### Development & Coding
- VS Code (IDE)
- Node.js (JavaScript runtime)
- npm (package manager)
- GitHub Copilot (AI assistance)
- Copilot CLI (terminal AI)

### Frontend Development
- Vite (build tool)
- React (UI library)
- Next.js (React framework with backend)

### Backend & Database
- Supabase (PostgreSQL + auth + real-time)
- SQL (query language)

### DevOps & Deployment
- Vercel (hosting + deployment)
- Docker (optional - for local Supabase)

### AI & Extensibility
- Agent Skills (custom Copilot instructions)
- MCP Servers (custom Copilot integrations)

---

## Next Steps

1. **Read** [Phase 1 Installation Guide](PHASE_1_INSTALLATION_GUIDE.md)
2. **Use** this glossary as a reference whenever you encounter unfamiliar terms
3. **Bookmark** the technology relationships for quick understanding
4. **Refer back** to this guide during Phase 2 and Phase 3

---

## Quick Links Reference

| Need Help With? | Go To |
|---|---|
| Installation instructions | [Phase 1 Guide](PHASE_1_INSTALLATION_GUIDE.md) |
| Platform-specific commands | [Platform Reference](PLATFORM_SPECIFIC_REFERENCE.md) |
| Terminology | This guide (Glossary section) |
| How it all works together | Phase 2 (Coming Soon) |
| Build first app | Phase 3 (Coming Soon) |

---

**Last Updated**: March 2026
