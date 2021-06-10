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

# Code Review
I get to do a lot of code reviews. I've noticed that it is quite important to lay out
some of the "rules" and "whys" for the review, so the process is productive.


## Why?
First of all, at the level that I operate (tech lead) I am responsible for the code quality
that gets shipped.

Naturally, if the change doesn't look like it's good _to me_, I usually ask for changes.

Usually, my goal isn't to have "a perfect" code-base. I would like to see code that's
 - Easy to read
 - Easy to understand
 - Easy to update

A few collolary things that follow from this:
 - the code-base should follow a standard style-guide (like PEP8)
 - it should follow the best practices (test coverage, immutability, etc)
 - variables and packages are named appropriately and have a meaning
 - no global/foreign state modifications

I find discussions about certain things that are trivial a bit redundant, like:
 
 - How should we name this?
    - Is it part of domain/ubiquitous language? if not, I do not care
 - What version of dependency should we use?
    - Any, as long as it works and doesn't conflict

In the end, I am looking to shape the code-base in a way as it would have written by me.

Why is it important to point it out? Because there are lots of good approaches to 
the same problem. If I have a different opinion about the way the code should
be written, it doesn't mean that the other approach is bad. But when there are 
no solid arguments given, let's just go with my opinion as in the end I am responsible for
the delivered quality.


There can be multiple style-guides but in the end it doesn't matter - let's just
pick one.


## 



