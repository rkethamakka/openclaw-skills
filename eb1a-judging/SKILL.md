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
3. Click on paper title link to open summary page
4. Download PDF using CDP + curl (see below)
5. Read PDF from ~/Downloads/ folder
6. Analyze paper content
7. Draft review (ratings + strengths/weaknesses + comments)
8. SHOW DRAFT TO USER — ask for feedback/approval
9. Once approved, click "Enter Review" on CMT
10. Fill form with approved content (all ratings + comments)
11. Create review summary PDF (see File Upload section)
12. Upload PDF to review form
13. SHOW USER: uploaded file name + form summary for final confirmation
14. Wait for explicit "submit" from user
15. Click Submit button
16. Verify submission succeeded (check for "View Review" link)
```

**⚠️ NEVER auto-submit. Always show draft AND upload summary to user first.**

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
- **Never compare papers to each other** - evaluate each paper on its own merits
- Each review is independent; don't reference other submissions

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

## Review File Upload (Required!)

**⚠️ ICCTAC2026 requires at least 1 file upload with review!**

**Step 1: Create PDF summary**
```python
from reportlab.pdfgen import canvas
c = canvas.Canvas(f"/tmp/Review_Paper{paper_id}.pdf")
c.setFont("Helvetica-Bold", 14)
c.drawString(72, 750, f"Review Summary - Paper #{paper_id}")
c.setFont("Helvetica", 12)
c.drawString(72, 720, paper_title[:60])
c.drawString(72, 670, f"Recommendation: {recommendation}")
c.drawString(72, 640, f"Technical Quality: {tech_quality}")
c.drawString(72, 620, f"Novelty: {novelty}")
c.drawString(72, 600, f"Clarity: {clarity}")
c.drawString(72, 580, f"Relevance: {relevance}")
c.drawString(72, 560, f"Significance: {significance}")
c.drawString(72, 520, "See detailed comments in the review form.")
c.save()
```

**Step 2: Upload via browser**
```
1. Click "Upload from Computer" button
2. browser action=upload paths=["/tmp/Review_Paper{ID}.pdf"]
3. Take snapshot to verify upload succeeded
```

**Step 3: Show user what was uploaded**
```
Present to user:
- Uploaded file: Review_Paper{ID}.pdf (size, timestamp)
- Form summary: all ratings + recommendation
- Comments preview
Ask: "Ready to submit? Say 'submit' to confirm."
```

**Step 4: Handle errors**
- Duplicate files: delete one before submit (click X next to file)
- Error "Found at least two files with same name" = delete duplicate
- Missing file: re-upload

---

## Review Templates by Scenario

### Scenario A: Comments + File Upload Required (e.g., ICCTAC2026)

When conference requires BOTH comments field AND file upload:

**Comments Field Template (brief, fits in form):**
```
This paper [brief summary of topic]. [1-2 sentence assessment]. 
See attached PDF for detailed review.

Key issue: [main concern if Rework/Reject]
Recommendation: [specific action for authors]
```

**Example (Rework):**
```
This paper surveys AI and blockchain approaches for mental health monitoring. 
Good literature review and clear motivation, but the proposed 3-layer architecture 
lacks implementation or experimental validation. See attached PDF for detailed review.

Key issue: No experiments, no evaluation metrics, reads as a survey rather than research contribution.
Recommendation: Implement the system with evaluation, or reframe as a formal survey paper.
```

**Example (Accept):**
```
This paper presents an NLP-based resume analysis system with skill matching. 
Solid methodology and practical results. See attached PDF for detailed review.

Strengths: Clear problem formulation, good accuracy, practical application.
Minor suggestions in attached PDF.
```

**PDF Template (detailed review):**

**⚠️ IMPORTANT: Detailed PDFs should be THOROUGH and TECHNICAL:**
- Do NOT repeat ratings/scores (they're in the form already)
- Jump directly into technical analysis
- Provide in-depth critique with specific examples from the paper
- Present your own technical insights and suggestions
- Be constructive but substantive

**Structure for detailed PDF:**
```
1. TECHNICAL ANALYSIS (main section)
   - Methodology critique (what works, what doesn't)
   - Specific technical concerns with page/section references
   - Statistical/experimental validity observations

2. KEY CONTRIBUTIONS (what the paper actually adds)
   - Novel aspects (if any)
   - Practical value

3. CRITICAL GAPS
   - Missing experiments/comparisons
   - Methodological weaknesses
   - Reproducibility concerns

4. SPECIFIC SUGGESTIONS
   - Concrete improvements with technical detail
   - References to relevant literature they missed
   - Alternative approaches to consider
```

**Example (Accept paper):**
```
TECHNICAL ANALYSIS

The authors present a student performance prediction system using 7 classifiers
with K-Means clustering for profiling. The preprocessing pipeline (categorical 
encoding, stratified sampling, StandardScaler) is appropriate for this dataset.

The reported 96% accuracy for Logistic Regression warrants scrutiny. This 
outperformance over ensemble methods (Random Forest: 90%, Gradient Boosting: 92%)
is unusual and suggests either: (a) the feature space is linearly separable, or
(b) potential data leakage. The authors should verify no target-correlated 
features leak into training.

The K-Means clustering with k=5 validated via silhouette analysis is sound, 
though the paper would benefit from reporting the actual silhouette scores.

CRITICAL GAPS

1. No cross-validation reported - single train/test split (80/20) may not 
   capture variance in model performance
2. Table 1 notation error: "0.96%" should be "96%" or "0.96"
3. No comparison with deep learning baselines (MLP, simple neural nets)

SUGGESTIONS

1. Add 5-fold or 10-fold CV results to strengthen claims
2. Include confusion matrix to show per-class performance
3. Report silhouette scores explicitly for clustering validation
```

---

### Scenario B: Comments Only (No File Upload)

When conference only has text comments field:

**Put full review in comments:**
```
SUMMARY: [1-2 sentences on what paper does]

STRENGTHS:
+ [strength 1]
+ [strength 2]
+ [strength 3]

WEAKNESSES:
- [weakness 1]
- [weakness 2]

RECOMMENDATION: [Accept/Rework/Reject with brief justification]

SUGGESTIONS FOR AUTHORS:
[specific actionable feedback]
```

---

### Scenario C: File Upload Only (Rare)

When conference wants review as uploaded document:

**Create full PDF with all sections:**
- Use the detailed PDF template from Scenario A
- Include summary, ratings, strengths, weaknesses, and suggestions
- Make sure PDF is self-contained (no "see form" references)

---

## Browser Notes

- **Profile:** Use `profile="openclaw"` for isolated browser
- **Login:** User should be logged into CMT already (or login via workflow)

---

*eb1a-judging - CMT Paper Reviews for Judging Criterion*
