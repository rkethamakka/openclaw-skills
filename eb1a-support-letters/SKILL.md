---
name: eb1a-support-letters
description: Manage support letters for EB1A application. Use when working on support response forms, innovative contributions, letter drafts, or recommender management.
---

# EB1A Support Letters

Manage support letters for Critical Role and Original Contributions criteria.

## Shared Config

Load config from: `skills/eb1a-data/config.json`

## Asana Section

**Support Letters** section in the EB1A project.

## Trigger Phrases

- "Show support letter tasks"
- "Help with support letters"
- "Support response form"
- "Innovative contributions form"
- "Draft support letter"
- "Check support letter status"

---

## Overview

Support letters are used for:
- **Critical Role** criterion
- **Original Contributions** criterion
- Sometimes **Media** criterion

**Workflow:**
1. Client completes forms (Support Response Form + Innovative Contributions Form)
2. EB1A team drafts letters based on input
3. Client + Attorney review and refine
4. Get signatures from recommenders
5. Share signed letters with attorney

---

## Client Action Items

1. **Download the support letter folder** from Drive link
2. **Review the support letter guide**
3. **Complete Support Response Form** - Details about each recommender
4. **Complete Innovative Contributions Form** - Detailed descriptions (the more detail, the better letters)
5. **Provide feedback** on letter drafts
6. **Get signatures** from recommenders
7. **Share signed letters** with attorney

---

## Folder Structure

```
Support Letter Guide (shared folder):
https://drive.google.com/drive/folders/${SUPPORT_LETTER_FOLDER_ID}

{drive.root}/ (local, if synced):
├── Support Letters/
│   ├── Support_Response_Form.docx
│   ├── Innovative_Contributions_Form.docx
│   ├── Letter_Draft_[Recommender].docx
│   └── Signed/
│       └── [Recommender]_Signed.pdf
```

---

## Forms

### Support Response Form
- Recommender name and title
- Relationship to you
- How long they've known you
- What they can speak to (projects, skills, impact)

### Innovative Contributions Form
- Detailed descriptions of your innovations
- Impact and significance
- Metrics and evidence
- Who was affected and how

**⚠️ More detail = Better letters!**

---

## Letter Drafting (TODO)

*To be developed iteratively*

Workflow:
1. Read completed forms
2. Identify key points for each recommender
3. Draft letter following EB1A Experts template
4. Save to Drive
5. Notify client for review

---

## Recommender Management (TODO)

*To be developed iteratively*

Track:
- Recommender name, title, org
- Contact info
- Letter status (Draft / Review / Signed)
- Follow-up dates

---

## Asana Integration

**Task:** Support Letters > Overview
- Check task for current status
- Read comments for updates from EB1A team
- Reply with questions or status updates

**Open task:**
```
browser action=open profile=openclaw 
  targetUrl="https://app.asana.com/1/${ASANA_WORKSPACE_ID}/project/${ASANA_PROJECT_ID}/task/${ASANA_TASK_ID}"
```

---

## Status Flow

```
[ ] Forms Not Started
[ ] Forms In Progress
[ ] Forms Submitted
[ ] Strategy Sheet Created
[ ] Letters Drafted
[ ] Client Review
[ ] Attorney Review
[ ] Getting Signatures
[ ] Complete
```

---

*eb1a-support-letters - Support Letters for Critical Role & Original Contributions*
