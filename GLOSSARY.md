# Glossary


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
- **Terminal/Console**: Command-line interface for running commands
- **Shell**: Command interpreter (PowerShell on Windows, Bash on macOS/Linux)
- **VS Code Extensions**: Add-ons that extend VS Code functionality (Copilot, Supabase, linters, etc.)

### AI & Copilot
- **GitHub Copilot**: AI assistant integrated into VS Code — provides inline code suggestions, answers questions, and can write entire features
- **GitHub Copilot Chat**: Conversational interface inside VS Code for asking questions and getting explanations
- **Copilot CLI**: AI assistance in your terminal — explains commands and suggests fixes (`gh extension install github/gh-copilot`)
- **Ask mode**: Read-only Copilot Chat mode for questions and research — no code is changed
- **Plan mode**: Copilot Chat mode that produces a plan (files to edit, migration steps) before writing any code — review and revise before implementing
- **Agent mode**: Copilot Chat mode where the AI takes actions: reads files, runs terminal commands, and edits code autonomously
- **Autopilot**: Agent mode variant that executes terminal commands and applies changes without asking for confirmation at each step — review changes in Source Control before committing
- **Agent Skills**: Domain-specific instruction files that teach Copilot best practices for a specific tool or framework (stored in `.agents/skills/`)
- **MCP (Model Context Protocol) Server**: Extends Copilot with access to external APIs or live data sources (e.g., Supabase Studio)
- **RPI Workflow**: Research → Plan → Implement — the three-phase agentic workflow used throughout this program

### JavaScript & Runtime
- **Node.js**: JavaScript runtime that runs outside browsers (server-side)
- **npm (Node Package Manager)**: Package manager for JavaScript (installs libraries)
- **Package**: A reusable piece of code (library or tool) that you install via npm
- **package.json**: Configuration file listing your project's dependencies
- **node_modules/**: Folder containing all installed packages (don't commit to Git)

### Frontend
- **Vite**: Fast frontend build tool and development server used in this program
- **React**: JavaScript library for building user interfaces from reusable components
- **JSX**: HTML-like syntax you write inside React component files (`.jsx`)
- **Component**: Reusable piece of UI in React (a function that returns JSX)
- **State**: Data inside a component that, when changed, causes the UI to re-render
- **useEffect**: React hook for running side effects (data fetching, subscriptions, timers) — always clean up subscriptions in the return function
- **Optimistic UI**: Update the UI immediately on user action before the server confirms — roll back if the server returns an error
- **Debounce**: Delay a function call until the user stops typing (e.g., 300 ms) — prevents firing a search query on every keystroke
- **Signed URL**: Short-lived, temporary URL that grants time-limited access to a private file — generated at render time, never stored in the database
- **TypeScript**: Typed superset of JavaScript — catches type errors at compile time instead of at runtime
- **database.types.ts**: TypeScript file generated from your Supabase schema — gives frontend code autocomplete and type safety against the real database shape

### Backend & Database
- **Backend**: Server-side code handling business logic, database, and authentication
- **Database**: Structured storage for application data
- **PostgreSQL**: Open-source relational database — the engine that powers Supabase
- **Supabase**: Backend-as-a-Service providing PostgreSQL, Auth, Storage, Realtime, and a JS client
- **Schema**: Structure of database tables, columns, types, and relationships
- **Migration**: SQL script that changes the database structure — each migration is a new file applied in order, never edited after the fact
- **Seed**: SQL file (`seed.sql`) that inserts sample data — re-runs on `supabase db reset`
- **Query**: Request to retrieve or modify data in the database
- **Row Level Security (RLS)**: Postgres feature that enforces who can read or write each row — policies run on every query automatically
- **RLS Policy**: A rule attached to a table that filters or blocks rows based on the current user's identity
- **SECURITY DEFINER**: A function attribute that runs the function with the privileges of its creator rather than the caller — used for safe cross-user lookups that bypass RLS in a controlled way
- **Foreign Key (FK)**: A column that references the primary key of another table — enforces referential integrity
- **Index**: Data structure that speeds up queries on a column — without one, Postgres scans every row
- **GIN Index**: Generalized Inverted Index — efficient for full-text search (`tsvector`) and array/JSONB columns
- **Partial Index**: Index that only covers rows matching a condition (e.g., only non-archived notes) — smaller and faster than a full-table index
- **tsvector**: Postgres data type for full-text search — a preprocessed list of word stems derived from text columns, used with a GIN index
- **Enum**: A database type with a fixed set of allowed values (e.g., `view` or `edit`) — safer than a free-text column because the database enforces valid values
- **Soft Delete**: Archive a row instead of permanently deleting it — store a timestamp when archived, filter it out of normal queries, allow recovery
- **Cascade Delete**: When a parent row is deleted, automatically delete all child rows that reference it (e.g., deleting a note removes its attachments)
- **Realtime**: Supabase service that pushes database change events (INSERT, UPDATE, DELETE) to subscribed clients over a WebSocket connection

### Supabase Storage
- **Supabase Storage**: Object storage service built into Supabase for files (images, PDFs, etc.) — separate from the database
- **Bucket**: A named container for files in Supabase Storage (like a folder at the top level)
- **Private Bucket**: A bucket where all files require a storage policy or signed URL to access — no anonymous public URLs
- **Public Bucket**: A bucket where files are accessible to anyone with the URL — appropriate only for truly public assets
- **Storage Policy**: RLS-like rule on a storage bucket that controls who can read, upload, update, or delete files — separate from table RLS
- **Path-based Policy**: Storage policy that checks ownership by matching the first folder in the file path against the current user's ID (e.g., `{user_id}/avatar.jpg`)
- **Upsert Upload**: Upload a file to a path that already exists — replaces the existing file rather than creating a duplicate or throwing an error
- **Metadata Table**: A database table that stores information about uploaded files (name, path, size, type, which note it belongs to) — the file itself stays in Storage

### Authentication
- **Auth**: Authentication — verifying who a user is (sign-up, sign-in, session management)
- **Session**: A record that a user is logged in — stored in the browser and sent with every Supabase request
- **JWT (JSON Web Token)**: Signed token that encodes the user's identity — Supabase includes it in every request so RLS policies can identify the current user

### Deployment & Hosting
- **Vercel**: Deployment platform for frontend apps — automatically rebuilds on every `git push`
- **Deployment**: Publishing your application to the internet
- **Environment Variables**: Configuration values (API keys, database URLs) that vary by environment — set in `.env.local` locally and in Vercel's dashboard for production
- **CI/CD**: Automated rebuild and deployment triggered by every push to GitHub
- **CDN (Content Delivery Network)**: Global network that caches and serves your frontend files fast
- **`supabase db push`**: Command that applies local migrations to your Supabase Cloud database
- **`supabase migration up`**: Command that applies pending migrations to your local database without wiping data

### Local Development Tooling
- **Docker**: Tool for running services locally in isolated containers — used to run Supabase (Postgres + Auth + Storage + Realtime) during development
- **Docker Compose**: Configuration that defines how to run multiple services together — used internally by the Supabase CLI
- **Supabase Studio**: Web UI for your local Supabase instance at `http://localhost:54323` — inspect tables, run SQL, browse Storage, manage Auth users
- **Supabase Local**: The full Supabase stack running locally via Docker — isolated from production, safe to experiment on

### API & Data Exchange
- **API (Application Programming Interface)**: Contract for how software components communicate
- **REST API**: Standard HTTP-based API (GET, POST, PUT, DELETE)
- **JSON**: Lightweight text format for exchanging structured data
- **Supabase JS Client**: The `@supabase/supabase-js` library — provides typed methods for querying the database, managing auth, uploading files, and subscribing to Realtime events

---