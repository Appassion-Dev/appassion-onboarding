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
- **Editor**: Text editor for writing code (VS Code is more than this)
- **Terminal/Console**: Command-line interface for running commands
- **Shell**: Command interpreter (PowerShell on Windows, Bash on macOS/Linux)
- **VS Code Extensions**: Add-ons that extend VS Code functionality (Copilot, Supabase, linters, etc.)

### AI & Coding Intelligence
- **AI Copilot**: Artificial intelligence that suggests code completions and helps debug
- **GitHub Copilot**: VS Code extension for inline code suggestions and completions
- **GitHub Copilot Chat**: Chat interface within VS Code for conversational AI assistance (asks questions, get answers)
- **Copilot CLI**: AI assistance in your terminal (explains commands, suggests fixes; installed via `gh extension install github/gh-copilot`)
- **Agent Skills**: Custom instructions that teach Copilot about your domain/conventions (stored in `.copilot/skills/`)
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