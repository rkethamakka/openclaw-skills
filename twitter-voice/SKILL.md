---
name: twitter-voice
description: Generate and post tweets based on daily work, learnings, and latest tech trends. Use when Raki wants to brainstorm tweet ideas, share insights, or post to X/Twitter.
---

# Twitter Voice

Personal X/Twitter content skill for Raki. Turns daily work and tech trends into engaging tweets.

## Account Info

```
Handle: @[TBD - Raki to provide]
Profile: /Users/ravikiran/.openclaw/workspace/skills/twitter-voice/profile.json
```

## Trigger Phrases

- "What should I tweet?"
- "Let's brainstorm tweets"
- "Post about [topic]"
- "Twitter voice" / "Tweet ideas"

## Workflow

### 1. Gather Context

**From daily work (memory files):**
```bash
# Read today's and yesterday's memory
cat /Users/ravikiran/.openclaw/workspace/memory/$(date +%Y-%m-%d).md
cat /Users/ravikiran/.openclaw/workspace/memory/$(date -v-1d +%Y-%m-%d).md
```

**What to extract:**
- Projects worked on
- Problems solved
- Tools/techniques used
- Learnings or insights
- Interesting decisions made

### 2. Mix with Latest Trends

**Search for relevant news:**
- AI/ML advancements
- Developer tools updates
- Cloud/infrastructure news
- Open source releases
- Industry trends

**Sources to check:**
- Hacker News (news.ycombinator.com)
- TechCrunch AI
- The Verge
- ArXiv (for AI papers)
- GitHub trending

### 3. Brainstorm Ideas

Present 3-5 tweet angles to Raki:

```
🐦 Tweet Ideas for Today

1. **Personal Win** — Share something you accomplished
   "Just built [X] using [Y]. The trick was [insight]..."

2. **Hot Take** — Opinion on trending topic
   "[Trend] is interesting, but here's what people miss..."

3. **Learning Thread** — Share knowledge
   "TIL about [concept]. Here's why it matters for [context]..."

4. **Tool Rec** — Share useful discovery
   "Been using [tool] for [use case]. Game changer because..."

5. **Behind the Scenes** — Dev life moment
   "Real talk: [honest insight about building/shipping]..."

Which angle resonates? Or want me to draft a specific one?
```

### 4. Draft & Refine

**Tweet Style Guide (Raki's Voice):**
- Direct, no fluff
- Technical but accessible
- Numbers and specifics over vague claims
- Occasional humor, not forced
- Hot takes welcome
- Thread when topic needs depth (max 3-4 tweets)

**Character limits:**
- Single tweet: 280 chars
- Thread: Label as 1/, 2/, etc.

**Formatting:**
- Use line breaks for readability
- Emojis sparingly (1-2 max)
- Links at end if needed
- No hashtag spam (1-2 relevant ones max)

### 5. Review & Post

**Before posting, show:**
```
📝 Draft Tweet:

[Tweet content here]

---
Characters: X/280
Timing: [Suggested post time based on engagement patterns]

✅ Post now
✏️ Edit
🗑️ Discard
⏰ Schedule for later
```

**Posting via browser automation:**
1. Open x.com
2. Login if needed (use saved session)
3. Click compose
4. Paste tweet
5. Confirm with Raki before clicking Post
6. Screenshot confirmation

## Content Pillars

Based on Raki's background, focus on:

1. **AI/ML Engineering** — Building AI systems, agents, LLMs in production
2. **Platform Engineering** — APIs, gateways, distributed systems
3. **Developer Experience** — Tools, workflows, productivity
4. **Career/Job Search** — Insights from the hunt (if comfortable sharing)
5. **Building in Public** — Sharing the journey with OpenClaw, personal projects

## Engagement Patterns

**Best times to post (PST):**
- Morning: 7-9 AM (catches East Coast lunch)
- Lunch: 11 AM - 1 PM
- Evening: 5-7 PM

**Avoid:**
- Late night (low engagement)
- Weekends (unless evergreen content)

## Thread Templates

### Launch/Ship Thread
```
1/ Just shipped [thing]. Here's what I learned 🧵

2/ The problem: [context]

3/ The solution: [approach]

4/ Key insight: [learning]

Repo/link: [if applicable]
```

### Hot Take Thread
```
1/ Unpopular opinion: [take]

Here's why 🧵

2/ [Supporting point 1]

3/ [Supporting point 2]

4/ [Nuance/caveat]

What do you think?
```

### TIL Thread
```
1/ TIL: [discovery]

Quick thread on why this matters 🧵

2/ [Explanation]

3/ [How I'll use it]

4/ Resources: [links]
```

## Profile Management

Store in `profile.json`:
```json
{
  "handle": "@[handle]",
  "bio": "[current bio]",
  "pinned_tweet": "[id if any]",
  "topics": ["AI", "Platform Engineering", "DevEx"],
  "posting_frequency": "2-3x per week",
  "last_posted": "2026-02-04",
  "draft_queue": []
}
```

## Safety

- **Always confirm** before posting
- **No controversial** political/social takes without explicit request
- **No employer mentions** unless cleared
- **No private project details** without permission
- **Screenshot** every post for records

## Analytics (Future)

Track in `analytics.json`:
- Posts and timestamps
- Engagement (likes, RTs, replies)
- Best performing content
- Follower growth

---

*This skill grows with use. Update voice/style as Raki's Twitter presence evolves.*
