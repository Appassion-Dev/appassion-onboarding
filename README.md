# AI-Assisted Full Stack Development Framework - Developer Onboarding

**Windows Edition** — Complete setup guide for Windows developers

Welcome to the **AI-Assisted Full Stack Development Framework** onboarding program. This guide takes you from a blank machine to a deployed, feature-rich full-stack app — built with AI assistance throughout.

## 🎯 What You'll Learn

- Set up a professional AI-assisted development environment
- Use GitHub Copilot (Chat, Agent, Autopilot) for code generation and planning
- Build full-stack applications with React + Vite and Supabase (Postgres + Auth + Storage + Realtime)
- Deploy to Vercel with continuous integration via GitHub
- Use agent skills to guide Copilot with domain-specific best practices

## 📚 Program Structure

### **Phase 1: Installation Guide** ⚙️
**Duration**: 45–90 minutes
**Goal**: Get your development environment fully set up

Start here: [PHASE_1_INSTALLATION_GUIDE.md](PHASE_1_INSTALLATION_GUIDE.md)

**What you'll install:**
- Git & GitHub account with SSH keys
- GitHub Copilot subscription
- VS Code with extensions (Copilot, Copilot Chat, Supabase, ESLint, Prettier, Docker)
- GitHub CLI with Copilot CLI
- Node.js and npm
- Docker Desktop (for running Supabase locally)
- Vercel CLI and Supabase CLI

**By the end of Phase 1, you'll have:**
- ✅ Complete development environment set up and verified
- ✅ GitHub Copilot Chat and CLI working
- ✅ Docker ready for running Supabase locally
- ✅ Supabase and Vercel accounts configured
- ✅ Agent Skills directory structure ready

---

### **Phase 2: Your First Full Stack Project**
**Duration**: 30–45 minutes
**Goal**: Build a real monorepo with a React frontend and a Supabase backend, deployed to production

Start here: [PHASE_2_FULLSTACK_PROJECT_GUIDE.md](PHASE_2_FULLSTACK_PROJECT_GUIDE.md)

**What you'll build:**
- React + Vite frontend with TypeScript types generated from the real database schema
- Local Supabase PostgreSQL database (Auth + notes table + RLS) running via Docker
- Frontend connected to the local Supabase instance via the JS client
- Agent skills installed (`supabase-postgres-best-practices`, `vercel-react-best-practices`)
- Project deployed: schema on Supabase Cloud, frontend on Vercel

**By the end of Phase 2, you'll have:**
- ✅ Notes app running at `localhost:5173` with sign-up / sign-in
- ✅ Local Supabase database with Auth, a notes table, and Row Level Security
- ✅ TypeScript types generated from the schema (`database.types.ts`)
- ✅ GitHub Copilot instructions and MCP servers configured for the project
- ✅ App live on Vercel connected to Supabase Cloud

---

### **Phase 3: AI-Assisted Feature Development**
**Duration**: 3–4 hours (self-paced — each feature is self-contained)
**Goal**: Build 8 real features using the Research → Plan → Implement (RPI) agentic workflow

Start here: [PHASE_3_FEATURE_DEVELOPMENT_GUIDE.md](PHASE_3_FEATURE_DEVELOPMENT_GUIDE.md)

**What you'll build:**
- **Pin notes** — boolean column, multi-column ORDER BY
- **Edit profile** — display name stored in a users table
- **Archive / soft delete** — nullable timestamp, partial index, archived view
- **Tags** — many-to-many join table, composite keys, tag filtering
- **Full-text search** — `tsvector` generated column, GIN index, debounced input
- **Pagination** — `.range()` queries, "Load more" with running total
- **Optimistic UI** — instant state update + error rollback (no backend changes)
- **Real-time sync** — Supabase Realtime subscriptions, `useEffect` cleanup, multi-tab testing

**By the end of Phase 3, you'll have:**
- ✅ 8 features shipped using the RPI workflow
- ✅ Multiple additive migrations applied locally and pushed to production
- ✅ Autopilot mode used for hands-free implementation
- ✅ Confident with: tsvector, GIN indexes, partial indexes, join tables, Realtime channels
- ✅ Repeatable cycle: Research → Plan → Implement → Test → Commit → Deploy

---

### **Phase 4: File Storage & Note Sharing**
**Duration**: 3–4 hours (self-paced — each feature is self-contained)
**Goal**: Add Supabase Storage and cross-user collaboration to the notes app

Start here: [PHASE_4_FILE_STORAGE_GUIDE.md](PHASE_4_FILE_STORAGE_GUIDE.md)

**What you'll build:**
- **Profile pictures** — private `avatars` bucket, path-based owner-only policies, upsert upload, signed URL display, initials fallback
- **File attachments** — private `attachments` bucket, metadata table with cascade delete, owner-only policies, per-file upload state, thumbnail and PDF icon rendering
- **Note sharing** — `note_shares` join table, `view`/`edit` permission enum, extended RLS policies on notes and both storage buckets, `SECURITY DEFINER` user lookup by email, permission-aware UI

**By the end of Phase 4, you'll have:**
- ✅ Two private Supabase Storage buckets with path-based RLS policies
- ✅ Storage policies extended in Feature 3 to allow shared-note viewers to read avatars and attachments
- ✅ SECURITY DEFINER function for safe cross-user email lookup
- ✅ Permission-aware UI: shared viewers can see but not manage attachments; edit vs. view controls differ
- ✅ Full RPI workflow with Autopilot on the most complex feature set yet

---

## 📚 Reference Guides

- **[Glossary](GLOSSARY.md)** — 60+ term glossary covering the full stack
- **[Markdown Guide](MARKDOWN_GUIDE.md)** — syntax reference and documentation patterns

---

## External Documentation

- [VS Code Documentation](https://code.visualstudio.com/docs)
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Supabase Documentation](https://supabase.com/docs)
- [Vercel Documentation](https://vercel.com/docs)
- [React Documentation](https://react.dev)
- [Git Documentation](https://git-scm.com/doc)
- [Docker Documentation](https://docs.docker.com)

---