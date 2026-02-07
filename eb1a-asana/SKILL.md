# eb1a-asana

Check EB1A Asana project status, tasks, and progress.

## When to Use

- "Check my EB1A progress"
- "What's pending in Asana?"
- "Any overdue EB1A tasks?"
- "Do I need to respond to anything in Asana?"
- "EB1A dashboard"
- "Show EB1A tasks by status"
- "Show EB1A tasks by section"
- "What's in Client Review?"
- "How many tasks are completed?"

## Project Details

- **Project**: 242054. ${LAST_NAME} ${FIRST_NAME}
- **URL**: https://app.asana.com/1/1205769749443087/project/1210378985945683/list/1210378985945707
- **Profile**: openclaw (isolated browser)

## Sections (Categories)

| Section | Description |
|---------|-------------|
| Project Support | Drive links, guides, intake forms |
| Onboarding | Initial setup tasks |
| Field of Expertise (FOE) | FOE evaluation |
| Media | Research and publish media |
| Awards | Award applications |
| Judging | CMT paper reviewing (Type 1 & 2) |
| Memberships | Professional membership applications |
| Scholarly Articles | Article writing and review |
| Support Letters | Recommender letters |
| Speaking Opportunities | Conference speaking |
| Merit Guide | Final merit guide review |
| Attorney | Attorney coordination |

## Task Statuses

- **Planned** - Not started
- **In Progress** - Work ongoing
- **Client Review** - Needs your action/review
- **Completed** - Done

## Workflow

### 1. Open Asana Project

```
browser action=open profile=openclaw targetUrl="https://app.asana.com/1/1205769749443087/project/1210378985945683/list/1210378985945707"
```

### 2. Take Snapshot

```
browser action=snapshot
```

### 3. Parse Task List

From the snapshot, extract:
- Task name
- Status (Planned/In Progress/Client Review/Completed)
- Assignee (NK = ${FULL_NAME})
- Due date
- Comment count

### 4. Identify Action Items

**Priority 1 - Needs Response:**
- Tasks with "Client Review" status assigned to NK
- Tasks with recent comments from EB1A team (not from NK)

**Priority 2 - Overdue:**
- Tasks past due date that aren't Completed

**Priority 3 - In Progress:**
- Active work items

### 5. Check Task Details

For tasks needing review, click to open and check:
- Latest comments (who said what, when)
- Whether NK's response is the last comment
- Any pending questions

### 6. Generate Report

**Default View (by priority):**

```
## EB1A Progress Report

### Needs Your Response (X tasks)
- [Task Name] - [Section] - Last comment from [Person] on [Date]

### Overdue (X tasks)  
- [Task Name] - Due [Date] - Status: [Status]

### In Progress (X tasks)
- [Task Name] - [Section]

### Completed Recently
- [Task Name] - Completed [Date]

### Summary
- Total tasks: X
- Completed: X (X%)
- In Progress: X
- Needs Attention: X
```

**By Status View** (when user asks "tasks by status"):

```
## EB1A Tasks by Status

### Client Review (X) - YOUR ACTION NEEDED
- [Task] - [Section] - Due [Date]
- [Task] - [Section] - Due [Date]

### In Progress (X)
- [Task] - [Section] - Assignee: [Name]
- [Task] - [Section] - Assignee: [Name]

### Planned (X)
- [Task] - [Section] - Due [Date]
- [Task] - [Section] - Due [Date]

### Completed (X)
- [Task] - [Section]
- [Task] - [Section]

### No Status (X)
- [Task] - [Section]
```

**By Section View** (when user asks "tasks by section"):

```
## EB1A Tasks by Section

### Judging
- [Task] - Status: [Status] - Due [Date]

### Support Letters  
- [Task] - Status: [Status] - Due [Date]

### Scholarly Articles
- [Task] - Status: [Status] - Due [Date]

(etc for each section)
```

## Team Members

| Initials | Name | Role |
|----------|------|------|
| NK | ${FULL_NAME} | Client (you) |
| CR | Cheppalli Tejovyas Reddy | Support Letters |
| EV | Emmadi Vinay | Media, Awards |
| VI | Vinay Kumar Iduri | Judging, Articles |
| VG | Venu Yadav Golla | Memberships |
| KP | Kaizad Pilcher | Memberships |
| MF | Mohammed Faisal | Speaking |
| RY | Rama Krishna Yandrapu | Team Lead |
| Ad | Admin | Project Admin |

## Tips

- Comments needing response usually mention @${FULL_NAME}
- "Client Review" status = ball is in your court
- Check "X more comments" button to see full history
- Task checkbox = completed (ignore for active tracking)
