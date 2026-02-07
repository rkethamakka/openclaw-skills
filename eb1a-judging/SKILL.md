---
name: eb1a-judging
description: Review conference papers on Microsoft CMT for EB1A Judging criterion. Use when checking papers by status, reviewing papers, or submitting reviews.
---

# EB1A Judging (CMT Paper Reviews)

Review conference papers on Microsoft CMT for the EB1A Judging criterion.

## Shared Config

Load config from: `skills/eb1a-data/config.json`

CMT credentials and conference codes are in the config.

## Trigger Phrases

- "Check my CMT reviews"
- "Papers by status"
- "Show all papers across conferences"
- "Any papers to review?"
- "Review paper #88"
- "What papers need review?"

---

## Workflow: Login

```
1. browser action=start profile=openclaw
2. Navigate to https://cmt3.research.microsoft.com
3. Type email from config
4. Type password from config
5. Click "Log In"
```

---

## Workflow: Papers by Status

When user asks "papers by status" or "check all conferences":

```
For EACH conference in config.cmt.conferences:
  1. Navigate to https://cmt3.research.microsoft.com/{CODE}/Submission/Rvw
  2. Wait 1.5s for load
  3. Check paper count from "X - Y of Z"
  4. If papers > 0, record each paper:
     - Paper ID
     - Title
     - Status (from Review & Discussion column)

Status types:
  - "Enter Review" + "Awaiting Decision" = NEEDS_REVIEW
  - "Reviewing Deadline has passed" = DEADLINE_PASSED  
  - "View Review" + "Status: Accept" = REVIEWED_ACCEPT
  - "View Review" + "Status: Reject" = REVIEWED_REJECT
```

**Output format:**
```
NEEDS_REVIEW:
  ICCTAC2026:
    #88 - Resume Analysis + NLP
    #131 - AI + Blockchain Mental Health

DEADLINE_PASSED:
  ICADS2026:
    #260 - Turbulence Prediction

ALREADY_REVIEWED:
  ICCIDS2026:
    #26 - Blockchain Multi-Cloud (Accept)
```

---

## Workflow: Review a Paper

```
1. User picks a paper (e.g., "#88")
2. Navigate to that conference's reviewer console
3. Click on the paper title link to open summary page
4. Download PDF using CDP + curl (see below)
5. Read PDF from ~/Downloads/ folder
6. Analyze paper content
7. Draft review (grade + strengths/weaknesses + comments)
8. SHOW DRAFT TO USER - ask for feedback/approval
9. Once approved, click "Enter Review" on CMT
10. Fill form with approved content
11. Confirm before final submit
```

**⚠️ NEVER auto-submit. Always show draft and get user approval first.**

---

## Downloading Papers (CDP + curl method)

Browser click/navigate triggers fail for CMT downloads. Use this approach:

**Step 1: Get the file URL from the summary page**
The PDF link is in the "Submission Files" section, e.g., `/api/ICCTAC2026/Files/98`

**Step 2: Extract cookies via CDP websocket**
```python
import json, asyncio, websockets

async def get_cmt_cookies(tab_target_id):
    cdp_ws = f"ws://127.0.0.1:18800/devtools/page/{tab_target_id}"
    async with websockets.connect(cdp_ws) as ws:
        msg = {"id": 1, "method": "Network.getCookies", 
               "params": {"urls": ["https://cmt3.research.microsoft.com"]}}
        await ws.send(json.dumps(msg))
        resp = json.loads(await ws.recv())
        return resp["result"]["cookies"]

cookies = asyncio.run(get_cmt_cookies("TAB_TARGET_ID"))
```

**Step 3: Build cookie header and curl**
```bash
curl -s -o ~/Downloads/Paper_{ID}.pdf \
  -H "Cookie: .AspNetCore.Cookies={VALUE}; .ROLE=Reviewer; .TRACK=1" \
  "https://cmt3.research.microsoft.com/api/{CONF}/Files/{FILE_ID}"
```

**PDF Location:** `~/Downloads/Paper_{ID}.pdf`

---

## Reading the PDF

```python
import fitz  # PyMuPDF
doc = fitz.open(f"${HOME}/Downloads/Paper_{paper_id}.pdf")
text = ""
for page in doc:
    text += page.get_text()
```

---

## Review Writing Style

**Core Rules:**
- Keep it brief and direct
- No em-dashes
- Strengths/weaknesses must match your grade

---

## Grade-Narrative Alignment

**Strong Accept:**
- Strengths: 4-5 solid points
- Weaknesses: 1-2 minor nitpicks only
- Tone: Enthusiastic, clear contribution

**Accept:**
- Strengths: 3-4 points
- Weaknesses: 1-2 minor issues
- Tone: Positive, good work

**Weak Accept:**
- Strengths: 2-3 points
- Weaknesses: 2-3 points (balanced)
- Tone: Cautiously positive, has merit but room to improve

**Borderline:**
- Strengths: 2 points
- Weaknesses: 2-3 points
- Tone: Neutral, could go either way

**Weak Reject:**
- Strengths: 1-2 points (acknowledge something)
- Weaknesses: 3-4 points
- Tone: Concerns outweigh merits

**Reject:**
- Strengths: 1 point max (be fair)
- Weaknesses: 4-5 serious issues
- Tone: Clear problems, not ready

**Strong Reject:**
- Strengths: Maybe 1 if any
- Weaknesses: Major fundamental flaws
- Tone: Serious issues with methodology/validity

---

## Example: Weak Accept

> Proposes NLP-based resume matching. Reasonable approach with decent results.
>
> Strengths:
> - Clear problem formulation
> - Good accuracy on test set
>
> Weaknesses:
> - Small dataset (500 resumes)
> - No comparison with existing tools
> - Limited discussion of generalization

---

## Example: Reject

> Attempts blockchain-based data sharing but execution falls short.
>
> Strengths:
> - Addresses a real problem
>
> Weaknesses:
> - No experimental validation
> - Architecture diagram unclear
> - Claims not supported by evidence
> - Missing related work comparison

---

## Pre-Submit Checklist

Before submitting any review:
1. Does my grade match my narrative? (Weak accept shouldn't have mostly negatives)
2. Are strengths/weaknesses counts balanced for my grade?
3. No em-dashes used?
4. Brief and direct? (No filler phrases)

---

## Browser Notes

- **Profile:** Use `profile="openclaw"` for isolated browser
- **Login:** User should be logged into CMT already (or login via workflow)

---

*eb1a-judging - CMT Paper Reviews for Judging Criterion*
