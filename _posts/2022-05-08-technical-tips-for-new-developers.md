---
layout: post
title: Technical tips for new developers - clean code and design
author: Tadas Šubonis
date: '2022-05-08'
tags:
 - api
 - software development
 - tips
 - clean code
---
# About
This post collects the technical, code-focused tips that help new developers write
maintainable software fast. For the complementary set of tips about work habits and
team systems, see [Work habits and systems for new developers](/2022/05/work-habits-and-systems-for-new-developers.html).

# Initial readings

To get some coding basics in order, you should do the following readings (multiple links are provided in the text):

 * Read the first 100 pages of [Clean Code by Robert C. Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - this will get you up to speed regarding why maintainable code matters
 * Use [package by feature](http://www.javapractices.com/topic/TopicAction.do?Id=205#:~:text=Package%2Dby%2Dfeature%20uses%20packages,with%20minimal%20coupling%20between%20packages.) - code grouping by layer doesn't really make sense from maintainability and business sense. 
 * [Don't use inheritance - use composition](https://python-patterns.guide/gang-of-four/composition-over-inheritance/). Most of the problems in OOP can be very efficiently and clearly expressed using interfaces and composition. Inheritance is unreadable, difficult to maintain, and update. Just don't use it.
 * Learn [immutable patterns](https://dev.tasubo.com/2020/04/functional-object-oriented-programming.html). You can do Object-Oriented programming with functional principles - these two concepts are orthogonal.
   * [Immutables](https://immutables.github.io/) - Immutable objects for Java
   * [Dataclasses](https://docs.python.org/3/library/dataclasses.html) - use `frozen=True` on Python Dataclasses
 * [Premature optimization is evil](https://wiki.c2.com/?PrematureOptimization) - don't waste your time with your false opinions improving things that do not matter
	
	
Read all of the linked material and spend some time understanding it. It will be important to your day-to-day work.

# Keep things simple

The first tip for success is to keep things simple.
As soon as people learn a few patterns (Factory, Service, Decorator), they start spamming these things everywhere even when it's not needed.
 
**Focus on creating simple and readable code. Don't overengineer.**

## Generalization and premature code abstractions

Premature optimization is evil - same as performance optimizations, there is no point trying to 
come up with general solution before we understand the problem well. Start simple.

I've seen plenty of architected-level code designers coming up with bizarre inheritance trees, overused generics, only to realize that all that fancy structure is bullshit, doesn't reflect reality, and only gets in a way to getting things done.

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
	var loggingService = loggingServicePrepared();

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

It's useful to understand SOLID principles. Briefly:

 * **S**ingle Responsibility - a class should have one reason to change
 * **O**pen/Closed - open for extension, closed for modification
 * **L**iskov Substitution - subtypes must be substitutable for their base types
 * **I**nterface Segregation - many specific interfaces beat one general-purpose interface
 * **D**ependency Inversion - depend on abstractions, not concretions

Most importantly, once you learn and understand them, don't overdo it - they are guiding principles but you should still be focusing on producing simple, readable, code first.

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

This ensures that you have a simple and straightforward interface to:
	• Retrieve and save entities
	• All the encoding/decoding stuff is handled in one place
	• Repository can ensure transaction integrity for that one entity when saving it

For a deeper dive, see the [Crash course into Domain Driven Design](/2022/07/crash-course-domain-driven-design.html).

# Outro

Get these technical fundamentals right and you'll produce code that your team can actually
maintain. Once you have the coding basics down, pair them with the right
[work habits and systems](/2022/05/work-habits-and-systems-for-new-developers.html).
