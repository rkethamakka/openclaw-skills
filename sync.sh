#!/bin/bash
# sync.sh — Sync ~/.openclaw/skills/ to this repo
# - Copies public skills (gitignored ones are excluded by git automatically)
# - Strips PII by replacing values from profile.json back to ${PLACEHOLDER}
# - Commits and pushes

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.openclaw/skills"
PROFILE="$SKILLS_DIR/job-data/profile.json"

echo "🔄 Syncing skills from $SKILLS_DIR → $REPO_DIR"

# ── Step 1: Copy all skills from ~/.openclaw/skills/ into repo ──────────────
for skill_dir in "$SKILLS_DIR"/*/; do
  skill=$(basename "$skill_dir")
  # Skip non-skill folders
  [ "$skill" = "job-data" ] && continue
  [ ! -f "$skill_dir/SKILL.md" ] && continue

  mkdir -p "$REPO_DIR/$skill"
  cp -r "$skill_dir"/* "$REPO_DIR/$skill/"
done

echo "✅ Copied skills to repo"

# ── Step 2: Strip PII from all SKILL.md files in repo ───────────────────────
# Read values from profile.json
if [ -f "$PROFILE" ]; then
  FULL_NAME=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('FULL_NAME',''))")
  FIRST_NAME=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('FIRST_NAME',''))")
  LAST_NAME=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('LAST_NAME',''))")
  EMAIL=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('EMAIL',''))")
  PHONE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('PHONE',''))")
  LOCATION=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('LOCATION',''))")
  GITHUB_HANDLE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('GITHUB_HANDLE',''))")
  LINKEDIN_HANDLE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('LINKEDIN_HANDLE',''))")
  TWITTER_HANDLE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('TWITTER_HANDLE',''))")
  UNIVERSITY=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('UNIVERSITY',''))")
  CURRENT_COMPANY=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('CURRENT_COMPANY',''))")
  VISA_STATUS=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('VISA_STATUS',''))")
  NAME_PRONUNCIATION=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('NAME_PRONUNCIATION',''))")
  JOBS_DIR=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('JOBS_DIR',''))")
  TRACKER_FILE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('TRACKER_FILE',''))")
  RESUME_FILE=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('RESUME_FILE',''))")
  LOCATION_SHORT=$(python3 -c "import json; d=json.load(open('$PROFILE')); print(d.get('LOCATION_SHORT',''))")
  PHONE_FMT="${PHONE:0:3}-${PHONE:3:3}-${PHONE:6:4}"

  strip_pii() {
    local file="$1"
    [ ! -f "$file" ] && return
    # Replace actual values with placeholders
    [ -n "$FULL_NAME" ]         && sed -i '' "s|$FULL_NAME|\${FULL_NAME}|g" "$file"
    [ -n "$FIRST_NAME" ]        && sed -i '' "s|$FIRST_NAME|\${FIRST_NAME}|g" "$file"
    [ -n "$LAST_NAME" ]         && sed -i '' "s|$LAST_NAME|\${LAST_NAME}|g" "$file"
    [ -n "$EMAIL" ]             && sed -i '' "s|$EMAIL|\${EMAIL}|g" "$file"
    [ -n "$PHONE" ]             && sed -i '' "s|$PHONE|\${PHONE}|g" "$file"
    [ -n "$PHONE_FMT" ]         && sed -i '' "s|$PHONE_FMT|\${PHONE}|g" "$file"
    [ -n "$LOCATION" ]          && sed -i '' "s|$LOCATION|\${LOCATION}|g" "$file"
    [ -n "$GITHUB_HANDLE" ]     && sed -i '' "s|$GITHUB_HANDLE|\${GITHUB_HANDLE}|g" "$file"
    [ -n "$LINKEDIN_HANDLE" ]   && sed -i '' "s|$LINKEDIN_HANDLE|\${LINKEDIN_HANDLE}|g" "$file"
    [ -n "$TWITTER_HANDLE" ]    && sed -i '' "s|$TWITTER_HANDLE|\${TWITTER_HANDLE}|g" "$file"
    [ -n "$UNIVERSITY" ]        && sed -i '' "s|$UNIVERSITY|\${UNIVERSITY}|g" "$file"
    [ -n "$CURRENT_COMPANY" ]   && sed -i '' "s|$CURRENT_COMPANY|\${CURRENT_COMPANY}|g" "$file"
    [ -n "$VISA_STATUS" ]       && sed -i '' "s|$VISA_STATUS|\${VISA_STATUS}|g" "$file"
    [ -n "$NAME_PRONUNCIATION" ] && sed -i '' "s|$NAME_PRONUNCIATION|\${NAME_PRONUNCIATION}|g" "$file"
    [ -n "$JOBS_DIR" ]          && sed -i '' "s|$JOBS_DIR|\${JOBS_DIR}|g" "$file"
    [ -n "$TRACKER_FILE" ]      && sed -i '' "s|$TRACKER_FILE|\${TRACKER_FILE}|g" "$file"
    [ -n "$RESUME_FILE" ]       && sed -i '' "s|$RESUME_FILE|\${RESUME_FILE}|g" "$file"
    [ -n "$LOCATION_SHORT" ]    && sed -i '' "s|$LOCATION_SHORT|\${LOCATION_SHORT}|g" "$file"
    # Strip home directory path
    sed -i '' "s|$HOME|\${HOME}|g" "$file"
  }

  echo "🔒 Stripping PII from SKILL.md files..."
  for skill_dir in "$REPO_DIR"/*/; do
    skill=$(basename "$skill_dir")
    skill_md="$skill_dir/SKILL.md"
    [ -f "$skill_md" ] && strip_pii "$skill_md"
  done
  echo "✅ PII stripped"
else
  echo "⚠️  profile.json not found at $PROFILE — skipping PII strip"
fi

# ── Step 3: Git commit and push ──────────────────────────────────────────────
cd "$REPO_DIR"

if [ -z "$(git status --porcelain)" ]; then
  echo "✅ Nothing to commit — repo is up to date"
  exit 0
fi

git add -A
git status --short
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push
echo "🚀 Pushed to GitHub"
