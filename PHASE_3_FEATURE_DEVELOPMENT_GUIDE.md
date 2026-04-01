# Phase 3: Extending Your App with AI-Assisted Feature Development

You have a deployed notes app with authentication and basic CRUD. Now you'll extend it — feature by feature — using the **Research → Plan → Implement (RPI)** agentic workflow. Each feature teaches a new concept, exercises a different part of the stack, and ships to production.

**Estimated Time: 3-4 hours** (work through features at your own pace — each is self-contained)

---

## Table of Contents

- [What You'll Build](#what-youll-build)
- [The RPI Workflow](#the-rpi-workflow)
- [Prerequisites](#prerequisites)
- [Feature 1: Pin Notes](#feature-1-pin-notes)
- [Feature 2: Edit Your Profile](#feature-2-edit-your-profile)
- [Feature 3: Archive Notes (Soft Delete)](#feature-3-archive-notes-soft-delete)
- [Feature 4: Tags](#feature-4-tags)
- [Feature 5: Full-Text Search](#feature-5-full-text-search)
- [Feature 6: Pagination](#feature-6-pagination)
- [Feature 7: Optimistic UI](#feature-7-optimistic-ui)
- [Feature 8: Real-Time Sync](#feature-8-real-time-sync)
- [Deployment Checklist (After Each Feature)](#deployment-checklist-after-each-feature)
- [Summary](#summary)

---

## What You'll Build

By the end of this phase, your notes app will have:
- **Pinned notes** that float to the top
- **User profiles** with editable display names
- **Soft delete / archive** instead of permanent deletion
- **Tags** with a many-to-many relationship
- **Full-text search** using Postgres `tsvector` + GIN indexes
- **Paginated note lists** with "Load more"
- **Optimistic UI** for instant-feeling interactions
- **Real-time sync** across browser tabs

Each feature follows the same cycle: **Research → Plan → Implement → Test locally → Commit → Deploy**.

---

## The RPI Workflow

Every feature in this guide follows the same three-phase agentic workflow. Learn it once, use it everywhere.

### R — Research

Before writing any code, gather context. Open Copilot Chat (`Ctrl+Alt+I`) in **Ask mode** and ask questions about the approach. Reference the relevant skills so Copilot's answers are grounded in best practices, not generic advice.

**Example:**
```
@workspace /supabase-postgres-best-practices What's the best way to add a boolean "pinned" column
to an existing notes table? Should I use a default value? What about the sort order query?
```

Read Copilot's response. If you have follow-up questions, ask them now — before any code is generated.

### P — Plan

Switch to **Plan mode** (click the mode selector in Copilot Chat). Describe the full feature and ask Copilot to produce a plan — the list of files it will create or modify, the migration SQL, and the component changes.

**Review the plan carefully.** Look for:
- Does the migration match what you learned in the Research step?
- Are the right components being modified?
- Is there anything unexpected or missing?

Ask Copilot to revise the plan if needed. Don't proceed until you're satisfied.

### I — Implement

Switch to **Agent mode** and click **Implement** (or paste your refined prompt). Copilot writes the code. Then:

1. **Test locally** — run the app and manually verify the feature works
2. **Review changes** — open Source Control (`Ctrl+Shift+G`) to see exactly what files changed
3. **Stage and commit** — group related changes into a single descriptive commit
4. **Deploy** — push schema to Supabase Cloud, push code to GitHub (which auto-deploys to Vercel)

---

## Prerequisites

Before starting, make sure everything from Phase 2 is running:

**1. Docker Desktop** is running

**2. Local Supabase** is started:
```powershell
supabase start
```

**3. Frontend dev server** is running (in a second terminal):
```powershell
cd frontend
npm run dev
```

**4. Agent skills** are installed (verify these folders exist):
- `.agents/skills/supabase-postgres-best-practices/`
- `.agents/skills/vercel-react-best-practices/`

If either is missing, install them:
```powershell
npx skills add supabase/agent-skills
npx skills add vercel-labs/agent-skills
```

**5. Your app** is open in the browser at `http://localhost:5173` and you can sign in.

---

## Feature 1: Pin Notes

**Concepts practiced**: additive schema migration, column defaults, multi-column ordering, conditional CSS

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 1.1: Research

Open Copilot Chat in **Ask mode**:

```
@workspace /supabase-postgres-best-practices I want to add a "pin" feature to my notes app so
pinned notes show up first. What column type and default should I use? How should I order the
query to show pinned notes at the top, then by newest?
```

**What to look for in the response**:
- `boolean NOT NULL DEFAULT false` for the column
- `ORDER BY pinned DESC, created_at DESC` for the query
- The migration should be additive (ALTER TABLE, not recreating the table)

### Step 1.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices /vercel-react-best-practices
Add a "pin note" feature to my notes app.

Backend:
- New migration that adds a `pinned` boolean column to the notes table (default false)
- Update the RLS policies only if needed

Frontend:
- Update the fetch query to order by pinned DESC, then created_at DESC
- Add a pin/unpin toggle button on each note card
- Show a visual indicator (e.g. pin icon or accent border) on pinned notes
- Use the existing App.css styling conventions (CSS variables, BEM-style classes)
```

Review the plan. Confirm:
- It creates a **new** migration file (not editing the existing one)
- It does NOT drop or recreate the notes table
- It modifies `NoteList.jsx` and `App.jsx` (fetch query)

### Step 1.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 1.4: Test Locally

1. Apply the new migration:
   ```powershell
   supabase migration up
   ```
2. Refresh `http://localhost:5173`
3. Create a note → pin it → verify it moves to the top
4. Unpin it → verify it returns to chronological order
5. Check Supabase Studio (`http://localhost:54323`) — open the `notes` table and confirm the `pinned` column exists

### Step 1.5: Regenerate Types

The schema changed — regenerate the TypeScript types so the frontend stays in sync:

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

### Step 1.6: Stage, Review & Commit

1. Open **Source Control** (`Ctrl+Shift+G`)
2. Review the changed files — you should see:
   - A new migration file in `supabase/migrations/`
   - Modified `frontend/src/App.jsx` (fetch query)
   - Modified `frontend/src/components/NoteList.jsx` (pin button + visual)
   - Modified `frontend/src/App.css` (pin styles)
   - Updated `frontend/src/database.types.ts`
3. Click **+** next to each file to stage it (or **+** next to "Changes" to stage all)
4. Type: `feat: add pin/unpin notes with sort order`
5. Click **✓ Commit**

### Step 1.7: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature) at the bottom of this guide.

---

## Feature 2: Edit Your Profile

**Concepts practiced**: using the existing `users` UPDATE RLS policy, form state management, Supabase `.update()` on a non-notes table

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 2.1: Research

```
@workspace /supabase-postgres-best-practices The users table already has a full_name column and
an "update own" RLS policy. What's the simplest way to let users edit their display name from
the frontend? Do I need any schema changes?
```

**What to look for**: No migration needed — the `users` table already has `full_name` and the UPDATE policy. This is pure frontend work.

### Step 2.2: Plan

Switch to **Plan mode**:

```
/vercel-react-best-practices
Add a profile section to the notes app where users can view and edit their display name.

Requirements:
- Show the user's display name (or email as fallback) in the header
- Add a "Profile" button in the header that opens an inline profile editor (same pattern as NoteEditor)
- The profile editor has a single field: Full Name
- On save, update the users table via supabase.from('users').update(...)
- After saving, update the header immediately (no page reload)
- Use existing CSS conventions and component patterns
```

### Step 2.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 2.4: Test Locally

1. Refresh `http://localhost:5173` and sign in
2. Click **Profile** in the header
3. Enter a display name → Save
4. Verify the header now shows the display name
5. Sign out and back in → verify the name persists
6. Check Supabase Studio → `users` table → confirm `full_name` was updated

### Step 2.5: Stage, Review & Commit

1. Open **Source Control** (`Ctrl+Shift+G`)
2. Review changes — this should be frontend-only (no migrations)
3. Stage all changed files
4. Commit: `feat: add profile editing with display name`

### Step 2.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 3: Archive Notes (Soft Delete)

**Concepts practiced**: soft deletes, `timestamptz` nullable columns, partial indexes, query filtering, UI state transitions

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 3.1: Research

```
@workspace /supabase-postgres-best-practices I want to add soft delete to my notes table using
an `archived_at` timestamp column. Should I use a partial index? How should the RLS policies change?
What about the fetch query — should I filter in the query or in the policy?
```

**What to look for**:
- `archived_at timestamptz DEFAULT NULL` — null means active, non-null means archived
- A partial index: `CREATE INDEX ... ON notes (user_id) WHERE archived_at IS NULL` — speeds up the common "show active notes" query
- Filter in the query (not the policy) so you can later add an "Archived" view

### Step 3.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices /vercel-react-best-practices
Replace hard delete with soft delete (archive) in the notes app.

Backend:
- New migration adding `archived_at timestamptz` column to notes (nullable, default null)
- Add a partial index on user_id WHERE archived_at IS NULL
- Keep existing RLS policies unchanged (archiving is just an UPDATE)

Frontend:
- Replace the "Delete" button with an "Archive" button that sets archived_at = now()
- Filter the main query to only show notes WHERE archived_at IS NULL
- Add an "Archived" toggle/tab that shows archived notes
- Add an "Unarchive" button on archived notes that sets archived_at = null
- Add a "Delete Permanently" button only visible in the archived view
```

### Step 3.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 3.4: Test Locally

1. Apply the migration:
   ```powershell
   supabase migration up
   ```
2. Refresh the app
3. Archive a note → it disappears from the main list
4. Toggle to the "Archived" view → the note appears there
5. Unarchive it → it returns to the main list
6. Permanently delete from the archived view → confirm it's gone
7. Check Supabase Studio → verify `archived_at` is set/cleared correctly

### Step 3.5: Regenerate Types

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

### Step 3.6: Stage, Review & Commit

Review changes, then commit: `feat: soft delete with archive/unarchive and permanent delete`

### Step 3.7: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 4: Tags

**Concepts practiced**: many-to-many relationships, join tables, composite keys, foreign key indexes, nested Supabase selects, RLS on join tables

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 4.1: Research

```
@workspace /supabase-postgres-best-practices I want to add tags to my notes. Each note can have
multiple tags, and each tag can be on multiple notes. What's the best schema — a separate tags
table + join table, or a text array on the notes table? What indexes do I need? What RLS policies
should the join table have?
```

**What to look for**:
- Normalized design: `tags` table + `note_tags` join table (not a text array — arrays don't enforce uniqueness and can't be efficiently indexed for many-to-many lookups)
- FK indexes on both sides of the join table
- RLS on `note_tags` matching the note's `user_id` via a subquery

### Step 4.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices /vercel-react-best-practices
Add a tagging system to the notes app.

Backend:
- New migration with:
  - `tags` table (id bigint identity, user_id uuid FK, name text, unique per user)
  - `note_tags` join table (note_id FK, tag_id FK, composite PK)
  - FK indexes on both join table columns
  - RLS: users can only CRUD their own tags and note_tags
- Update seed.sql with sample tags

Frontend:
- Show tags as small pills/badges on each note card
- In the NoteEditor, add a tag input that lets users:
  - Select from existing tags (autocomplete/dropdown)
  - Create new tags inline
  - Remove tags from a note
- Add tag filtering: clicking a tag in the list filters notes to that tag
- Use Supabase nested selects: .select('*, note_tags(tags(*))')
```

### Step 4.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 4.4: Test Locally

1. Apply the migration:
   ```powershell
   supabase migration up
   ```
2. Optionally reset to get fresh seed data with tags:
   ```powershell
   supabase db reset
   ```
3. Refresh the app
4. Create a note with tags → verify tags appear on the card
5. Click a tag → verify the list filters
6. Edit a note → add/remove tags → save → verify changes persist
7. Check Supabase Studio → inspect `tags` and `note_tags` tables, verify FK relationships

### Step 4.5: Regenerate Types

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

### Step 4.6: Stage, Review & Commit

Review changes (this one is bigger — migration, seed, multiple components), then commit: `feat: tagging system with many-to-many schema and tag filtering`

### Step 4.7: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 5: Full-Text Search

**Concepts practiced**: Postgres `tsvector` generated columns, GIN indexes, Supabase `.textSearch()`, search UI patterns

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 5.1: Research

```
@workspace /supabase-postgres-best-practices I want to add full-text search to my notes.
How do I create a tsvector generated column that combines title and content? What index type
should I use? How does Supabase JS expose text search?
```

**What to look for**:
- A generated column: `search_vector tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, ''))) STORED`
- A GIN index on the column
- Supabase JS: `.textSearch('search_vector', query, { type: 'websearch' })`

### Step 5.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices /vercel-react-best-practices
Add full-text search to the notes app.

Backend:
- New migration that adds a `search_vector` tsvector generated column on the notes table
- GIN index on search_vector
- No RLS changes needed (existing policies still apply)

Frontend:
- Add a search input at the top of the notes list
- When the user types, debounce the input (300ms) and query using Supabase .textSearch()
- If search is empty, fall back to the normal fetch (pinned first, then by date)
- Show a "No results" message when search returns empty
- Clear search button (X icon)
```

### Step 5.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 5.4: Test Locally

1. Apply the migration:
   ```powershell
   supabase migration up
   ```
2. Refresh the app
3. Type a word that exists in one of your note titles → verify results filter
4. Type a word from note content → verify it also matches
5. Clear the search → verify all notes return
6. Search for nonsense → verify "No results" message
7. Check Supabase Studio → run `SELECT search_vector FROM notes LIMIT 5` to see the tsvector values

### Step 5.5: Regenerate Types

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

### Step 5.6: Stage, Review & Commit

Commit: `feat: full-text search with tsvector, GIN index, and debounced input`

### Step 5.7: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 6: Pagination

**Concepts practiced**: Supabase `.range()`, offset-based pagination, loading states, progressive data fetching

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 6.1: Research

```
@workspace /supabase-postgres-best-practices What's the best way to paginate notes in Supabase?
Should I use .range() with offset-based pagination or cursor-based? What are the tradeoffs?
For a personal notes app, which is simpler?
```

**What to look for**:
- Offset-based with `.range(from, to)` is simpler and fine for a single-user notes list (no concurrent writes by other users shifting pages)
- Cursor-based is better for multi-user feeds — overkill here
- Supabase automatically returns the `count` if you pass `{ count: 'exact' }` to `.select()`

### Step 6.2: Plan

Switch to **Plan mode**:

```
/vercel-react-best-practices
Add pagination to the notes list — load 10 notes at a time with a "Load more" button.

Requirements:
- Change the initial fetch to load only the first 10 notes using .range(0, 9)
- Pass { count: 'exact' } to get the total count
- Add a "Load more" button below the list when there are more notes
- Clicking "Load more" fetches the next 10 and appends them to the existing list
- Show a loading spinner on the "Load more" button while fetching
- Hide the button when all notes are loaded
- Keep pinned-first ordering
- Don't paginate search results (keep full-text search returning all matches for now)
```

### Step 6.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 6.4: Test Locally

1. You need more than 10 notes to test. Create them manually or re-seed:
   ```powershell
   supabase db reset
   ```
   > **Tip**: Ask Copilot to update `seed.sql` with 15+ notes for the first test user before resetting.
2. Refresh the app → verify only 10 notes show
3. Click "Load more" → verify the next batch appears
4. Continue until all notes are loaded → verify the button disappears
5. Pin a note → verify pinned notes still appear first even with pagination

### Step 6.5: Stage, Review & Commit

Commit: `feat: paginate notes list with load-more button (10 per page)`

### Step 6.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 7: Optimistic UI

**Concepts practiced**: optimistic state updates, error rollback, improving perceived performance without changing the backend

**Skills used**: `vercel-react-best-practices`

### Step 7.1: Research

```
@workspace /vercel-react-best-practices What's the best way to implement optimistic UI updates in
React? For example, when the user pins a note, I want the UI to update immediately without waiting
for the server response. How should I handle errors and rollback?
```

**What to look for**:
- Save the previous state before updating
- Update local state immediately
- Fire the async request
- On error, revert to the saved state and show a brief error message
- No additional dependencies needed — just React state

### Step 7.2: Plan

Switch to **Plan mode**:

```
/vercel-react-best-practices
Make pin/unpin and archive/unarchive optimistic in the notes app.

Requirements:
- When the user clicks pin/unpin, update the local notes array immediately (don't wait for the API)
- If the API call fails, revert the local state to the previous value
- Show a brief toast/error message on failure (a simple timeout-based message, no toast library)
- Apply the same pattern to archive/unarchive
- Don't change the happy path — successful operations should feel instant
- Keep the existing code structure (no new state management libraries)
```

### Step 7.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 7.4: Test Locally

1. Refresh the app
2. Pin a note → it should move to the top **immediately** (no loading spinner)
3. Archive a note → it should disappear **immediately**
4. To test rollback: temporarily break the Supabase URL in `.env.local`, restart the dev server, try to pin a note → verify it snaps back and shows an error
5. Fix the `.env.local` and restart

> **Important**: This feature has **no backend changes** — don't run any migrations or regenerate types.

### Step 7.5: Stage, Review & Commit

Commit: `feat: optimistic UI for pin and archive with error rollback`

### Step 7.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Feature 8: Real-Time Sync

**Concepts practiced**: Supabase Realtime subscriptions, Postgres changes channels, `useEffect` cleanup, multi-tab testing

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 8.1: Research

```
@workspace /supabase-postgres-best-practices How does Supabase Realtime work? How do I subscribe
to INSERT, UPDATE, and DELETE events on a single table filtered by user_id? What do I need to
enable in Supabase config?
```

**What to look for**:
- Realtime is enabled per-table in Supabase config (or via SQL: `ALTER PUBLICATION supabase_realtime ADD TABLE notes`)
- Subscribe using `supabase.channel('notes').on('postgres_changes', { event: '*', schema: 'public', table: 'notes', filter: 'user_id=eq.YOUR_UUID' }, callback)`
- Cleanup: unsubscribe in the `useEffect` return function
- Local Supabase has Realtime enabled by default

### Step 8.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices /vercel-react-best-practices
Add real-time sync so notes update automatically across browser tabs.

Backend:
- New migration that enables Realtime on the notes table (ALTER PUBLICATION supabase_realtime ADD TABLE public.notes)

Frontend:
- Subscribe to postgres_changes on the notes table, filtered by the current user's user_id
- Handle INSERT: add the new note to the list in the correct position
- Handle UPDATE: update the changed note in the list (handles pin, edit, archive)
- Handle DELETE: remove the note from the list
- Set up the subscription in a useEffect with proper cleanup (unsubscribe on unmount)
- Don't refetch the entire list on each event — apply the change directly to local state
```

### Step 8.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 8.4: Test Locally

1. Apply the migration:
   ```powershell
   supabase migration up
   ```
2. Refresh the app
3. Open a **second browser tab** to `http://localhost:5173` (signed in as the same user)
4. In Tab 1: create a new note → verify it appears in Tab 2 automatically
5. In Tab 2: pin a note → verify it moves to the top in Tab 1
6. In Tab 1: archive a note → verify it disappears in Tab 2
7. Close Tab 2 → verify no console errors (cleanup worked)

### Step 8.5: Regenerate Types

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

### Step 8.6: Stage, Review & Commit

Commit: `feat: real-time sync across tabs via Supabase Realtime`

### Step 8.7: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

---

## Deployment Checklist (After Each Feature)

After every feature, follow this exact sequence to deploy your changes.

### 1. Push Schema to Supabase Cloud (if a migration was added)

Skip this step if the feature was frontend-only (no new file in `supabase/migrations/`).

```powershell
supabase db push
```

This applies any new migrations to your cloud database. Review the output — it shows which migration files were applied.

### 2. Regenerate Types (if schema changed)

Skip if no migration was added.

```powershell
supabase gen types typescript --local > frontend/src/database.types.ts
```

> **Note**: If you already regenerated types during the feature steps, you don't need to do it again. This is a reminder in case you forgot.

### 3. Push to GitHub

```powershell
git push
```

Or in VS Code: **Source Control** → **⋯** → **Push**

Vercel automatically detects the push and rebuilds your frontend. The new deployment goes live within ~60 seconds.

### 4. Verify Production

1. Open your Vercel URL (e.g. `https://my-first-fullstack.vercel.app`)
2. Test the feature you just deployed
3. If something is broken, check:
   - **Vercel build logs**: Vercel dashboard → your project → Deployments → latest → click to see logs
   - **Schema mismatch**: did you forget `supabase db push`?
   - **Environment variables**: are `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` set in Vercel to your **cloud** credentials?

---

## Summary

You've completed Phase 3. Here's what you practiced:

| Feature | Backend Concepts | Frontend Concepts | Skills Used |
|---|---|---|---|
| Pin Notes | Additive migration, column defaults, multi-column ORDER BY | Conditional rendering, toggle state | supabase-postgres, vercel-react |
| Edit Profile | Using existing RLS policies, UPDATE on profiles | Form state, inline editing | vercel-react |
| Soft Delete | Nullable timestamps, partial indexes | View toggling, multi-action buttons | supabase-postgres, vercel-react |
| Tags | Many-to-many, join tables, composite keys, FK indexes, RLS on joins | Nested selects, autocomplete, tag pills | supabase-postgres, vercel-react |
| Full-Text Search | tsvector generated columns, GIN index | Debounced input, conditional queries | supabase-postgres, vercel-react |
| Pagination | .range(), count queries | "Load more" pattern, appending state | supabase-postgres, vercel-react |
| Optimistic UI | (none) | Optimistic state, error rollback | vercel-react |
| Real-Time Sync | Realtime publication, postgres_changes | Channel subscriptions, useEffect cleanup | supabase-postgres, vercel-react |

**Workflow mastered**: Research → Plan → Implement → Test → Commit → Deploy

**Skills catalog** — all installable via `npx skills add`:

| Skill | Install Command | When to use |
|---|---|---|
| Supabase Postgres Best Practices | `npx skills add supabase/agent-skills` | Schema design, migrations, RLS, indexes, queries |
| React Best Practices (Vercel) | `npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices` | Components, state, effects, performance patterns |
| Composition Patterns | `npx skills add vercel-labs/agent-skills --skill vercel-composition-patterns` | Refactoring toward compound components, render props |
| Web Design Guidelines | `npx skills add vercel-labs/agent-skills --skill web-design-guidelines` | Accessibility audit, UX review |
| Vercel Deploy | `npx skills add vercel-labs/agent-skills --skill vercel-deploy` | Deployment automation and configuration |

Browse all available skills:
- Supabase: https://supabase.com/docs/guides/getting-started/ai-skills
- Vercel: https://vercel.com/docs/agent-resources/skills
- Community: https://skills.sh

---

## Quick Reference: Phase 3 Commands

```powershell
# Apply new migrations (without wiping data)
supabase migration up

# Reset database (re-runs all migrations + seed.sql)
supabase db reset

# Regenerate TypeScript types after schema change
supabase gen types typescript --local > frontend/src/database.types.ts

# Push migrations to Supabase Cloud
supabase db push

# Start frontend dev server
cd frontend
npm run dev

# Git workflow
git add .                    # Stage all changes
git status                   # Review staged files
git commit -m "feat: ..."    # Commit with descriptive message
git push                     # Deploy (triggers Vercel rebuild)
```

---
