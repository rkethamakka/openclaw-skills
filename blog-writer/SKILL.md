---
name: blog-writer
description: Write and publish blog posts to rkethamakka.github.io. Use when Raki wants to write a blog post, publish to the site, or update blog content.
---

# Blog Writer

Write and publish blog posts to rkethamakka.github.io.

## Local Workspace

All blog posts are stored locally and synced to GitHub:

```
workspace/blog/
├── index.json                           # Blog index (metadata, stats, topics)
├── ai-agents-mental-model-openclaw.md   # Published posts
├── my-draft-post.md                     # Drafts (status: "draft" in index)
└── ...
```

**GitHub repo:** `rkethamakka/rkethamakka.github.io`
**Live site:** `https://rkethamakka.github.io/blog/`

## Commands

### List Blogs

When Raki asks: "What blogs do I have?" / "Show my posts" / "Blog status"

```bash
cat /Users/ravikiran/.openclaw/workspace/blog/index.json
```

**Response format:**
```
📚 **Blog Status**

**Published (X):**
1. [Title] — [date] — tags: [tags]
2. ...

**Drafts (X):**
1. [Title] — started [date]

**Topics:**
AI (3), distributed-systems (2), career (1)
```

### Read a Blog

When Raki asks: "Show me the [title] post" / "Read [slug]"

```bash
cat /Users/ravikiran/.openclaw/workspace/blog/[slug].md
```

### Update a Blog

When Raki asks: "Update [title]" / "Edit [slug]"

1. Read the current post
2. Ask what changes Raki wants
3. Edit the file
4. Update index.json if metadata changed
5. Publish (see Publishing below)

### Write New Blog

When Raki asks: "Write a blog about [topic]" / "New post on [topic]"

**Step 1: Outline**
```
📝 **New Blog: [Topic]**

Suggested structure:
1. Hook / Opening
2. Main points (3-5)
3. Conclusion / Takeaway

Draft as a post or start with an outline first?
```

**Step 2: Write**

Create the markdown file with frontmatter:

```markdown
---
title: "Your Title Here"
date: YYYY-MM-DD
tags: ["tag1", "tag2"]
---

Content here...
```

**Step 3: Save locally**

```bash
# Save to workspace
/Users/ravikiran/.openclaw/workspace/blog/[slug].md
```

**Step 4: Update index.json**

Add entry to `posts` array, update `stats` and `topics`.

**Step 5: Publish** (see Publishing section)

## Frontmatter

Every post needs YAML frontmatter:

```yaml
---
title: "Post Title"           # Required
date: YYYY-MM-DD              # Required (ISO format)
tags: ["tag1", "tag2"]        # Optional, array of strings
---
```

## File Naming

Use kebab-case slugs matching the topic:
- `building-ai-agents.md` ✓
- `Building AI Agents.md` ✗
- `building_ai_agents.md` ✗

The slug becomes the URL: `/blog/post.html?p=building-ai-agents`

## Publishing

### Option 1: Git Push (if configured)

```bash
cd /tmp/rkethamakka.github.io
git pull origin main

# Copy updated files
cp /Users/ravikiran/.openclaw/workspace/blog/[slug].md blog/posts/

# Update blog index.html (see HTML Index section)

git add .
git commit -m "Add post: [title]"
git push origin main
```

### Option 2: Browser Upload (fallback)

If git auth isn't configured, use GitHub web UI:

1. Start browser: `browser action=start profile="openclaw"`
2. Upload post to: `github.com/rkethamakka/rkethamakka.github.io/upload/main/blog/posts`
3. Upload updated index.html to: `github.com/rkethamakka/rkethamakka.github.io/upload/main/blog`

## HTML Index (blog/index.html)

**Every published post MUST be listed in the HTML index.**

Add new posts at the TOP of `<ul class="post-list">` (newest first):

```html
<li class="post-item">
    <a href="/blog/post.html?p=your-slug" target="_blank">
        <h3 class="post-title">Your Post Title</h3>
        <div class="post-meta">
            February 4, 2024
            <span class="tag">tag1</span>
            <span class="tag">tag2</span>
        </div>
        <p class="post-excerpt">
            A brief excerpt (1-2 sentences from the intro).
        </p>
    </a>
</li>
```

## Writing Style

Based on Raki's existing posts:

**Voice:**
- Direct, confident
- Technical but accessible
- Uses analogies and mental models
- Not afraid of opinions

**Structure:**
- Clear headers (h2 for sections)
- Short paragraphs
- Code blocks when relevant
- Bullet points for lists
- Strong opening hook
- Memorable closing

**Length:**
- Short posts: 500-800 words
- Standard posts: 1000-1500 words
- Deep dives: 2000+ words

## Topics to Write About

Based on Raki's expertise:

| Topic | Angle |
|-------|-------|
| Distributed Systems | Architecture patterns, scaling lessons |
| AI/ML Engineering | Building agents, LLMs in production |
| Platform Engineering | APIs, gateways, developer experience |
| Career | Job search insights, engineering levels |
| Tools | Developer productivity, AI coding tools |
| Building in Public | OpenClaw journey, personal projects |

## Updating index.json

After any blog change, update the index:

```python
import json

index_path = "/Users/ravikiran/.openclaw/workspace/blog/index.json"
with open(index_path) as f:
    index = json.load(f)

# Add new post
index["posts"].insert(0, {  # Insert at top (newest first)
    "slug": "new-post-slug",
    "title": "New Post Title",
    "date": "2024-02-05",
    "tags": ["tag1", "tag2"],
    "excerpt": "Brief description...",
    "status": "published"  # or "draft"
})

# Update stats
published = sum(1 for p in index["posts"] if p["status"] == "published")
drafts = sum(1 for p in index["posts"] if p["status"] == "draft")
index["stats"] = {"total": len(index["posts"]), "published": published, "draft": drafts}

# Update topics
topics = {}
for post in index["posts"]:
    for tag in post.get("tags", []):
        topics[tag] = topics.get(tag, 0) + 1
index["topics"] = topics

with open(index_path, "w") as f:
    json.dump(index, f, indent=2)
```

## Syncing from GitHub

If the repo has posts not in local workspace:

```bash
cd /tmp/rkethamakka.github.io
git pull origin main

# Copy any new posts
cp blog/posts/*.md /Users/ravikiran/.openclaw/workspace/blog/

# Then rebuild index.json by scanning frontmatter
```

## Scan Posts to Rebuild Index

```python
import os
import json
import re

blog_dir = "/Users/ravikiran/.openclaw/workspace/blog"
posts = []
topics = {}

for filename in os.listdir(blog_dir):
    if not filename.endswith('.md'):
        continue
    
    filepath = os.path.join(blog_dir, filename)
    with open(filepath) as f:
        content = f.read()
    
    # Parse frontmatter
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        continue
    
    frontmatter = match.group(1)
    
    # Extract fields (simple parsing)
    title = re.search(r'title:\s*["\'](.+?)["\']', frontmatter)
    date = re.search(r'date:\s*(\d{4}-\d{2}-\d{2})', frontmatter)
    tags = re.search(r'tags:\s*\[(.+?)\]', frontmatter)
    
    post = {
        "slug": filename[:-3],
        "title": title.group(1) if title else filename[:-3],
        "date": date.group(1) if date else "unknown",
        "tags": [t.strip().strip('"\'') for t in tags.group(1).split(',')] if tags else [],
        "excerpt": content.split('\n\n')[1][:200] + "..." if '\n\n' in content else "",
        "status": "published"
    }
    posts.append(post)
    
    for tag in post["tags"]:
        topics[tag] = topics.get(tag, 0) + 1

# Sort by date (newest first)
posts.sort(key=lambda x: x["date"], reverse=True)

index = {
    "posts": posts,
    "stats": {"total": len(posts), "published": len(posts), "draft": 0},
    "topics": topics
}

with open(os.path.join(blog_dir, "index.json"), "w") as f:
    json.dump(index, f, indent=2)
```

## Checklist: New Post

- [ ] Write post in workspace/blog/[slug].md
- [ ] Include proper frontmatter (title, date, tags)
- [ ] Update workspace/blog/index.json
- [ ] Copy post to /tmp/rkethamakka.github.io/blog/posts/
- [ ] Update /tmp/rkethamakka.github.io/blog/index.html
- [ ] Push to GitHub (git or browser upload)
- [ ] Verify live at rkethamakka.github.io/blog/

## Site Structure Reference

```
rkethamakka.github.io/
├── index.html              # Resume (main page)
├── blog/
│   ├── index.html          # Blog listing (must list all posts)
│   ├── post.html           # Markdown renderer (don't modify)
│   └── posts/              # Markdown files
│       └── *.md
```

## URLs

- **Resume:** https://rkethamakka.github.io
- **Blog index:** https://rkethamakka.github.io/blog/
- **Post template:** https://rkethamakka.github.io/blog/post.html?p=SLUG
- **Repo:** https://github.com/rkethamakka/rkethamakka.github.io

---

*Local-first workflow. Edit in workspace, sync to GitHub.*
