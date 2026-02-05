#!/usr/bin/env python3
"""Sanitize and sync skills to public repo"""

import os
import re
import shutil
import subprocess

# Paths
SOURCE = "/Users/ravikiran/.openclaw/workspace/skills"
REPO = "/tmp/openclaw-skills"
REPO_URL = "git@github.com:rkethamakka/openclaw-skills.git"

# Skip these folders (not for public) - empty means sync all
SKIP_FOLDERS = set()  # All skills get synced

# Personal data → placeholder mappings
REPLACEMENTS = [
    # Paths (order matters - more specific first)
    (r'/Users/ravikiran/\.openclaw/workspace', '${WORKSPACE}'),
    (r'/Users/ravikiran/Documents/Google-Drive/ravi_jobs', '${JOBS_DIR}'),
    (r'/Users/ravikiran', '${HOME}'),
    
    # Personal info
    (r'ravikiran\.kn@gmail\.com', '${EMAIL}'),
    (r'rkethamakka@gmail\.com', '${EMAIL_ALT}'),
    (r'7135621997', '${PHONE}'),
    (r'Naga Ravi Kiran Kethamakka', '${FULL_NAME}'),
    (r'Naga Ravi Kiran', '${FIRST_NAME}'),
    (r'Kethamakka', '${LAST_NAME}'),
    (r'ravikirankn', '${LINKEDIN_HANDLE}'),
    (r'rkethamakka', '${GITHUB_HANDLE}'),
    (r'Expedia Group', '${CURRENT_COMPANY}'),
    (r'University of Houston - Main Campus', '${UNIVERSITY}'),
    (r'Seattle, WA, USA', '${LOCATION}'),
    (r'Seattle, WA', '${LOCATION_SHORT}'),
    (r'H-1B with I-140 approved', '${VISA_STATUS}'),
    (r'RAH-vee KEE-run keh-tha-MAH-kka', '${NAME_PRONUNCIATION}'),
    
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
        print("Pulling latest...")
        subprocess.run(['git', 'pull'], cwd=REPO, check=True)
    else:
        print("Cloning repo...")
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
    print("\nSanitizing skills...")
    for skill in os.listdir(SOURCE):
        if skill in SKIP_FOLDERS:
            print(f"Skipping: {skill} (local only)")
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
                        relpath = os.path.relpath(filepath, REPO)
                        print(f"  Sanitized: {relpath}")
    
    # Commit and push
    subprocess.run(['git', 'add', '.'], cwd=REPO, check=True)
    
    result = subprocess.run(['git', 'status', '--porcelain'], cwd=REPO, capture_output=True, text=True)
    if result.stdout.strip():
        print(f"\nCommitting: {commit_msg}")
        subprocess.run(['git', 'commit', '-m', commit_msg], cwd=REPO, check=True)
        subprocess.run(['git', 'push', 'origin', 'main'], cwd=REPO, check=True)
        print(f"\n✅ Pushed to github.com/rkethamakka/openclaw-skills")
    else:
        print("\n✅ No changes to push (already up to date)")

if __name__ == "__main__":
    import sys
    msg = sys.argv[1] if len(sys.argv) > 1 else "Update skills"
    sync_skills(msg)
