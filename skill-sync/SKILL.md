---
name: skill-sync
description: Sync local skills to public GitHub repo with sanitization. Use when Raki says "sync skills to repo" or wants to publish skill updates.
---

# Skill Sync

Sanitize and sync local skills to the public `openclaw-skills` repo.

## Trigger Phrases

- "Sync skills to repo"
- "Push skills to GitHub"
- "Update public skills"

## What It Does

1. Copies skills from local workspace
2. Replaces personal data with placeholders
3. Commits and pushes to `${GITHUB_HANDLE}/openclaw-skills`

## The Script

Run this Python script to sanitize and sync:

```python
#!/usr/bin/env python3
"""Sanitize and sync skills to public repo"""

import os
import re
import shutil
import subprocess

# Paths
SOURCE = "${WORKSPACE}/skills"
REPO = "/tmp/openclaw-skills"
REPO_URL = "git@github.com:${GITHUB_HANDLE}/openclaw-skills.git"

# Skip these folders (not for public)
SKIP_FOLDERS = {'skill-sync'}  # This skill stays local

# Personal data → placeholder mappings
REPLACEMENTS = [
    # Paths (order matters - more specific first)
    (r'${HOME}/\.openclaw/workspace', '${WORKSPACE}'),
    (r'${JOBS_DIR}', '${JOBS_DIR}'),
    (r'${HOME}', '${HOME}'),
    
    # Personal info
    (r'ravikiran\.kn@gmail\.com', '${EMAIL}'),
    (r'${GITHUB_HANDLE}@gmail\.com', '${EMAIL_ALT}'),
    (r'${PHONE}', '${PHONE}'),
    (r'${FULL_NAME}', '${FULL_NAME}'),
    (r'${FIRST_NAME}', '${FIRST_NAME}'),
    (r'${LAST_NAME}', '${LAST_NAME}'),
    (r'${LINKEDIN_HANDLE}', '${LINKEDIN_HANDLE}'),
    (r'${GITHUB_HANDLE}', '${GITHUB_HANDLE}'),
    (r'${CURRENT_COMPANY}', '${CURRENT_COMPANY}'),
    (r'${UNIVERSITY}', '${UNIVERSITY}'),
    (r'${LOCATION}', '${LOCATION}'),
    (r'${LOCATION_SHORT}', '${LOCATION_SHORT}'),
    (r'${VISA_STATUS}', '${VISA_STATUS}'),
    (r'${NAME_PRONUNCIATION}', '${NAME_PRONUNCIATION}'),
    
    # File names
    (r'Naga_Ravi_Kiran_Resume_2026\.pdf', '${RESUME_FILE}'),
    (r'Ravi Interviews\.docx', '${TRACKER_FILE}'),
]

def sanitize_content(content):
    for pattern, replacement in REPLACEMENTS:
        content = re.sub(pattern, replacement, content)
    return content

def sync_skills(commit_msg="Update skills"):
    # Clone or pull repo
    if os.path.exists(REPO):
        subprocess.run(['git', 'pull'], cwd=REPO, check=True)
    else:
        subprocess.run(['git', 'clone', REPO_URL, REPO], check=True)
    
    # Clear existing skills (keep .git and README)
    for item in os.listdir(REPO):
        if item not in ['.git', 'README.md']:
            path = os.path.join(REPO, item)
            if os.path.isdir(path):
                shutil.rmtree(path)
            else:
                os.remove(path)
    
    # Copy and sanitize skills
    for skill in os.listdir(SOURCE):
        if skill in SKIP_FOLDERS:
            continue
        
        src = os.path.join(SOURCE, skill)
        dst = os.path.join(REPO, skill)
        
        if not os.path.isdir(src):
            continue
        
        shutil.copytree(src, dst, ignore=shutil.ignore_patterns('.git', '__pycache__', '*.pyc'))
        
        # Sanitize text files
        for root, dirs, files in os.walk(dst):
            for filename in files:
                if filename.endswith(('.md', '.json', '.txt', '.html')):
                    filepath = os.path.join(root, filename)
                    with open(filepath, 'r') as f:
                        content = f.read()
                    
                    sanitized = sanitize_content(content)
                    
                    with open(filepath, 'w') as f:
                        f.write(sanitized)
                    
                    if content != sanitized:
                        print(f"Sanitized: {skill}/{filename}")
    
    # Commit and push
    subprocess.run(['git', 'add', '.'], cwd=REPO, check=True)
    
    result = subprocess.run(['git', 'status', '--porcelain'], cwd=REPO, capture_output=True, text=True)
    if result.stdout.strip():
        subprocess.run(['git', 'commit', '-m', commit_msg], cwd=REPO, check=True)
        subprocess.run(['git', 'push', 'origin', 'main'], cwd=REPO, check=True)
        print(f"\n✅ Pushed to github.com/${GITHUB_HANDLE}/openclaw-skills")
    else:
        print("\n✅ No changes to push")

if __name__ == "__main__":
    import sys
    msg = sys.argv[1] if len(sys.argv) > 1 else "Update skills"
    sync_skills(msg)
```

## Usage

Save the script and run:

```bash
python3 ${WORKSPACE}/skills/skill-sync/sync.py "Add new feature to job-tracker"
```

Or just say: **"Sync skills to repo"** and I'll run it for you.

## What Gets Synced

All skills in the workspace (including this one — it gets sanitized too).

## What Gets Sanitized

| Personal Data | Placeholder |
|---------------|-------------|
| `${HOME}/...` | `${HOME}`, `${WORKSPACE}`, `${JOBS_DIR}` |
| `${EMAIL}` | `${EMAIL}` |
| `${PHONE}` | `${PHONE}` |
| Full name, company, etc. | Various `${PLACEHOLDERS}` |

## Adding New Placeholders

If you add new personal data to skills, update the `REPLACEMENTS` list in the script.

## Verification

After sync, check for leaks:
```bash
grep -r "ravikiran\|${PHONE}" /tmp/openclaw-skills/ | grep -v ".git"
```

Should return nothing.
