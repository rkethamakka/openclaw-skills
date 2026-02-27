---
name: eb1a-data
description: Shared config and data for EB1A skills. Not a standalone skill — referenced by eb1a-articles, eb1a-judging, and related skills.
---

# eb1a-data

Shared configuration for all EB1A skills. Not invoked directly.

## Config Location

`/opt/homebrew/lib/node_modules/openclaw//opt/homebrew/lib/node_modules/openclaw/skills/eb1a-data/config.json`

## Usage

Other skills load:
```python
import json
with open("/opt/homebrew/lib/node_modules/openclaw//opt/homebrew/lib/node_modules/openclaw/skills/eb1a-data/config.json") as f:
    config = json.load(f)

drive_root = config["drive"]["root"]
```
