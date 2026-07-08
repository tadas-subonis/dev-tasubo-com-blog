---
layout: post
title: Work habits and systems for new developers
author: Tadas Šubonis
date: '2022-05-08'
tags:
 - software development
 - tips
 - teamwork
 - remote work
---
# About
This post collects the working-culture tips - communication, task management, and
process habits - that help new developers become productive members of a team. These
tips are tailored for remote developers. For the complementary set of code-focused
tips, see [Technical tips for new developers](/2022/05/technical-tips-for-new-developers.html).

# Working culture

## Offline chatting and communication

For remote teams asynchronous, offline communication is extremely important.  This could become a major source of productivity problems or this could become a very effective tool that give an advantage for in-office teams.


## Messaging
Whenever you have questions, ask them in public channels. Avoid 1-to-1 communication as much as possible as that prevents others:
* From helping you when the other person isn't available
* Learning from your questions
* Providing context and additional understanding

Personally, I will almost never answer questions in Private Messages unless it's related to matters that should be discussed privately (passwords, performance reviews, compensation).

Asking and answering questions publicly encourages learnings for the entire team.

## Questions 
Often you will have senior or more experienced developers that can help you. However, before you start asking them spend 30min trying to solve the problem yourself. Google the problem. Search the internal wiki for documentation. Try searching for similar tasks in task history and check how they were solved/built.

This way you will learn more about the environment and you will often be able to answer questions yourself.

If in 30min you can't come up with a solution to your problem, ask experienced developers. Once you ask, don't stop working on the solution. Alternatively, move to another task.

Once you get your answer, add it to the wiki. If it's a complicated topic, create a whole page for it (it doesn't to be long). 

Otherwise, just append question and answer to FAQ on the wiki.

## Code & task management

All modern task management systems can sync with the code repositories. It's useful as it provides a lot of shortcuts to find relevant tasks and code that was done for those tasks.

To make it work in JIRA, always start a new branch when you start working on some task. Include task id (PROJ-NUMBER) in the branch name (like APP-142_new_feature_branch).

When making commits, always include task id at the beginning of your commit ("APP-142 Creating a final test version").

## Scrum

Scrum is one of the most widely used and misused agile frameworks.

Get familiar with [Scrum framework](https://www.atlassian.com/agile/scrum) and what are the following Scrum [rituals](https://www.atlassian.com/agile/scrum/ceremonies):
 * Sprint Planning
 * Daily updates
 * Sprint Review
 * Sprint Retrospective

For a more detailed walkthrough, see the [Scrum introduction](/2023/09/scrum-intro.html).

### Daily updates
Use daily standup/updates as a tool to clearly structure thoughts for the day.

In general, the daily update should sound something like this:
 1. What I've achieved since the last update?
 2. What is my plan for today?
 3. Are there any blockers that prevent me from working?

One common fallacy here that you should avoid, is too general updates. Something like:
 1. Worked on email message
 2. continue working on message

This is **bad**.

If you can't formulate clearly the work you can't do, you won't be able to complete it. Instead, write it like this:
 1. I've created an email message that will greet new customers
 2. Today I'll make a follow up greeting email in case a customer didn't complete registration
 3. no blockers

This is specific and clear. If you can clearly articulate what you need to do, you can do that much more during the sprint.

### Tasks 
Ensure that the task is clear to you. Each task should have acceptance criteria. If it doesn't have any, add them yourself.

Use acceptance criteria to write tests. Often, they should be almost 1-to-1 mapping. For how to write those tests - naming, structure, and the Given/When/Then pattern - see [Write tests first, use functional description language](/2022/05/technical-tips-for-new-developers.html#write-tests-first-use-functional-description-language) in the technical tips post.


### Avoid scope creep.
Try not to do any more than it is necessary to make the tests pass.
Avoid premature generalization of the code. If the solution that you come up isn't good enough, you can do the refactorings to improve the code after the test passing.

If you see that there is a number of substantial improvements coming, always create a new task and give it new story points. Do not inflate the scope of the existing task. Focus on delivering the current task.

### What is a "DONE" task?

Criteria for DONE
 - task is reviewed by your peers
 - all the problems that were pointed out by your peers are fixed
 - task is approved for merging by the team lead
 - task is merged into the master for release

Only then the task is done. Anything else is in progress and doesn't really bring any business value.

As the result, we celebrate people that can get tasks DONE.

# Outro

Good work habits are what turn solid coding skills into real team output. Pair these
with the [technical fundamentals](/2022/05/technical-tips-for-new-developers.html) and
you'll be productive fast.
