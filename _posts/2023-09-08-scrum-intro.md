---
layout: post
title: Scrum Introduction
author: Tadas Šubonis
date: '2023-09-08'
toc: true
tags:
 - scrum
 - management
---

A general overview and introduction to Scrum for junior developers that haven't done this before.

# Planning

The beginning of each sprint starts with planning. During this phase:

- Items from the backlog are prioritized, with the highest-priority items selected for inclusion in the upcoming sprint.
- Team members use 'planning poker' to estimate the effort required for each task. For more on planning poker, visit [Scrum Poker Online](https://www.scrumpoker-online.org/en/).
- Estimates are quantified in story points, with each point representing a defined task size or scale.

# Execution & Daily Updates

The execution phase spans the next two weeks after planning. Here are the guidelines for maintaining clear communication:

## Daily Updates 
Each team member starts their work day with a concise update. The objectives of these updates are:

1. Ensuring team alignment and maintaining synchronization.
1. Clearly stating daily expectations and reporting progress.

A typical update includes:

- What I've worked on since the last update: This provides insight into completed tasks and any challenges faced.
- What I plan to work on today (or until the next update): This gives a clear roadmap of immediate priorities, aiding team coordination.
- Any blockers encountered: Mention only if relevant, offering a brief description, not an exhaustive report.

**Note**: Updates should be brief, clear, and delivered at the start of the work day for maximum utility. Updates at day's end resemble retrospective reports and miss out on the proactive benefits of morning updates. One key advantage of a morning update is setting clear objectives for the day—a known productivity enhancer.

Here's an example:

1. "I've completed 90% of the simulator code but faced a challenge."
2. "Today, I'll finish the code and address the challenge."
3. "The programming language I'm using lacks certain distribution features, but I believe a workaround is feasible."

*For Part-time Workers*: Regardless of the work volume, daily updates are essential. If no tasks were undertaken on a given day, this should be specified in the update. Consistency in updates reduces confusion and ensures everyone is in the loop.

## Task Workflow in Jira Board

A task in Jira can typically transition through several states:

- **TODO**: A task that no one has started working on yet.
- **INPROGRESS**: The task has been started but isn't finished.
- **BLOCKED**: The progression of the task is impeded by some issue or dependency.
- **REVIEW**: The task is ready for evaluation. Depending on its nature:
    - Code-oriented tasks involve reviewing a pull request and offering feedback.
    - Research tasks generally require a review of the corresponding wiki page.
- **DONE**: The task has been fully completed.
- **NEEDS UPDATE**: The task requires additional work due to discovered deficiencies.

It's essential to update tasks regularly. Any task should not remain stagnant in a particular state for too long (3-5 days) after moving from TODO. If a task lingers in INPROGRESS, it might be too extensive and needs breaking down or could actually be BLOCKED. When a task is stuck in REVIEW, the assignee should prompt the relevant individuals to finalize the review, progressing it to either DONE or NEEDS UPDATE.

## Task Workflow - General Procedure

1. **Initialization**:
    - Assign a task in Jira, changing its status to INPROGRESS.
    - For code-based tasks, initiate a branch in the repository using the format `TaskNumber_Short_task_description`.
    - For research or documentation tasks, create a placeholder in the dedicated Confluence page with a descriptive title.
    
2. **Progress**:
    - Continually commit updates to the branch for code tasks.
    - For research tasks, update the documentation or report.

3. **Review Preparation**:
    - Push the latest code changes to the dedicated branch.
    - Ensure that the pipeline is green (all tests and linting steps are successful).
    - Verify that the report contains all necessary details.
    - Add a reference to the Confluence report within the Jira task.
    - Transition the story from INPROGRESS to NEEDS REVIEW.
    - Notify potential reviewers, either by tagging them in the Jira task or sending a Skype message.

4. **Review Process**:
    - The reviewer evaluates the task, leaving feedback on both the merge request and the documentation/report.
    - If changes are required, the task is moved to the NEEDS UPDATE status, with the merge request marked similarly. The original assignee is then notified. If no changes are needed, the task progresses to DONE.

5. **Post-Review**:
    - If changes are required, halt all other tasks. Addressing the feedback becomes the top priority.
    - Review the report, resolving any comments.
    - Address feedback from the code review. If no comments remain, and the reviewer approves, the code can be merged.
    - Notify the reviewer once comments are resolved.
    - This process repeats until the task is devoid of comments, the code is approved, merged, and the pipeline remains green.
    - Conclusively, move the task to DONE.


# Review & Retrospectives

At the sprint's conclusion—typically two weeks:

- Each team member presents their accomplishments.
- The definition of "Done" is anything that's ready for client use or delivery.
- Researchers should offer summaries of their findings, preferably hosted on the team's wiki.
- Engineers are expected to present code or demonstrate functionality.

Remember, the essence of Scrum lies in teamwork, transparency, and continuous improvement. Regular and effective communication is key to harnessing the collective strength of the team.