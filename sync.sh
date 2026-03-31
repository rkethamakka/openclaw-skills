#!/bin/bash
# sync.sh — Safely push skills to GitHub with PII removed
#
# How it works:
#   1. Reads real values from profile.json + eb1a-config.json
#   2. For each SKILL.md, makes a TEMP COPY, strips PII from the copy
#   3. Stages the stripped copy (git sees clean version)
#   4. Commits + pushes
#   5. Restores originals — your working files are NEVER modified
#
# Usage: ./sync.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE="$HOME/.openclaw/skills/job-data/profile.json"
EB1A_CONFIG="$HOME/.openclaw/skills/job-data/eb1a-config.json"
TMPDIR_STRIP="$(mktemp -d)"

cleanup() { rm -rf "$TMPDIR_STRIP"; }
trap cleanup EXIT

echo "🔄 Syncing skills → GitHub (PII-safe)"

# ── Load PII values to strip ─────────────────────────────────────────────────
if [ ! -f "$PROFILE" ]; then
  echo "❌ profile.json not found at $PROFILE"
  exit 1
fi

read_json() {
  python3 -c "import json; d=json.load(open('$1')); print(d.get('$2', d.get('$3', '')))" 2>/dev/null || echo ""
}

FULL_NAME=$(read_json "$PROFILE" FULL_NAME)
FIRST_NAME=$(read_json "$PROFILE" FIRST_NAME)
LAST_NAME=$(read_json "$PROFILE" LAST_NAME)
EMAIL=$(read_json "$PROFILE" EMAIL)
PHONE=$(read_json "$PROFILE" PHONE)
LOCATION=$(read_json "$PROFILE" LOCATION)
LOCATION_SHORT=$(read_json "$PROFILE" LOCATION_SHORT)
GITHUB_HANDLE=$(read_json "$PROFILE" GITHUB_HANDLE)
LINKEDIN_HANDLE=$(read_json "$PROFILE" LINKEDIN_HANDLE)
TWITTER_HANDLE=$(read_json "$PROFILE" TWITTER_HANDLE)
UNIVERSITY=$(read_json "$PROFILE" UNIVERSITY)
CURRENT_COMPANY=$(read_json "$PROFILE" CURRENT_COMPANY)
VISA_STATUS=$(read_json "$PROFILE" VISA_STATUS)
VISA_NOTES=$(read_json "$PROFILE" VISA_NOTES)
NAME_PRONUNCIATION=$(read_json "$PROFILE" NAME_PRONUNCIATION)
JOBS_DIR=$(read_json "$PROFILE" JOBS_DIR)
TRACKER_FILE=$(read_json "$PROFILE" TRACKER_FILE)
RESUME_FILE=$(read_json "$PROFILE" RESUME_FILE)
PHONE_FMT="${PHONE:0:3}-${PHONE:3:3}-${PHONE:6:4}"

# EB1A config values
if [ -f "$EB1A_CONFIG" ]; then
  ASANA_WORKSPACE_ID=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['asana']['workspace_id'])" 2>/dev/null || echo "")
  ASANA_PROJECT_ID=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['asana']['project_id'])" 2>/dev/null || echo "")
  ASANA_LIST_ID=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['asana']['list_id'])" 2>/dev/null || echo "")
  ASANA_PROJECT_NAME=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['asana']['project_name'])" 2>/dev/null || echo "")
  DRIVE_ROOT=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['drive']['root'])" 2>/dev/null || echo "")
  SUPPORT_LETTERS_PATH=$(python3 -c "import json; d=json.load(open('$EB1A_CONFIG')); print(d['drive']['support_letters_path'])" 2>/dev/null || echo "")
fi

# ── Strip PII from a file (operates on a copy) ───────────────────────────────
strip_pii() {
  local file="$1"
  [ ! -f "$file" ] && return

  # Order matters: strip longer/more specific strings first
  [ -n "$NAME_PRONUNCIATION" ] && sed -i '' "s|$NAME_PRONUNCIATION|\${NAME_PRONUNCIATION}|g" "$file"
  [ -n "$VISA_NOTES" ]         && sed -i '' "s|$VISA_NOTES|\${VISA_NOTES}|g" "$file"
  [ -n "$FULL_NAME" ]          && sed -i '' "s|$FULL_NAME|\${FULL_NAME}|g" "$file"
  [ -n "$FIRST_NAME" ]         && sed -i '' "s|$FIRST_NAME|\${FIRST_NAME}|g" "$file"
  [ -n "$LAST_NAME" ]          && sed -i '' "s|$LAST_NAME|\${LAST_NAME}|g" "$file"
  [ -n "$ASANA_PROJECT_NAME" ] && sed -i '' "s|$ASANA_PROJECT_NAME|\${ASANA_PROJECT_NAME}|g" "$file"
  [ -n "$SUPPORT_LETTERS_PATH" ] && sed -i '' "s|$SUPPORT_LETTERS_PATH|\${SUPPORT_LETTERS_PATH}|g" "$file"
  [ -n "$DRIVE_ROOT" ]         && sed -i '' "s|$DRIVE_ROOT|\${DRIVE_ROOT}|g" "$file"
  [ -n "$JOBS_DIR" ]           && sed -i '' "s|$JOBS_DIR|\${JOBS_DIR}|g" "$file"
  [ -n "$LOCATION_SHORT" ]     && sed -i '' "s|$LOCATION_SHORT|\${LOCATION_SHORT}|g" "$file"
  [ -n "$LOCATION" ]           && sed -i '' "s|$LOCATION|\${LOCATION}|g" "$file"
  [ -n "$CURRENT_COMPANY" ]    && sed -i '' "s|$CURRENT_COMPANY|\${CURRENT_COMPANY}|g" "$file"
  [ -n "$UNIVERSITY" ]         && sed -i '' "s|$UNIVERSITY|\${UNIVERSITY}|g" "$file"
  [ -n "$VISA_STATUS" ]        && sed -i '' "s|$VISA_STATUS|\${VISA_STATUS}|g" "$file"
  [ -n "$EMAIL" ]              && sed -i '' "s|$EMAIL|\${EMAIL}|g" "$file"
  [ -n "$PHONE_FMT" ]          && sed -i '' "s|$PHONE_FMT|\${PHONE}|g" "$file"
  [ -n "$PHONE" ]              && sed -i '' "s|$PHONE|\${PHONE}|g" "$file"
  [ -n "$ASANA_WORKSPACE_ID" ] && sed -i '' "s|$ASANA_WORKSPACE_ID|\${ASANA_WORKSPACE_ID}|g" "$file"
  [ -n "$ASANA_PROJECT_ID" ]   && sed -i '' "s|$ASANA_PROJECT_ID|\${ASANA_PROJECT_ID}|g" "$file"
  [ -n "$ASANA_LIST_ID" ]      && sed -i '' "s|$ASANA_LIST_ID|\${ASANA_LIST_ID}|g" "$file"
  [ -n "$GITHUB_HANDLE" ]      && sed -i '' "s|$GITHUB_HANDLE|\${GITHUB_HANDLE}|g" "$file"
  [ -n "$LINKEDIN_HANDLE" ]    && sed -i '' "s|$LINKEDIN_HANDLE|\${LINKEDIN_HANDLE}|g" "$file"
  [ -n "$TWITTER_HANDLE" ]     && sed -i '' "s|$TWITTER_HANDLE|\${TWITTER_HANDLE}|g" "$file"
  [ -n "$TRACKER_FILE" ]       && sed -i '' "s|$TRACKER_FILE|\${TRACKER_FILE}|g" "$file"
  [ -n "$RESUME_FILE" ]        && sed -i '' "s|$RESUME_FILE|\${RESUME_FILE}|g" "$file"
  # Strip full home path last
  sed -i '' "s|$HOME|\${HOME}|g" "$file"
}

# ── Process each public skill ─────────────────────────────────────────────────
echo "🔒 Stripping PII (working on temp copies)..."
STAGED_FILES=()

for skill_dir in "$REPO_DIR"/*/; do
  skill=$(basename "$skill_dir")
  skill_md="$skill_dir/SKILL.md"
  [ ! -f "$skill_md" ] && continue

  # Make a temp copy, strip PII from the copy
  tmp_file="$TMPDIR_STRIP/${skill}_SKILL.md"
  cp "$skill_md" "$tmp_file"
  strip_pii "$tmp_file"

  # If the stripped version differs from what git has, stage the stripped version
  git_version=$(git -C "$REPO_DIR" show "HEAD:$skill/SKILL.md" 2>/dev/null || echo "")
  stripped_version=$(cat "$tmp_file")

  if [ "$git_version" != "$stripped_version" ]; then
    # Stage the stripped version without touching the working file
    git -C "$REPO_DIR" hash-object -w "$tmp_file" | xargs git -C "$REPO_DIR" update-index --cacheinfo 100644 "$(git -C "$REPO_DIR" hash-object -w "$tmp_file")" "$skill/SKILL.md"
    STAGED_FILES+=("$skill")
  fi
done

# ── Commit and push ───────────────────────────────────────────────────────────
cd "$REPO_DIR"

if [ ${#STAGED_FILES[@]} -eq 0 ] && [ -z "$(git status --porcelain -- '*.md' '*.sh' '.gitignore')" ]; then
  echo "✅ Nothing to commit — repo is up to date"
  exit 0
fi

# Stage any other non-PII changes (sync.sh, .gitignore, README, etc.)
git add sync.sh .gitignore README.md 2>/dev/null || true

if [ -n "$(git status --porcelain)" ]; then
  echo ""
  echo "📋 Changes to commit:"
  git status --short
  echo ""
  git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
  git push
  echo ""
  echo "🚀 Pushed to GitHub"
  if [ ${#STAGED_FILES[@]} -gt 0 ]; then
    echo "🔒 PII stripped from: ${STAGED_FILES[*]}"
  fi
else
  echo "✅ Nothing to commit"
fi
