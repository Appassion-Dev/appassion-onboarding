# Phase 4: File Storage

You have a fully-featured notes app with authentication, rich data relationships, and real-time sync. Now you'll add Supabase Storage to the stack — learning how files and databases work together — and extend the app with cross-user collaboration through shared notes.

**Estimated Time: 3-4 hours** (work through features at your own pace — each is self-contained)

---

## Table of Contents

- [What You'll Build](#what-youll-build)
- [Prerequisites](#prerequisites)
- [Feature 1: Profile Picture](#feature-1-profile-picture)
- [Feature 2: File Attachments](#feature-2-file-attachments)
- [Feature 3: Share Notes](#feature-3-share-notes)
- [Deployment Checklist (After Each Feature)](#deployment-checklist-after-each-feature)
- [Summary](#summary)

---

## What You'll Build

By the end of this phase, your notes app will have:
- **Profile pictures** — users can upload and display a personal avatar stored in a private bucket
- **File attachments** on notes via Supabase Storage with private buckets and signed URLs
- **Note sharing** with other users (view or edit permission)

Each feature follows the same cycle: **Research → Plan → Implement → Test locally → Commit → Deploy**.

---

## Prerequisites

Before starting, make sure everything from Phase 3 is in place:

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

> **Skill tip**: Each prompt uses one `/skill-name` slash command — Copilot only processes the first slash command per message. Both skills are installed in `.agents/skills/` and Copilot will also apply them automatically based on context.

---

## Feature 1: Profile Picture

**Concepts practiced**: Supabase Storage buckets, path-based storage policies, signed URLs, upsert pattern for single-file-per-user, avatar display in UI

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 1.1: Research

Open Copilot Chat in **Ask mode**:

```
@workspace /supabase-postgres-best-practices How does Supabase Storage work? What's the
difference between a public and private bucket, and which should I use for profile pictures?
What storage policy pattern gives each user access only to their own avatar file?
```

**What to look for in the response**:
- Use a **private bucket** even for avatars — display them via short-lived signed URLs rather than a permanent public link
- Store the file under a path that starts with the user's own ID — this is what lets a policy verify ownership
- Use a fixed filename per user (no random suffix needed, since there's only ever one avatar per user)
- Storage policies are separate from table RLS — they control who can read and write files in a bucket

```
@workspace /supabase-postgres-best-practices Should I store the avatar URL in the users table
or always derive it from the storage path? What are the tradeoffs?
```

**What to look for**:
- Store only the **file path** in the database — never the signed URL itself, since signed URLs expire and must be regenerated each time
- Having the path in the database lets you check whether a user has an avatar without making an extra storage API call
- Alternatively, skip the database column and always derive the path from the user's ID — simpler, but you won't know at query time whether an avatar actually exists

```
@workspace /vercel-react-best-practices What's the right way to handle a single-file replace
(upsert) in React — e.g. uploading a new avatar that replaces the old one? How should I show
the current avatar and a loading state while the new one uploads?
```

**What to look for**:
- Use an upsert upload — this replaces the existing file at that path instead of creating a duplicate or throwing an error
- After a successful upload, regenerate the signed URL and update local state so the new avatar appears immediately
- Show a spinner overlay on the avatar during upload; avoid disabling the entire profile panel
- Validate the image type and file size client-side before uploading (images only, max 2 MB)

### Step 1.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices
Add profile picture support to the notes app using Supabase Storage.

Backend:
- New migration that:
  - Adds a nullable avatar path column to the users table to record where the avatar is stored
  - Creates a private bucket called "avatars"
  - Read and write storage policies: owner-only (file path starts with the user's own ID)

Frontend:
- In the profile panel:
  - Show the current avatar or a placeholder with the user's initials if none exists
  - Add a camera icon overlay that opens a file picker when clicked
  - Validate that the file is an image and under 2 MB before uploading — show an error if not
  - Upload as an upsert so a new upload replaces the existing avatar rather than creating a duplicate
  - On success, save the file path in the database and immediately refresh the avatar in the header
  - Show a spinner overlay during upload
- In the header: display the avatar or initials fallback, loaded once on sign-in
- Never save signed URLs to the database — always generate them from the stored path at display time

Implementation order: write the migration first, apply it with `supabase migration up`, regenerate TypeScript types with `supabase gen types typescript --local > frontend/src/database.types.ts`, then write the frontend code using the generated types.
```

Review the plan carefully. Confirm:
- The bucket is named `avatars` (separate from the `attachments` bucket you'll create in Feature 2)
- Read and write storage policies are owner-only (shared-viewer access is added later in Feature 3)
- The upload replaces any existing avatar rather than creating a duplicate
- File type and size are validated before uploading, not after
- Signed URLs are never stored in the database

### Step 1.3: Implement

Switch to **Agent mode** and click **Implement**.

> **Reminder**: You can use **Autopilot** mode (see Phase 3 intro) to let the agent run terminal commands and apply changes without confirmation prompts.

### Step 1.4: Test Locally

1. Verify the bucket was created: open **Supabase Studio** → **Storage** → confirm an `avatars` bucket exists and is marked **Private**
2. Refresh `http://localhost:5173` and open the profile panel
3. Upload a JPEG avatar → verify it appears in the header immediately after upload
4. Upload a new image (to replace the first) → verify the new avatar replaces the old one in the header
5. Try uploading a `.exe` file → verify the frontend rejects it before uploading
6. Try uploading an image over 2 MB → verify it's caught client-side
7. Sign out and back in → verify the avatar is still displayed (fetched from `avatar_path` on mount)
8. Check **Supabase Studio → Storage → avatars** — confirm there is only one object per user (upsert replaced, not duplicated)
9. Sign out, sign in as a different test user → verify you **cannot** generate a signed URL for the other user's avatar (the storage policy should reject the request)

> **Important**: Local Supabase Storage stores files inside Docker volumes. Files do **not** persist across `supabase db reset`.

### Step 1.5: Stage, Review & Commit

1. Open **Source Control** (`Ctrl+Shift+G`)
2. Review the changed files — you should see:
   - A new migration file in `supabase/migrations/`
   - Modified `frontend/src/components` (profile panel — avatar upload)
   - Modified `frontend/src/App.jsx` (header avatar display, signed URL fetch)
   - Modified `frontend/src/App.css` (avatar styles, spinner overlay)
   - Updated `frontend/src/database.types.ts`
3. Stage all changes
4. Commit: `feat: profile picture upload with private avatars bucket and upsert`

### Step 1.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

> **Production note**: After `supabase db push`, verify the `avatars` bucket appears in your **Supabase Cloud dashboard → Storage** and that its policies are listed. Test the upload flow in production before moving on.

---

## Feature 2: File Attachments

**Concepts practiced**: Supabase Storage buckets, storage RLS policies, signed URLs, metadata table, client-side file validation, upload progress, file deletion

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 2.1: Research

Open Copilot Chat in **Ask mode**:

```
@workspace /supabase-postgres-best-practices I already have a private 'avatars' storage bucket
from Feature 1. Now I want a separate private 'attachments' bucket for note file attachments.
What path structure should I use so the storage policy can verify ownership? What's the cleanest
way to link uploaded files to notes in Postgres — a separate metadata table?
```

**What to look for in the response**:
- Use a separate bucket called `attachments` — mixing avatars and note files in one bucket makes policies harder to reason about
- Structure the file path so the first folder is the user's own ID — this is what lets the storage policy verify ownership
- Store only file metadata in the database (file name, path, size, type, which note it belongs to) — never the file itself
- Signed URLs are short-lived and must be regenerated whenever you display a file — never store them in the database

```
@workspace /supabase-postgres-best-practices Should file deletion cascade when the parent note
is deleted? What indexes do I need on the note_attachments table?
```

**What to look for**:
- A metadata table with a foreign key to notes that cascades on delete — removing a note automatically cleans up its attachment metadata rows (the actual storage objects still need to be deleted separately)
- An index on the note ID column for fast "all files for this note" lookups
- An index on the uploader's user ID to support storage policy checks

```
@workspace /vercel-react-best-practices What's the right way to handle file upload state in
React — progress tracking, error states, cancellation? How should I validate file type and size
before sending to the server?
```

**What to look for**:
- Validate file type (images and PDFs only) and size (max 10 MB) on the client before starting any upload
- Track upload state per file so the UI can show idle, uploading, success, or error
- Show a spinner or progress indicator during upload — file uploads can take time on slow connections
- Generate a collision-safe filename using a timestamp and a random ID — never use the browser's original filename directly

### Step 2.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices
Add file attachments to the notes app using Supabase Storage.

Backend:
- New migration that:
  - Creates a metadata table for attachments, linked to the notes table with a cascade on delete, storing the file name, storage path, size, type, and uploader
  - Indexes on the note ID and the uploader's user ID
  - RLS: owners can read and add attachments but not edit them once uploaded
  - Creates a private bucket called "attachments" where each user can only access files stored under their own user ID folder

Frontend:
- In the note editor: add an "Attach file" button that opens a file picker
- Before uploading, validate that the file is an image or PDF and under 10 MB — show an error if not
- Generate a collision-safe filename before uploading (a timestamp plus a random ID plus the original name)
- After a successful upload, save the file metadata (name, path, size, type) to the database
- Show a loading spinner during upload
- On note cards: fetch attachments alongside the note and show image thumbnails for images and a file icon for PDFs
- Generate signed URLs for display at render time — never store them in the database
- Deleting an attachment should remove both the file from storage and the metadata row, and update the UI immediately (optimistic)

Implementation order: write the migration first, apply it with `supabase migration up`, regenerate TypeScript types with `supabase gen types typescript --local > frontend/src/database.types.ts`, then write the frontend code using the generated types.
```

Review the plan carefully. Confirm:
- The migration creates a separate attachments metadata table, not a column on the notes table
- The bucket is named `attachments` — separate from the `avatars` bucket from Feature 1
- Read and write storage policies are owner-only (shared-viewer access is added later in Feature 3)
- File type and size are validated before uploading
- Signed URLs are never stored in the database

### Step 2.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 2.4: Test Locally

1. Verify the bucket was created: open **Supabase Studio** → **Storage** → confirm an `attachments` bucket exists and is marked **Private**
2. Refresh `http://localhost:5173` and open a note for editing
3. Attach a JPEG image → verify it uploads and shows as a thumbnail on the note card
4. Attach a PDF → verify it shows a file icon and filename
5. Try attaching a `.exe` file → verify the frontend rejects it with an error message before uploading
6. Try attaching a file over 10 MB → verify it's caught client-side
7. Delete an attachment → verify the thumbnail disappears and the file is removed from Storage (check **Supabase Studio → Storage → attachments**)
8. Sign out, sign in as a different test user → verify you **cannot** access the first user's files (attempt a direct signed URL from User A while logged in as User B — it should fail)
9. Delete a note that has attachments → verify the attachment metadata rows are removed (cascade); also manually confirm the storage objects were cleaned up if your implementation handles that on delete

> **Important**: Local Supabase Storage stores files inside Docker volumes. Files do **not** persist across `supabase db reset`.

### Step 2.5: Stage, Review & Commit

1. Open **Source Control** (`Ctrl+Shift+G`)
2. Review the changed files — you should see:
   - A new migration file in `supabase/migrations/`
   - Modified `frontend/src/components/NoteEditor.jsx` (file input, upload logic)
   - Modified `frontend/src/components/NoteList.jsx` or `NoteCard` (attachment rendering, signed URLs)
   - Modified `frontend/src/App.jsx` or data-fetching layer (nested select for attachments)
   - Modified `frontend/src/App.css` (thumbnail and file icon styles)
   - Updated `frontend/src/database.types.ts`
3. Stage all changes
4. Commit: `feat: file attachments with private storage bucket, signed URLs, and client validation`

### Step 2.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

> **Production note**: After `supabase db push`, the storage bucket and its policies are created by the migration. Verify the `attachments` bucket appears in your **Supabase Cloud dashboard → Storage** before testing the live app.

---

## Feature 3: Share Notes

**Concepts practiced**: cross-user data access, extending RLS policies to cover shared records, extending storage bucket policies for shared viewers, SECURITY DEFINER functions for safe user lookup, permission enums, many-to-many with access control

**Skills used**: `supabase-postgres-best-practices`, `vercel-react-best-practices`

### Step 3.1: Research

Open Copilot Chat in **Ask mode**:

```
@workspace /supabase-postgres-best-practices I want to let a note owner share a note with
another user by email. What schema do I need? How do I extend the existing notes RLS SELECT
policy to also allow shared users to read a note? How do I prevent one policy from leaking
other users' notes?
```

**What to look for**:
- A separate table linking notes to the users they're shared with, along with a permission field
- The existing notes read policy must be *extended* with an OR condition — never replaced — to avoid locking out existing owners
- Each policy condition should be as narrow as possible to avoid accidentally leaking data
- An index on the shared-with user column, since that's how the "notes shared with me" query filters

```
@workspace /supabase-postgres-best-practices How do I let users look up other users by email
to share a note with them? I can't let anyone query the users table directly — that would
expose all accounts. What's the safe pattern?
```

**What to look for**:
- A database function that looks up a user by exact email and returns only their ID and display name — nothing else from the profile
- The function should run with elevated privileges so it can bypass RLS, but must only expose those two safe fields
- Execution should be granted to signed-in users only, not to anonymous visitors
- It should only match exact email addresses and return at most one result

```
@workspace /supabase-postgres-best-practices How do I model two permission levels — view and
edit — for shared notes? Should I use a text column with a CHECK constraint or a Postgres enum?
What RLS do I write for UPDATE access on shared notes?
```

**What to look for**:
- A database enum type for the two permission levels (view and edit) — safer than a free-text column because the database enforces valid values
- The update policy on notes must be extended (not replaced) to also allow users with edit permission
- Users with edit permission can change note content, but pinning, archiving, and deleting remain owner-only

```
@workspace /supabase-postgres-best-practices The notes app has two private storage buckets from
earlier features: 'avatars' (Feature 1) and 'attachments' (Feature 2). Both currently have
owner-only read policies. Now that I'm adding a note_shares table, I want to extend the read
policies on both buckets so that users who have been shared a note can also view the note owner's
avatar and that note's attachments. How should I extend the storage SELECT policies? Write
policies should remain owner-only.
```

**What to look for**:
- Each bucket's read policy gets an OR condition: the file owner, or a user who has a row in the shares table for the relevant note
- The avatars policy checks whether the viewer has been shared any note by the file owner
- The attachments policy checks whether the viewer has been shared the specific note that the attachment belongs to (requires joining through the metadata table)
- Write policies (upload, update, delete) on both buckets remain strictly owner-only
- When a share is revoked, the viewer automatically loses access — no extra cleanup needed

### Step 3.2: Plan

Switch to **Plan mode**:

```
/supabase-postgres-best-practices
Add note sharing so the note owner can share a note with another user by email, granting either view-only or edit access. Also extend the storage bucket policies from Features 1 and 2 for shared-viewer access.

Backend:
- New migration that:
  - Creates an enum type for permissions with two values: view and edit
  - Creates a shares table linking notes to users, with the permission level defaulting to view
  - Prevents a user from sharing a note with themselves
  - Prevents duplicate shares for the same note and user
  - Indexes on both the note ID and the shared-with user ID
  - RLS: the shared user and the note owner can read a share row; only the note owner can create or revoke shares
  - Extends the notes read policy to also allow users listed in the shares table (using OR, not replacing the existing condition)
  - Extends the notes update policy to also allow users who have edit permission (using OR)
  - Delete, pin, and archive remain owner-only
  - Creates a database function that looks up a user by exact email and returns only their ID and display name, callable only by signed-in users
  - Extends the avatars bucket read policy so users who have been shared a note can also view the note owner's avatar
  - Extends the attachments bucket read policy so users who have been shared a note can also view that note's attachments
  - Write policies on both storage buckets remain owner-only

Frontend:
- Add a "Share" button on note cards (visible to the owner only)
- A share panel where the owner can enter an email, choose view or edit permission, and share the note
- Show who the note is already shared with and allow revoking individual shares
- A "Shared with me" section showing notes received from other users
- In the "Shared with me" view: show the note owner's avatar next to the "shared by" label
- On shared note cards: show the note's attachments (thumbnails and file icons) loaded via signed URLs
- Hide attachment management controls (upload and delete) on shared notes — viewers can see but not manage
- Notes shared with view permission: show the note but disable editing
- Notes shared with edit permission: allow editing content but hide pin, archive, and delete
- Never show the Share button on notes in the "Shared with me" view

Implementation order: write the migration first, apply it with `supabase migration up`, regenerate TypeScript types with `supabase gen types typescript --local > frontend/src/database.types.ts`, then write the frontend code using the generated types.
```

Review the plan carefully. Confirm:
- There is a constraint preventing a user from sharing a note with themselves
- There is a unique constraint preventing duplicate shares for the same note and user
- The user lookup function is callable by signed-in users only — not anonymous visitors
- The notes read and update policies are extended with OR conditions, not replaced
- The avatars and attachments bucket read policies are extended to allow shared-note viewers
- Write policies on both storage buckets remain owner-only
- The frontend hides destructive actions (pin, archive, delete) for users with edit permission
- Attachment management controls (upload and delete) are hidden on shared notes

### Step 3.3: Implement

Switch to **Agent mode** and click **Implement**.

### Step 3.4: Test Locally

You'll need two accounts for this feature. Create a second test user in Supabase Studio or by signing up in an incognito window.

1. Sign in as **User A**. Open a note → click **Share** → enter User B's email → choose **View** → click **Share**
2. Verify the share appears in the panel: "User B — View [Revoke]"
3. Open an **incognito window** → sign in as **User B**
4. Verify the shared note appears in User B's "Shared with me" section
5. As User B, try to edit the note → verify the editor controls are disabled (view-only)
6. Back as User A, revoke the share → verify the note disappears from User B's view on next refresh
7. Share the note again with **Edit** permission
8. As User B, edit the note content → save → verify it persists
9. As User B, verify the **pin**, **archive**, and **delete** buttons are hidden or disabled
10. Try sharing a note with your own email (User A) → verify the error is caught (either the `CHECK` constraint rejects it or the frontend prevents it)
11. Try sharing a note with a non-existent email → verify the "no user found" message appears
12. Check Supabase Studio → `note_shares` table → confirm the rows are correct
13. **Shared-viewer avatar check**: As User B, verify that User A's avatar is visible next to the "shared by" label on the shared note card
14. **Shared-viewer attachments check**: As User A, add an attachment to the shared note. As User B, verify the attachment thumbnail or file icon loads correctly via signed URL
15. As User B, verify the "Attach file" button and delete controls are **not** visible on the shared note — viewers can see attachments but not manage them
16. Revoke the share → as User B, verify that signed URLs for User A's avatar and attachments no longer work

> **Security check**: Open the Supabase Studio SQL editor and run:
> ```sql
> SELECT * FROM notes; -- as postgres superuser, all rows visible
> ```
> Then verify in the app (as User B) that only the explicitly shared note appears — no other notes from User A are accessible.

### Step 3.5: Stage, Review & Commit

1. Open **Source Control** (`Ctrl+Shift+G`)
2. Review the changed files — this is one of the larger changesets:
   - A new migration file (enum, table, indexes, RLS policy extension, SECURITY DEFINER function, storage policy extension)
   - Modified `frontend/src/components/NoteEditor.jsx` (permission-aware edit controls)
   - Modified `frontend/src/components/NoteList.jsx` (share button, share panel, "Shared with me" view)
   - Modified `frontend/src/App.jsx` (shared notes query, share state)
   - Modified `frontend/src/App.css` (share panel, permission badges)
   - Updated `frontend/src/database.types.ts`
3. Stage all changes
4. Commit: `feat: note sharing with view/edit permissions, SECURITY DEFINER user lookup, and shared-viewer storage access`

### Step 3.6: Deploy

Follow the [Deployment Checklist](#deployment-checklist-after-each-feature).

> **Production note**: The `find_user_by_email` function queries the `users` table which must contain email addresses. Confirm that your cloud `users` table is populated from `auth.users` (your Phase 2 trigger or seed does this). If the function returns no results in production, check that the user who was shared with has signed in at least once so their row exists in `users`.

---

## Deployment Checklist (After Each Feature)

After every feature, follow this exact sequence to deploy your changes.

### 1. Push Schema to Supabase Cloud (if a migration was added)

Skip this step if the feature was frontend-only (no new file in `supabase/migrations/`).

```powershell
supabase db push
```

This applies any new migrations to your cloud database. Review the output — it shows which migration files were applied.

### 2. Push to GitHub

```powershell
git push
```

Or in VS Code: **Source Control** → **⋯** → **Push**

Vercel automatically detects the push and rebuilds your frontend. The new deployment goes live within ~60 seconds.

### 3. Verify Production

1. Open your Vercel URL (e.g. `https://my-first-fullstack.vercel.app`)
2. Test the feature you just deployed
3. If something is broken, check:
   - **Vercel build logs**: Vercel dashboard → your project → Deployments → latest → click to see logs
   - **Schema mismatch**: did you forget `supabase db push`?
   - **Environment variables**: are `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` set in Vercel to your **cloud** credentials?

---

## Summary

You've completed Phase 4. Here's what you practiced:

| Feature | Backend Concepts | Frontend Concepts | Skills Used |
|---|---|---|---|
| Profile Picture | Private bucket, path-based owner-only storage policies, upsert, avatar_path column | File validation (type + size), signed URL refresh, spinner overlay, initials fallback | supabase-postgres, vercel-react |
| File Attachments | Storage buckets, path-based owner-only storage policies, signed URLs, metadata table, cascade delete | File validation (type + size), upload state, thumbnail rendering | supabase-postgres, vercel-react |
| Share Notes | Permission enum, note_shares join table, extended RLS policies, extended storage read policies, SECURITY DEFINER function | Permission-aware UI, user lookup, share panel, shared-with-me view, shared-note avatar + attachment display, hidden attachment controls | supabase-postgres, vercel-react |

**Workflow mastered**: Research → Plan → Implement → Test → Commit → Deploy

**Skills catalog** — all installable via `npx skills add`:

| Skill | Install Command | When to use |
|---|---|---|
| Supabase Postgres Best Practices | `npx skills add supabase/agent-skills` | Schema design, migrations, RLS, indexes, queries |
| React Best Practices (Vercel) | `npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices` | Components, state, effects, performance patterns |

---

## Quick Reference: Phase 4 Commands

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
