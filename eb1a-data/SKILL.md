---
name: eb1a-data
description: Shared config and data for EB1A skills. Not a standalone skill — referenced by eb1a-articles, eb1a-judging, and related skills.
---

# eb1a-data

Shared configuration for all EB1A skills. Not invoked directly.

## Config Location

`~/.openclaw/skills/job-data/eb1a-config.json`

## Usage

Other skills load:
```python
import json
with open("~/.openclaw/skills/job-data/eb1a-config.json") as f:
    config = json.load(f)

drive_root = config["drive"]["root"]
```
