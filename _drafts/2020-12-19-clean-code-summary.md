---
layout: post
title: Functional Programming for Data Scientists
author: Tadas Šubonis
date: '2020-12-19'
tags:
 - functional programming
 - software development
 - data engineering
---



# Intro

It would be the best for the reader to just buy Clean Code book by Robert C. Martin, however, I am going to 
summarize the most important rules to as a simple reference to get started quickly.

# Why it is important?

In the end, the code is rarely written once and forgotten. In majority of the cases,
you write new code, read it many many times, and then occasionally update it.

You get to read it often to understand what it is doing. Other need to do the same -
you can't understand the code without reading it (usually a lot of times).

And it is very rare for the code to be written once and forgotten - 
it gets updated by the original writer and all the other people after him.

So let's make it easy to do so:
 - easy to read
 - easy to understand
 - easy to change

## Some quotes

Some quotes from _Clean Code_ regarding the code :

> I like my code to be elegant and efficient. The logic should be straightforward to make it hard for bugs to hide, the 
> dependencies minimal to ease maintenance, error handling complete according to an articulated strategy, and 
> performance close to optimal so as not to tempt
> people to make the code messy with unprinci-
> pled optimizations. Clean code does one thing
> well.
 - Bjarne Stroustrup

> Clean code can be read, and enhanced by a
> developer other than its original author. It has
> unit and acceptance tests. It has meaningful
> names. It provides one way rather than many
> ways for doing one thing. It has minimal depen-
> dencies, which are explicitly defined, and pro-
> vides a clear and minimal API. Code should be
> literate since depending on the language, not all
> necessary information can be expressed clearly
> in code alone
 - Dave Thomas

> I could list all of the qualities that I notice in
> clean code, but there is one overarching quality
> that leads to all of them. Clean code always
> looks like it was written by someone who cares.
> There is nothing obvious that you can do to
> make it better. All of those things were thought
> about by the code’s author, and if you try to
> imagine improvements, you’re led back to
> where you are, sitting in appreciation of the
> code someone left for you—code left by some-
> one who cares deeply about the craft
 - Michael Feathers

 You know you are working on clean code when each
routine you read turns out to be pretty much what
you expected. You can call it beautiful code when
the code also makes it look like the language was
made for the problem.
 - Ward Cunningham




# But I am and researcher/scientist and I just need it done quickly

## Guidelines

Most of the rules here are named by the same rules as they appear in the 
Clean Code book to avoid introducing unexpected terminology.

However, the phrasing and examples are my own. There is some
extra stuff that's not in the book too.

Finally, I didn't include every rule that there in the book (read the 
book for that), but I am emphasizing the smells that annoy me
the most.

### Follow recommended style-guide

### Intention-revealing names

### Use Domain Language

### Pick one word per concept

### Make functions small (but not too small)

### Use descriptive names for functions

### Avoid functions with three or more arguments

### Avoid side-effect (prefer functional paradigm)

### Use exceptions instead of error codes

### Avoid comments - rewrite code to make it clear

### Law of Demeter

### Active Record is not a domain object

### Don't pass null

### Flag arguments should be avoided

### Prefer polymorphism to if/else

### Replace magic numbers with constants

### Don't mix levels of abstraction in the same function

### Use unambigious names

### Avoid using general data structures to carry domain information

### Use early returns

## The boy scout rule 

# Outro