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

Below is an example I liked. I one-shot it with GPT-5.2 after I supplied it with good context.

Find it [here](https://gist.github.com/tadas-subonis/7f882d46755c868cfd3aa7438c6b958a)

## Closing

LLMs don’t replace your judgment. They expose it.

If you bring clear goals, real context, and hard standards, you get real work.
If you paste a vague ask and accept the first draft, you get slop.

Be the manager. Ship outcomes. Save the playbooks.
