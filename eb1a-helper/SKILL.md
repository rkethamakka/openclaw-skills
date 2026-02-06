---
name: eb1a-helper
description: Manage EB1A application tasks from Asana, draft articles/content following templates, save to Google Drive, and reply to tasks. Use when working on EB1A visa application tasks, writing scholarly articles, or managing EB1A Experts workflow.
---

# EB1A Helper

Manage EB1A application workflow: Asana tasks → Draft content → Save to Drive → Reply on Asana.

## Config

Load config from: `skills/eb1a-helper/config.json`

```json
{
  "asana": {
    "workspace_url": "https://app.asana.com/1/1205769749443087/home",
    "project_url": "https://app.asana.com/1/1205769749443087/project/1210378985945683/list/1210378985945707",
    "project_name": "242054. ${LAST_NAME} ${FIRST_NAME}"
  },
  "drive": {
    "root": "${HOME}/Library/CloudStorage/GoogleDrive-${EMAIL_ALT}/.shortcut-targets-by-id/1RK1CYuGqyt7sr5BkONcvMan9hjl0hH69/${LAST_NAME} ${FIRST_NAME}"
  }
}
```

## Trigger Phrases

- "Show my EB1A tasks"
- "What's overdue on EB1A?"
- "Open task [name]"
- "Help me with [task name]"
- "Draft article for [topic]"
- "Write scholarly article"
- "Reply to task [name]"
- "Save to Drive"

---

## Scholarly Articles Workflow

### Folder Structure

```
{drive.root}/Scholarly Articles/
├── PLAN.md                           ← Master plan for all articles
├── Articles_old.md                   ← Old abstracts (reference only)
├── Template_new.docx                 ← EB1A Experts template
├── Article1_[ShortName].docx         ← Individual article files
├── Article2_[ShortName].docx
└── ...
```

### New Template Format (EB1A Experts 2025)

**Each article must be:**
- **6 pages** in length (not short abstracts)
- **Numbered sections:** 1, 2, 3, 4, 5, 6
- **Subsections:** 2.1, 2.2, 3.1, 3.2, etc.
- **One detailed paragraph per subsection**
- **Research-style statistics and citations**
- **No abbreviations without explanation**

**Article Structure:**
```
# [Article Title]

## 1. Introduction
[Two long paragraphs setting up the problem and article scope]

## 2. [Main Section Title]

### 2.1 [Subsection Title]
[One detailed paragraph with statistics and examples]

### 2.2 [Subsection Title]
[One detailed paragraph with statistics and examples]

## 3. [Main Section Title]

### 3.1 [Subsection Title]
[One detailed paragraph]

### 3.2 [Subsection Title]
[One detailed paragraph]

## 4. [Main Section Title]
...continues with same pattern...

## 5. [Main Section Title]
...continues...

## 6. [Conclusion/Future Directions]

### 6.1 [Subsection Title]
[One detailed paragraph]

### 6.2 [Subsection Title]
[One detailed paragraph]
```

### 7 Categories

1. **Expertise-Specific Concepts** — Simplify complex topics for beginners
2. **Research and Innovations** — Latest developments, cutting-edge trends
3. **Success Stories and Applications** — Real-world case studies, lessons learned
4. **Tips and Advice** — Career guidance, practical strategies
5. **Industry-Specific Applications** — Impact on healthcare, retail, etc.
6. **Your Field and Society** — Broader societal impact, ethics
7. **AI and Human-AI Collaboration** — (only for automation-type fields)

### Writing Workflow

**Step 1: Update PLAN.md**
- Define article title and focus
- Note what to include / exclude
- Track status: [ ] Outline → [ ] Draft → [ ] Refine → [ ] Review → [ ] Final
- Mark articles needing refinement with user-provided examples later

**Step 2: Write Article as .docx**
- Use python-docx to create proper Word document
- Follow the 6-page structure exactly
- Include diagram placeholders where appropriate

**Step 3: Save to Scholarly Articles folder**
- Filename: `Article[N]_[ShortName].docx`
- Example: `Article1_UDP_Architecture.docx`

**Step 4: Update PLAN.md status**

### Creating .docx Files

Use python-docx for proper Word formatting:

```python
from docx import Document
from docx.shared import Pt, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = Document()

# Title
title = doc.add_heading('Article Title', 0)
title.alignment = WD_ALIGN_PARAGRAPH.CENTER

# Category/Priority line
doc.add_paragraph('Category 1: Expertise-Specific Concepts (Priority 1)')
doc.add_paragraph('---')

# Section 1
doc.add_heading('1. Introduction', level=1)
doc.add_paragraph('First paragraph of introduction...')
doc.add_paragraph('Second paragraph of introduction...')

# Section 2
doc.add_heading('2. Section Title', level=1)
doc.add_heading('2.1 Subsection Title', level=2)
doc.add_paragraph('Detailed paragraph for subsection 2.1...')
doc.add_heading('2.2 Subsection Title', level=2)
doc.add_paragraph('Detailed paragraph for subsection 2.2...')

# Continue pattern for sections 3-6...

# Save
doc.save('{drive.root}/Scholarly Articles/Article1_Name.docx')
```

### Guidelines

- **Generic content** — No company-specific details
- **No unexplained abbreviations** — Always expand on first use
- **Research style** — Include statistics, percentages, industry analyses
- **Academic tone** — Suitable for scholarly publication
- **Diagram placeholders** — Note where visuals should go

### Category-Specific Writing Styles

**Category 1 (Expertise-Specific Concepts):**
- **BEGINNER-FRIENDLY** — Write for non-technical readers
- Use **analogies** (e.g., "like a security guard at a building entrance")
- Explain "what" and "why" before "how"
- Avoid deep technical jargon
- Include simple, relatable examples throughout

**Category 2 (Research and Innovations):**
- Can be more technical — for readers familiar with the field
- Focus on cutting-edge developments and trends
- Include implementation details and real metrics
- Your journey/experience fits here

### Article Refinement Tracking

Articles may need refinement after initial draft. Track in PLAN.md:
```
**Status:** [x] Draft → [ ] Refine (awaiting examples) → [ ] Review → [ ] Final
**Refinement Notes:** [What needs to be added/changed]
```

---

## Other Capabilities

### 1. Show Tasks

List overdue and upcoming tasks from Asana.

**Steps:**
1. Open browser with profile "openclaw"
2. Navigate to workspace URL or use existing Asana tab
3. Take snapshot of "My tasks" section
4. Parse overdue/upcoming tasks
5. Present summary

### 2. Open Task

Pull full details for a specific task.

**Steps:**
1. Click on task name in Asana
2. Wait for task modal to open
3. Extract: Title, Due date, Description, Comments
4. Present task details and required actions

### 3. Reply to Task

Post a comment update on an Asana task.

**Steps:**
1. Ensure task modal is open in browser
2. Find comment input field
3. Type the reply message
4. Click "Comment" button

### 4. Save to Drive

Write completed work to the appropriate Google Drive folder.

**Folder mapping:**
| Task Type | Drive Folder |
|-----------|--------------|
| Awards | `{drive.root}/Awards/` |
| Articles | `{drive.root}/Scholarly Articles/` |
| Judging | `{drive.root}/Judging/` |
| Media | `{drive.root}/Media/` |
| Membership | `{drive.root}/Membership/` |
| Speaking | `{drive.root}/Speaking Opportunity/` |

---

## Browser Notes

- **Profile:** Use `profile="openclaw"` for isolated browser
- **Login:** User should be logged into Asana already
- **Task modal:** Tasks open in a dialog/modal overlay

## EB1A Criteria Reference

For context, EB1A has 10 criteria (need 3+):

1. **Awards** — Nationally/internationally recognized prizes
2. **Membership** — Membership in associations requiring outstanding achievement
3. **Published material** — About the person in professional publications
4. **Judging** — Participation as a judge of others' work
5. **Original contributions** — Of major significance to the field
6. **Scholarly articles** — Authorship of scholarly articles
7. **Exhibitions** — Display of work at artistic exhibitions
8. **Leading role** — In distinguished organizations
9. **High salary** — Commanding a high salary relative to others
10. **Commercial success** — In performing arts

---

*EB1A Helper — Tasks → Content → Drive → Reply*
