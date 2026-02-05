---
name: job-apply
description: Apply to jobs via browser automation. Use when Raki wants to submit applications, fill job forms, or apply to roles at a company.
---

# Job Apply

Browser automation for job applications.

## Shared Data

Profile and file paths: `skills/job-data/profile.json`

## User Preferences

**⚠️ FOLLOW THESE RULES:**

1. **No excessive screenshots** — Provide text summaries of form state
2. **Use `profile="openclaw"`** — Always use the managed browser profile
3. **Resume upload on Lever = ALWAYS manual** — Don't attempt automation
4. **Batch manual steps** — Fill everything automatable, THEN ask user once
5. **Know the profile** — Use documented values, don't ask what you already know
6. **ALWAYS write essay questions** — Even if marked optional

## Trigger Phrases

- "Apply to [Company]"
- "Submit applications for [Company]"
- "Let's apply to [Company]"
- "Fill out application for [Role]"

## Application Workflow

### Step 1: Lookup Roles

Get roles from tracker (use job-tracker skill):
```python
roles = get_company_roles(doc, "Anthropic")
# Returns: company, location, status, referrer, roles with URLs
```

### Step 2: Check Cover Letters

For each role, check if cover letter exists:
```
ravi_jobs/[Company]/[Role_Short_Name]_Cover.docx
```

**If missing:** Use cover-letter skill to generate, then return here.

### Step 3: Confirm with Raki

```
🚀 Ready to apply to [Company]

Roles (5):
1. Senior SWE, Infrastructure ✅ Cover letter ready
2. Staff SWE, Cloud Inference ✅ Cover letter ready
3. Staff SWE, Inference ✅ Cover letter ready
4. Staff+ SWE, Infrastructure ✅ Cover letter ready
5. Staff+ SWE, Data Infrastructure ✅ Cover letter ready

Profile: ✅ Account exists
Resume: Naga_Ravi_Kiran_Resume_2026.pdf

Proceed? (yes/no)
```

### Step 4: Apply to Each Role

1. Open role URL
2. Click Apply
3. Login if needed
4. Fill form (see Form Filling below)
5. Upload resume (manual on Lever)
6. Review all fields
7. **Confirm with Raki before submit**
8. Submit

### Step 5: Update Tracker

After successful applications:
```python
target_row.cells[3].text = "Applied"
doc.save(tracker_path)
```

## Form Filling — Profile Values

**⚠️ USE THESE EXACT VALUES:**

| Field | Value |
|-------|-------|
| Full Name | Naga Ravi Kiran Kethamakka |
| First Name | Naga Ravi Kiran |
| Last Name | Kethamakka |
| Preferred Name | **Ravi** (not Raki!) |
| Email | **ravikiran.kn@gmail.com** |
| Phone | 7135621997 |
| Location | Seattle, WA, USA |
| Company | Expedia Group |
| LinkedIn | https://www.linkedin.com/in/ravikirankn/ |
| GitHub | https://github.com/rkethamakka |
| Portfolio | https://rkethamakka.github.io |
| University | University of Houston - Main Campus |
| Work Auth | Yes (authorized) |
| Sponsorship | Yes (needs H-1B) |
| Visa Status | H-1B with I-140 approved |
| Languages | English, Hindi, Telugu |
| Veteran | I am not a Protected Veteran |
| Disability | I do not want to answer |
| Pronunciation | RAH-vee KEE-run keh-tha-MAH-kka |

## Form Filling Best Practices

1. **Resume First** — Upload before other fields (may auto-fill)
2. **Verify Each Field** — Check email, preferred name after filling
3. **Re-fill after resume upload** — Auto-fill may overwrite values
4. **Check for Essays** — Fill them (see Essay Writing below)
5. **Dropdowns** — Verify selection actually saved
6. **Final Review** — List ALL fields before submit

## Essay Writing

**⚠️ ALWAYS read resume + job description FIRST!**

### Common Essay Questions

**"Favorite project / proudest accomplishment"**
- Pick project from resume that matches role themes
- Don't make up details — use actual numbers

**"Why this company?"**
- Reference specific things from job description
- Show genuine interest in their mission

### Project Matching

| Job Theme | Best Project |
|-----------|-------------|
| AI/ML, Agents | AI Agents Marketplace (2025) |
| Infrastructure, Scale | API Gateway Platform (2024-25) |
| Platform, DevEx | Control Plane (2022-24) |
| NLP, Automation | Virtual Agent Platform (2019-21) |
| Messaging, Reliability | Conversation Platform (2018-19) |

### Essay Structure

1. **Opening** — State the project and your role
2. **Challenge** — What made it hard/interesting
3. **Your contribution** — Specific technical decisions
4. **Impact** — Numbers, scale, outcomes
5. **Lesson** — What you learned (ties to their role)

**DO:**
- Use actual project details from resume
- Show scale/impact with numbers
- Describe technical decisions

**DON'T:**
- Say "this matches your role" directly
- Make up projects or embellish
- Write generic content

### Reading the Resume

```bash
python3 -c "from pypdf import PdfReader; r = PdfReader('/Users/ravikiran/Documents/Google-Drive/ravi_jobs/Naga_Ravi_Kiran_Resume_2026.pdf'); print(''.join(p.extract_text() for p in r.pages))"
```

## Portal-Specific: Lever

**⚠️ LEVER QUIRKS:**

1. **Resume upload does NOT work via automation** — User must upload manually
2. **Long dropdowns** — Use `select` action with exact value
3. **"How did you hear"** — Select "Company Website" or "LinkedIn"
4. **Signature fields** — Look for Name + Date at bottom
5. **"Additional information"** — OPTIONAL, skip unless needed

**Lever Checklist:**
- [ ] Fill basic info (name, email, phone, location, company)
- [ ] Fill links (LinkedIn, GitHub, Portfolio)
- [ ] Select languages (English, Hindi, Telugu)
- [ ] Fill Preferred Name: `Ravi`
- [ ] Fill Pronunciation
- [ ] Select Work Auth: Yes | Sponsorship: Yes
- [ ] Select University: `University of Houston - Main Campus`
- [ ] Select "How heard": Company Website / LinkedIn
- [ ] Write essays if required
- [ ] Select Veteran status
- [ ] Select Disability
- [ ] Fill signature Name + Date
- [ ] **ASK USER TO UPLOAD RESUME**
- [ ] Verify ALL fields
- [ ] Submit

**University dropdown (Lever):**
```
browser action=act request={"kind": "select", "ref": "<combobox_ref>", "values": ["University of Houston - Main Campus"]}
```

## Portal-Specific: Greenhouse

- Standard file upload usually works
- May have "Apply with LinkedIn" option
- Test upload before asking for manual help

## Portal-Specific: Workday

- Account-based — login first
- Profile auto-fill from account
- Multi-page forms

## Resume Upload

**Resume location:**
```
/Users/ravikiran/Documents/Google-Drive/ravi_jobs/Naga_Ravi_Kiran_Resume_2026.pdf
```

**Lever workaround:**
1. Fill ALL other fields first
2. Ask user to manually upload resume
3. Verify "Success!" appears
4. Re-verify form fields (auto-fill may overwrite)
5. Then submit

**Greenhouse/Workday:** Test automation first, fallback to manual.

## Browser Commands

**Start browser:**
```
browser action=start profile="openclaw"
```

**Navigate:**
```
browser action=open url="https://jobs.lever.co/company/role-id"
```

**Snapshot (find elements):**
```
browser action=snapshot
```

**Click:**
```
browser action=act request={"kind": "click", "ref": "apply-button"}
```

**Type:**
```
browser action=act request={"kind": "type", "ref": "email-input", "text": "ravikiran.kn@gmail.com"}
```

**Select dropdown:**
```
browser action=act request={"kind": "select", "ref": "dropdown", "values": ["Option Text"]}
```

**Upload file:**
```
browser action=upload paths=["/path/to/file.pdf"]
```

## Company Profiles

Track portal accounts in `skills/job-apply/portals.json`:

```json
{
  "anthropic": {
    "portal_url": "https://job-boards.greenhouse.io/anthropic",
    "portal_type": "greenhouse",
    "has_account": true,
    "notes": "Uses Google OAuth"
  }
}
```

## Error Handling

| Issue | Action |
|-------|--------|
| Form field not found | Screenshot, ask Raki |
| Login failed | Prompt for manual login |
| Upload failed | Try alternative or manual |
| CAPTCHA | Pause, ask Raki to solve |
| Rate limited | Wait and retry |

## Safety

**ALWAYS:**
- Confirm with Raki before submitting
- Take screenshot before final submit
- Pause on unexpected fields
- Review ALL fields before clicking submit

**NEVER:**
- Auto-submit without confirmation
- Skip cover letter review
- Apply to roles not in tracker
- Assume fields are correct

## Multi-Role Applications

When applying to multiple roles at same company:

1. **First application:** Fill everything, ask for manual resume upload
2. **Subsequent:** Resume may auto-fill from session — check first
3. **Reuse essays** if similar roles, or tailor if different

---

*Application automation only. For role discovery, see job-roles. For cover letters, see cover-letter. For tracker, see job-tracker.*
