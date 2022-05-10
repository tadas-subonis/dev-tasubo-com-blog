---
layout: post
title: Tips for new developers to get productive fast
author: Tadas Šubonis
date: '2022-05-08'
tags:
 - api
 - software development
 - tips
 - clean code
---
# About
This post is intended to get new developers up-to-speed quickly on the best software
engineering practices. These tips are tailored for remote developers.

# Initial readings

To get some coding basics in order, you should do the following readings (multiple links are provided in the text):

 * Read the first 100 pages of [Clean Code by Robert C. Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - this will get you up to speed regarding why maintainable code matters
 * Use [package by feature](http://www.javapractices.com/topic/TopicAction.do?Id=205#:~:text=Package%2Dby%2Dfeature%20uses%20packages,with%20minimal%20coupling%20between%20packages.) - code grouping by layer doesn't really make sense from maintanability and business sense. 
 * [Don't use inheritance - use composition](https://python-patterns.guide/gang-of-four/composition-over-inheritance/). Most of the problems in OOP can be very efficiently and clearly expressed using interfaces and composition. Inheritance is unreadble, difficult to maintain, and update. Just don't use it.
 * Learn [immutable patterns](https://dev.tasubo.com/2020/04/functional-object-oriented-programming.html). You can do Object-Oriented programming with functional principles - these two concepts are orthogonal.
  * [Immutables](https://immutables.github.io/) - Immutable objects for Java
  * [Dataclasses](https://docs.python.org/3/library/dataclasses.html) - use `frozen=True` on Python Dataclasses
 * [Prematature optimization is evil](https://wiki.c2.com/?PrematureOptimization) - don't waste your time with your false opinions improving things that do not matter
	
	
Read all of the linked material and spend some time understanding it. It will be important to your day-to-day work.

# Keep things simple

The first tip for success is to keep things simple.
As soon as people learn a few patterns (Factory, Service, Decorator), they start spamming these things everywhere even when it's not needed.
 
**Focus on creating simple and readable code. Don't overengineer.**

## Generalization and premature code abstractions

Premature optimization is evil - same as performance optimizations, there is no points trying to 
come up with general soluytion before we understand the problem well. Start simple.

I've seen plenty of architected-level code designers coming up with bizarre inheritence trees, overused generics, only to realize that all that fancy structure is bullshit, doesn't reflect reality, and only gets in a way to getting things done.

## Write tests first, use functional description language

I am a big fan of behavior driven development and you don't need any fancy frameworks for that. BDD means just a few simple things:
* Your tests are structured using Given/When/Then structure (implicitly or explicitly)
* The test itself includes definitions of expected behavior in a language that domain people can understand

For example, don't write
```java
void test1() {}
```

Instead, write

```java
void when_at_least_one_user_bets_other_users_should_not_be_able_to_check() {

}
``` 

When writing tests, describe the behavior of the functionality within the test. Treat
it like a documentation.

There should be a clear Given, When, Then structure inside the test:
```java
void when_email_is_sent_logs_should_be_updated() {
	//given
	var emailService = emailSendingServiceIsReady();
	var email = standardEmailIsReady();
	var loggingService = logginServicePrepared();

	//when
	emailService.send(email);

	//then
	int noOfLinesWithEmail = loggingService.findLogs("email");
	assertThat(noOfLinesWithEmail, greaterThan(0))
}
```

## Hamcrest
Try to use modern matching frameworks such as Hamcrest:
 * [JavaHamcrest](http://hamcrest.org/JavaHamcrest/)
 * [PyHamcrest](https://github.com/hamcrest/PyHamcrest)
 * [Rust](https://github.com/Valloric/hamcrest2-rust)

They allow you to write flexible matchers that can often convey business meaning.

## Avoid nulls, avoid defensive programming 
Defensive programming only makes sense when you are dealing with poor quality code by external parties that's calling your code and you need to make sure it works.

Lot's of ANDs there so in most cases just prefer [validating and failing early](/2013/06/handling-parameter-validation.html).

### Null Object
[Null pointers are billion dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/). When you are building your own interfaces/code ensure that your code never returns or uses nulls anywhere. Always return empty objects (use NullObject pattern if needed) or use Optional in Java.

## Study SOLID principles

It's useful to undestand SOLID principles. I'll briefly introduce them here but really it's outside of the scope of this post. Most importantly, once you learn and understand them, don't overdo with - they are guiding principles but you should still be focusing on producing simple, readable, code first.

## Use modern IDEs
Get a good development environment. IntelliJ is a great choice. Using outdated tools like Eclipse or 
dealing with simple editors like Sublime you won't unlock the full potential of your productivity.

## Learn basics of domain driven design
Domain driven design provides good guidelines how we should be building code, what kind of "words" we should use, and how should we work on large codebases as a team.

5 minute summary:
 * Use [Ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html) - name all the things the same way always. The same concept should not have different names. The same concept should have only one name.
 * Use [aggregates](https://martinfowler.com/bliki/DDD_Aggregate.html) as a boundary for transactional guarantees. Don't worry about transactional consistency across multiple entities if they are from multiple aggregates.
 * Master [repository pattern](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design#the-repository-pattern) - all external data repositories (services, databases etc) should be accessed via Repository
 * Use [Services](https://lostechies.com/jimmybogard/2008/08/21/services-in-domain-driven-design/) - services are like entry points to your application that start some
  business process. You don't need them for every little thing, but you should be using them.


Repository example:
```java
class User {
	String id;
	String name;
}

class UserRepository {
	Iterable<User> findAll();
	Iterable<User> findAllBy(Filters filters);
	User save(User save);
	User findOne(String id) throws EntityNotFoundException;
}

```

This ensures that you have a simple and straighforward interface to:
	• Retrieve and save entities
	• All the encoding/decoding stuff is handled in one place
	• Repository can ensure transaction integrity for that one entity when saving it


# Working culture

## Offline chatting and communication

For remote teams asynchronous, offline communication is extremely important.  This could become a major source of productivity problems or this could become a very effictive tool that give an advantage for in-office teams.


## Messaging
Whenever you have questions, ask them in public channels. Avoid 1-to-1 communication as much as possible as that prevents others:
* From helping you when the other person isn't available
* Learning from your questions
* Providing context and additional understanding

Personally, I will almost never answer questions in Private Messages unless it's related to matters that should be discussed privately (passwords, performance reviews, compensation).

Asking and answering questions publicly encourages learnings for the entire team.

> First code is A6X

## Questions 
Often you will have senior or more experienced developers that can help you. However, before you start asking them spend 30min trying to solve the problem yourself. Google the problem. Search the internal wiki for documentation. Try searching for similar tasks in task history and check how they were solved/built.

This way you will learn more about the environment and you will often be able to answer questions yourself.

If in 30min you can't come up with a solution to your problem, ask experienced developers. Once you ask, don't stop working on the solution. Alternatively, move to another task.

Once you get your answer, add it to the wiki. If it's a complicated topic, create a whole page for it (it doesn't to be long). 

Otherwise, just append question and answer to FAQ on the wiki.

## Code & task management

All modern task management systems can sync with the code repositories. It's useful as it provides a lot of shortcuts to find relevant tasks and code that was done for those tasks.

To make it work in JIRA, always start a new branch when you start working on some task. Include task id (PROJ-NUMBER) in the branch name (like APP-142_new_feature_branch).

When making commits, allways include task id at the beginning of your commit ("APP-142 Creating a final test version").

## Scrum

Scrum is one of the most widely used and misused agile frameworks.

Get familiar with [Scrum framework](https://www.atlassian.com/agile/scrum) and what are the following Scrum [rituals](https://www.atlassian.com/agile/scrum/ceremonies):
 * Sprint Planning
 * Daily updates
 * Sprint Review
 * Sprint Retrospective


### Daily updates
Use daily standup/updates as a tool to clearly structure thoughts for the day.

In general, the daily update should sound something like this:
 1. What I've achieved since the last update?
 2. What is my plan for today?
 3. Are there any blockers that prevent me from working?

One common falacy here that you should avoid, is too general updates. Something like:
 1. Worked on email message
 2. continue working on message

This is **bad**.

If you can't formulate clearly the work you can't do, you won't be able to compelete it. Instead, write it like this:
 1. I've created an email message that will greet new customers
 2. Today I'll make a follow up greeting email in case a customer didn't complete registration
 3. no blockers

This is specific and clear. If you can clearly articulate what you need to do, you can do that much more during the sprint.

### Tasks 
Ensure that the task is clear to you. Each task should have acceptance criteria. If it doesn't have any, add them yourself.

Use acceptance criteria to write tests. Often, they should be almost 1-to-1 mapping. If the acceptance criteria was "the app should show popup when there is a new version available", surely you can write test with something like:

```java
void  app_should_show_popup_when_new_version_is_available() {
	Given() {
		ThereIsANewVersion();
	}
	
	When() {
		CheckForNewVersion();
	}
	
	Then() {
		popupIsShown(); 
	}
}

```

Write the test first, ensure it fails, and then start working on the code itself.


### Avoid scope creep.
Try not to do any more than it is necessary to make the tests pass.
Avoid premature genarilazion of the code. If the solution that you come up isn't good enough, you can do the refactorings to improve the code after the test passing.

If you see that there is a number of substancial improvements coming, always create a new task and give it new story points. Do not inflate the scope of the existing task. Focus on delivering the current task.

### What is a "DONE" task?

Criteria for DONE
 - task is reviewed by your peers
 - all the problems that were pointed out by your peers are fixed
 - task is approved for merging by the team lead
 - task is merged into the master for release

Only then the task is done. Anything else is in progress and doesn't really bring any business value.

As the result, we celebrate people that can get tasks DONE.

> Second code is 9G4


# Outro

This should be enough to get you started on the right track.