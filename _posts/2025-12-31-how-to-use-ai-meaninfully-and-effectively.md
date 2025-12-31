---
layout: post
title: "How to use AI meaningfully and effectively"
date: 2025-12-31 12:00:00 +0000
categories: [ai, productivity]
tags: [ai, best-practices, workflow]
---

## Intro
Recently, I've realised that a lot of newer developers and information workers
in general haven't realised that the availability of LLMs like ChatGPT and Perplexity
has changed expectations for what "good work" looks like.

TL;DR: ***the bar has increased***

Assume this:
- It's completely fine to use LLMs - and you should use them.
- It's not fine to produce AI slop.
- You + AI > AI alone.


## Don't be a bystander

My biggest beef is when people get an assignment, copy-paste it to the 
LLM, and then copy-paste the answer as the completed task.

I can do this myself, you know, and it will be quicker than asking 
you, the intermediary, to do it.

That begs the question: what's your value in this process? Zero.

If your value is zero, you won't be kept on the payroll for long.

As AIs become smarter, you'll be tempted to take the easier path by copy-pasting the answer.

This is wrong - you need to do more.

## Build understanding and criteria

Let's take an example like: "Build me a go-to-market plan to launch a todo-business
SaaS".

If I just copy this request, ask GPT to build me a plan, and copy-paste it back,
it will give you something generic - maybe even something usable if you squint the right way. But this is AI slop.

Start by researching what a good GTM plan looks like. Get a feel for what it should cover - and what it should not.

Then research what has worked for other people and what hasn't. Find some good examples you like. Find bad ones too.

Figure out what's specific about your situation and whether you can turn it into an advantage.

## Be a manager

In the age of AIs, agents, LLMs, and whatnot, you (as an individual contributor)
are becoming less of a doer and more of a deliverer.

You oversee multiple agents and tools to help you deliver something useful. Something that moves the needle.

Basically, you are becoming a manager. A manager is roughly responsible for:

 1. Set direction: goals/priorities/metrics, roadmap, tradeoffs & "no"
 1. Deliver through others: ship outcomes, remove blockers/manage deps, maintain quality & sustainable pace
 1. Build the team: hire/onboard/role clarity, coach & give feedback, manage performance early
 1. Run the operating system: rituals (plan/standup/review/retro), improve process/tools, protect focus from thrash
 1. Align & communicate: clear updates, stakeholder alignment, expectations & risk management

The AI-manager version looks more like:
 1. Pick the work: choose the few tasks AI can win; define "good"; set limits.
 1. Use it to move faster: draft, sort, compare, plan - then you decide and ship.
 1. Teach the team: share good prompts; review outputs; fix sloppy use fast.
 1. Make it repeatable: templates, checklists, saved prompts; human review on key items.
 1. Stay aligned: tell people what AI did, what you checked, and what risks remain.

## Most common pitfalls

To make this post complete and useful, I've collected a few common pitfalls I've noticed.

It's really easy to produce AI slop, but it's also easy to avoid if you steer clear of a few traps.
AI-generated output is not automatically slop.

###  Vague prompts
Avoid "generate me a go-to-market plan". Use something like:
"You are an expert sales and marketing specialist. Create a practical but comprehensive plan that
can be used by junior specialists to execute a product launch. Be sure to include cold outreach and how to utilise an existing professional network."

Not perfect but much better.

When you leave gaps, the model fills them with safe, generic lines. It has no rails. So it tries to please everyone. You get slop.

### Multiple tasks 
It's better to give a single task in a single prompt and then build the 
entire result gradually from 2–4 prompts.

Packing many tasks into one prompt makes the output worse.

When you ask for analysis, marketing angles, a hiring plan, and a revenue forecast all at once, the model has to switch gears. Attention gets spread thin. Each part comes out soft.

Do it in steps. One task at a time. Build the result.

 - Request 1: Analyze customer feedback. Name the top 3 pain points.
 - Request 2: Using those pain points, suggest 3 marketing angles.
 - Request 3: Using those pain points, define hiring needs.

Single-task prompts, in sequence, beat one big prompt every time.

### Too chatty output
Sometimes LLMs get really chatty. Make sure the text is concise, well-structured, and easy to read.

It defeats the purpose if I have to use an LLM again to summarise your document after you used an LLM to produce it.

### The AI voice
This often goes with the chattiness: it has that annoying "AI voice".


These words and phrases scream "ChatGPT wrote this":

**Words to ban:** delve, crucial, pivotal, leverage, utilize, robust, 
comprehensive, tapestry....

**Phrases to kill:**
- "In today's fast-paced world"
- "It's important to note that"
- "In the ever-evolving landscape"
- "Let's dive in"
- "Unlock the potential of"
- "At the forefront of"
- "Embark on a journey"

**Structural tells:**
- "It's not just X, it's also Y"
- "The result? [dramatic one-liner]"
- Perfectly uniform paragraph lengths
- Every section follows identical structure

Add these to your prompt: "Do not use the following words: [list]"

Or better, ask it to "write as Hemingway".


### Not Iterating or Refining

The most overlooked mistake is taking the first draft and calling it done.

The first output is usually 60–70% good. It sounds fine. But it is generic. It lacks your context. It misses the sharp edges that matter.

Use a simple loop:
 - Get a draft. Run the prompt.
 - Critique it. Say: "Too generic. Make it specific to my situation. Use my numbers. Use my format. Give real examples."
 - Refine it. Ask for a better version based on that feedback.
 - Stress-test it. Ask: "What’s weak here? What would a skeptic challenge? What am I missing?"

Iterations separate average output from work you can trust.

### Give examples and outline skeletons

LLMs work better with **rails**.

Give them a pattern to follow. A plan. A template. Or one good example. 

Use three tools:

* **A template:** "Use these headings. Fill each one." 
* **A checklist:** "Must cover A, B, C. Don’t miss any." 
* **An example:** "Here’s a good output. Match this style and depth." 

Paste this when you want strong output:

* **Context:** (3–6 bullets)
* **Goal:** (1 line)
* **Must cover:** (your bullet list)
* **Format:** (exact headings or bullet shape)
* **Constraints:** (length, tone, what to avoid)

It stops generic filler. It forces coverage. It makes results repeatable. 

## Make notes and guides

When something works - templates, instructions, prompts, model version - make a note of it.

Later, you can organise this into an effective library of tools to help you deliver higher quality work, faster.

When something fails, write that down too.

What to save:
- Prompts that worked. The exact text, not a summary.
- Which model. Claude and GPT behave differently.
- What context helped. Examples, roles, constraints.
- What failed. Saves time later.

## Go-to-Market example

(Below is an example I liked. I one-shot it with GPT-5.2 after I supplied it with good context.)

Let’s apply the whole workflow to a simple case:

**Product:** "Todo-business SaaS" (team task manager)
**Goal:** launch v1 and get first paying customers
**Constraint:** small team, no brand, limited budget

### Step 0 - Put rails in place

Before you ask the model to "make a GTM plan," give it your **shape** and **rules**.

Copy this skeleton and fill the brackets:

* **Audience:** [who buys]
* **Problem:** [what hurts today]
* **Why now:** [what changed]
* **Differentiator:** [why you]
* **Budget:** [time + €]
* **Success metric:** [number + date]
* **Constraints:** [legal, channels you won’t use, etc.]

Now the first prompt is not "write plan." It is "build structure."

```text
You are a B2B go-to-market lead.

Task: Propose the best GTM plan structure for launching a new B2B SaaS.

Context:
- Product: team task manager for small businesses
- Budget: €2k/month, 1 founder + 1 engineer
- Target: EU-based service companies (10–100 employees)
- Goal: 10 paying customers in 60 days
- Constraints: GDPR-sensitive, no paid search yet

Output:
- A GTM outline with headings only
- No fluff. No generic advice.
```

You just forced a usable template.

### Step 1 - Research, then narrow the problem

Next, you do *one job*.

We start with pain. Not channels. Not slogans.

Feed it real inputs. Even rough ones.

Example customer notes (fake, but shaped like real ones):

```text
Customer snippets:
1) "Tasks live in Slack, email, and people’s heads. Nothing is reliable."
2) "We miss deadlines because ownership is unclear."
3) "Asana is too heavy. People stop using it."
...
8) "Managers want visibility without nagging."
9) "We already pay for Microsoft 365."
10) "If setup takes more than 30 minutes, nobody adopts it."
```

Prompt:

```text
Analyze the snippets.
Output:
- Top 3 pain points (ranked)
- Evidence: quote 2 lines per pain point
- The "job to be done" sentence for each
- A short note on what NOT to build for v1
```

Now you have criteria. You can say "no" with confidence.

### Step 2 - Positioning, but only from the pain

Next single task.

```text
Based on the top 3 pain points, write:
- 1 positioning statement (one sentence)
- 3 value propositions (one sentence each)
- 5 proof points we can realistically claim for v1
Constraints:
- No hype words. No "leverage," "robust," "comprehensive."
- Make it specific to EU service companies.
```

If it gets generic, you iterate:

```text
Too generic.
Rewrite using:
- a concrete example (agency / accounting firm / consulting)
- a specific outcome (time saved, fewer missed deadlines)
- a clear differentiator vs Asana/Trello
```

### Step 3 - Channels, but with tradeoffs

Don’t ask for "all channels." Ask for the best few **given your limits**.

```text
Given our context (budget €2k/mo, 1 founder), pick 2 primary acquisition channels.
For each:
- Why it fits our audience
- Step-by-step weekly plan for 4 weeks
- What assets we must create
- What we will NOT do and why
Output as a table.
```

This is "set direction" and "say no."

### Step 4 - Produce assets, one at a time

Now you use AI like a tool bench.

**Cold email:**

```text
Write 2 cold emails to EU service companies (10–100 staff).
Goal: book a 15-minute call.
Constraints:
- 120 words max
- Plain text
- Mention one pain point and one proof point
- Add 3 subject lines
- No AI voice. No clichés.
```

**Landing page draft:**

```text
Draft landing page copy with sections:
- Hero (headline + subhead + CTA)
- 3 pain bullets
- How it works (3 steps)
- Trust section (GDPR, EU hosting if true, etc.)
- FAQ (5)
Keep it short. Use simple words.
```

**Demo script:**

```text
Write a 7-minute demo script.
Audience: operations manager at a 30-person agency.
Must show:
- Ownership and deadlines
- Client status view
- Recurring checklists
End with a clear close.
```

### Step 5 - Adversarial review

This is where you stop lying to yourself.

```text
Act as a skeptic buyer.
What is weak, unclear, or risky in our positioning and channel plan?
List:
- 10 hard questions we should expect
- 5 claims that need proof
- 5 ways this launch fails
Then propose fixes.
```

You just did a pre-mortem.

### Step 6 - Turn it into a one-page execution plan

Only now do you ask for the final artifact.

```text
Create a 1-page GTM plan.
Must include:
- ICP
- Pain points
- Positioning
- Primary channels (2)
- 4-week plan with weekly milestones
- Metrics dashboard (inputs and outputs)
- Risks and mitigations
Format: headings + bullets only.
```

### Step 7 - Save what worked

This is the part people skip.

Create a folder like:

* `gtm/`

  * `00-outline-prompt.md`
  * `01-pain-analysis-prompt.md`
  * `02-positioning-prompt.md`
  * `03-channels-prompt.md`
  * `04-assets/`
  * `05-adversarial-review.md`
  * `README.md` (what to paste each time)

Write down:

* the prompts
* the model used
* what inputs mattered
* what the model got wrong
* the fix you used

Next time, you start at 70% quality. Not 0%.

## Closing

LLMs don’t replace your judgment. They expose it.

If you bring clear goals, real context, and hard standards, you get real work.
If you paste a vague ask and accept the first draft, you get slop.

Be the manager. Ship outcomes. Save the playbooks.
