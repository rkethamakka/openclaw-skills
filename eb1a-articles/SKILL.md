---
name: eb1a-articles
description: Write scholarly articles for EB1A application. Use when drafting 6-page articles, following templates, managing PLAN.md, or addressing reviewer comments.
---

# EB1A Scholarly Articles

Write scholarly articles for the EB1A Scholarly Articles criterion.

## Shared Config

Load config from: `skills/eb1a-data/config.json`

## Folder Structure

```
{drive.root}/Scholarly Articles/
├── PLAN.md                           ← Master plan for all articles
├── Articles_old.md                   ← Old abstracts (reference only)
├── Template_new.docx                 ← EB1A Experts template
├── Article1_[ShortName].docx         ← Individual article files
├── Article2_[ShortName].docx
└── ...
```

## Trigger Phrases

- "Draft article for [topic]"
- "Write scholarly article"
- "Check article comments"
- "Address comments on Article X"
- "Update PLAN.md"

---

## Template Format (EB1A Experts 2025)

**⚠️ ALWAYS reference the template before writing:**
```
{drive.root}/Scholarly Articles/Template_new.docx
```

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
### 3.2 [Subsection Title]

## 4. [Main Section Title]
...continues with same pattern...

## 5. [Main Section Title]
...continues...

## 6. [Conclusion/Future Directions]
### 6.1 [Subsection Title]
### 6.2 [Subsection Title]
```

---

## 7 Categories

1. **Expertise-Specific Concepts**: Simplify complex topics for beginners
2. **Research and Innovations**: Latest developments, cutting-edge trends
3. **Success Stories and Applications**: Real-world case studies, lessons learned
4. **Tips and Advice**: Career guidance, practical strategies
5. **Industry-Specific Applications**: Impact on healthcare, retail, etc.
6. **Your Field and Society**: Broader societal impact, ethics
7. **AI and Human-AI Collaboration**: Only for automation-type fields

---

## Writing Workflow

**Step 0: Read Template_new.docx**
- ALWAYS read the template first
- Review the sample outline structure
- Check category descriptions for tone guidance

**Step 1: Update PLAN.md**
- Define article title and focus
- Note what to include / exclude
- Track status: [ ] Outline → [ ] Draft → [ ] Refine → [ ] Review → [ ] Final

**Step 2: Write Article as .docx**
- Use python-docx to create proper Word document
- Follow the 6-page structure exactly
- Include diagram placeholders where appropriate

**Step 3: Save to Scholarly Articles folder**
- Filename: `Article[N]_[ShortName].docx`
- Example: `Article1_UDP_Architecture.docx`

**Step 4: Update PLAN.md status**

---

## Creating .docx Files

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

# Continue pattern for sections 3-6...

# Save
doc.save('{drive.root}/Scholarly Articles/Article1_Name.docx')
```

---

## Category-Specific Writing Styles

**Category 1 (Expertise-Specific Concepts):**
- **BEGINNER-FRIENDLY** - Write for non-technical readers
- Use **analogies** (e.g., "like a security guard at a building entrance")
- Explain "what" and "why" before "how"
- Avoid deep technical jargon

**Category 2 (Research and Innovations):**
- Can be more technical - for readers familiar with the field
- Focus on cutting-edge developments and trends
- Include implementation details and real metrics

---

## Comment Review Workflow

**When user says "check comments" or "address comments":**

1. **Copy docx to temp** (Google Drive may lock the file):
   ```bash
   cp "{drive.root}/Scholarly Articles/ArticleN.docx" /tmp/article_temp.docx
   ```

2. **Extract comments from docx**:
   ```python
   import zipfile
   import xml.etree.ElementTree as ET
   
   with zipfile.ZipFile('/tmp/article_temp.docx', 'r') as z:
       comments_xml = z.read('word/comments.xml')
       root = ET.fromstring(comments_xml)
       ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
       
       for comment in root.findall('.//w:comment', ns):
           author = comment.get('{...}author')
           text = ''.join(t.text for t in comment.findall('.//w:t', ns) if t.text)
           print(f"{author}: {text}")
   ```

3. **Find comment locations** in document.xml (look for commentRangeStart)

4. **Treat each comment as a prompt** - may require:
   - Changes to that specific paragraph
   - Changes to OTHER paragraphs (ripple effects)
   - Structural changes to the article

5. **Rewrite affected sections** and regenerate the docx

---

## Writing Style Rules (Human-Sounding)

**CRITICAL: Avoid AI-sounding patterns!**

**❌ DO NOT USE:**
- Em-dashes (-) for insertions or lists
- Double hyphens (--)
- Long sentences with multiple clause interruptions

**✅ USE INSTEAD:**

| AI Pattern | Human Pattern |
|------------|---------------|
| `services-mobile apps, partner integrations-the number` | `services like mobile apps and partner integrations. The number` |
| `real-time updates-no restart required-across all` | `real-time updates. No restart is required. Across all` |

**Natural Flow Techniques:**
- Split long thoughts into separate sentences
- Use "like" or "such as" for examples
- Vary sentence length (mix short and long)

**Before submitting any article, check:**
```python
for para in doc.paragraphs:
    if '-' in para.text or '--' in para.text:
        print(f"FIX: {para.text[:100]}")
```

---

## Diagram Capabilities

**What I can create:**
1. Architecture diagrams using Python `diagrams` library → PNG
2. Flowcharts using graphviz/matplotlib → PNG
3. Mermaid diagrams → render to PNG

**Diagram Workflow:**
1. Identify diagram needs from placeholders
2. Generate diagram as PNG using Python
3. Insert into docx at placeholder location
4. Remove placeholder text

---

## Guidelines

- **Generic content** - No company-specific details
- **No unexplained abbreviations** - Always expand on first use
- **Research style** - Include statistics, percentages, industry analyses
- **Academic tone** - Suitable for scholarly publication
- **Diagram placeholders** - Note where visuals should go

---

*eb1a-articles - Scholarly Articles Criterion*
