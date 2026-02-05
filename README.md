# OpenClaw Skills

A collection of OpenClaw skills for job search, content creation, and automation.

## Skills

| Skill | Description |
|-------|-------------|
| **job-tracker** | Manage job application tracker (docx CRUD) |
| **job-roles** | Discover roles at companies (career page search) |
| **cover-letter** | Write tailored cover letters |
| **job-apply** | Browser automation for job applications |
| **referral-ask** | Generate referral request messages |
| **blog-writer** | Write and publish blog posts |
| **twitter-voice** | Generate tweets from daily work + trends |

## Usage

1. Copy skills to your OpenClaw workspace:
   ```bash
   cp -r <skill-name> ~/.openclaw/workspace/skills/
   ```

2. Replace placeholders with your actual values (see below)

3. Skills will appear in OpenClaw after restart

## Placeholders

These skills use placeholders for personal data. Replace with your own values:

| Placeholder | Description |
|-------------|-------------|
| `${HOME}` | Your home directory |
| `${WORKSPACE}` | OpenClaw workspace path |
| `${JOBS_DIR}` | Directory for job search files |
| `${EMAIL}` | Primary email address |
| `${EMAIL_ALT}` | Secondary email address |
| `${PHONE}` | Phone number |
| `${FULL_NAME}` | Full legal name |
| `${FIRST_NAME}` | First name |
| `${LAST_NAME}` | Last name |
| `${LINKEDIN_HANDLE}` | LinkedIn username |
| `${GITHUB_HANDLE}` | GitHub username |
| `${CURRENT_COMPANY}` | Current employer |
| `${UNIVERSITY}` | University name |
| `${LOCATION}` | City, State, Country |
| `${LOCATION_SHORT}` | City, State |
| `${VISA_STATUS}` | Work authorization details |
| `${NAME_PRONUNCIATION}` | Name pronunciation guide |
| `${RESUME_FILE}` | Resume filename |
| `${TRACKER_FILE}` | Job tracker filename |

## Shared Data

The `job-data/profile.json` file contains shared profile information used across job search skills. Update this file once, and all skills reference it.

## Blog Post

These skills are documented in detail: [Refactoring Skills: From Monolith to Modular](https://rkethamakka.github.io/blog/post.html?p=refactoring-skills-monolith-to-modular)

## License

MIT — fork, adapt, make it yours.
