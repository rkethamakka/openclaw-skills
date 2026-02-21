---
name: leetcode-solver
description: Solve LeetCode problems from Desktop screenshots. Use when Raki says "go", "leetcode", or wants to practice coding problems.
---

# leetcode-solver

Solve LeetCode problems from the latest Desktop screenshot.

## Trigger Phrases

- "go"
- "leetcode"
- "solve screenshot"
- "solve latest problem"

## Workflow

### 1. Find Latest Screenshot

```bash
ls -lt ~/Desktop/ | grep -iE '\.(png|jpg|jpeg)$' | head -1
```

### 2. Read the Image

Use the Read tool on the screenshot file.

### 3. Check if it's a Coding Problem

Look for indicators:
- LeetCode UI (problem number, difficulty tag, Examples section)
- Problem statement with Input/Output examples
- Code editor visible

If NOT a coding problem, respond: "Latest screenshot doesn't appear to be a coding problem."

### 4. Solve with Interview Format

**ALWAYS follow this format:**

#### Part 1: Approach (Interview Walkthrough)

- **Problem understanding** — Restate what we're solving
- **Brute force** — State the naive approach and why it's too slow (time/space complexity)
- **Key insight** — The "aha" moment or pattern recognition
- **Data structure choice** — Why HashMap/Tree/etc and not something else
- **Algorithm walkthrough** — Step by step logic
- **Edge cases** — What could break, empty input, etc
- **Complexity analysis** — Time and Space with reasoning

#### Part 2: Code

- Clean, readable implementation
- Comments only where non-obvious
- Prefer Java (Raki's interview language) unless specified otherwise
- Skip brute force implementation — go straight to optimal

#### Part 3: Example Walkthrough

- Walk through the given examples step by step
- Show how the algorithm processes the input
- Trace through data structure state changes
- Helps interviewer see you understand the solution

## Example Response Format

```
**LeetCode [NUMBER] - [TITLE]** ([DIFFICULTY])

---

## Approach (Interview Walkthrough)

**Understanding the problem:**
[Restate in own words]

**Brute force:**
[Naive approach] — O(?) time, O(?) space
Why we avoid it: [reason - too slow, TLE, etc.]

**Key insight:**
[The pattern or trick]

**Why [data structure]:**
[Justify the choice]

**Algorithm:**
1. [Step 1]
2. [Step 2]
...

**Edge cases:**
- [Edge case 1]
- [Edge case 2]

**Complexity:**
- Time: O(?) because...
- Space: O(?) because...

---

## Code

[Clean implementation]

---

## Example Walkthrough

**Example 1:** Input = [...]

```
Step 1: [state]
Step 2: [state]
...
Result: [output]
```

**Example 2:** Input = [...]

```
[Trace through]
```
```

## Notes

- Default language: Java
- If image is unclear, ask for a clearer screenshot
- If problem is cut off, solve what's visible and note assumptions
