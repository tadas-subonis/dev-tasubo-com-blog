---
layout: post
title: What is Domain Driven Design about?
date: '2013-06-21T06:30:00.000-07:00'
author: Tadas Šubonis
tags:
- java
- software design
- project management
- domain driven design
- oop
modified_time: '2013-06-21T06:30:42.607-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-6518958404615891259
blogger_orig_url: http://dev.tasubo.com/2013/06/what-is-domain-driven-design-about.html
---

A while ago I presented lightning talk at LJC about Domain Driven Design. It was interesting experience actually and I think I enjoyed it. Later I was asked by [+Edward Yue Shung Wong](https://plus.google.com/111189347667024503360) "what is this [Domain Driven Design](http://en.wikipedia.org/wiki/Domain-driven_design) basically about". I thought that it is interesting topic and worth writing a blog post about it :).  

To say that short, Domain Driven Design is a process which maps and documents your business into your target programming language that can be understood by computers.  

Regular design achieves almost the same - we have an application, that is supposed to help with our business processes. What's so different from regular design then? Regular code usually contains artifacts that aren't part of business and distracts our (developers) knowledge about it. It's various kinds of database specific mappings, transport protocols, logging and etc.  

But how do you make applications without those things? The trick is that you don't - you will be using same technologies but this time you are making the difference between them explicit. You don't keep technology specific and business artifacts in one place.  

What does this give to us? First and most important thing - code becomes description of your business. Reading it you get lots of information about your businesses domain. The most important result of this is that developers start becoming aware of domain specifics and this can result in so called insights - you can discover things that would help business achieve much greater things with just a few changes in business process, methodologies or systems.  

Of course you just don't start with application that is based on domain design - to get there you must have help of existing domain experts. Software developers and domain experts become one team that shares knowledge and the result of that is your application.  

Secondly, would be that when you have application that has separated domain model in it, it isn't hard to keep up with changing technologies. Usually your process doesn't change when new technology appears but still in most of the cases lots of applications gets rewritten just to utilize that additional value that new technology could bring us. This in most cases happens due to intermingled business and technology specific code - when you would like to get rid of old technology you suddenly realize that it isn't straightforward process and requires a lot of effort.  

Thirdly, it is that software developers start writing code in consistent and agreed way. It's is a lot easier to reason about and use it. Often you cannot get your system in invalid state because code to do that doesn't exist there. Concepts aren't duplicated in multiple places and they are well defined.  

Achieving decent pureness of domain code in regard to technical cruft is really hard and we usually have to utilize lots of "tricks" to pull it of: [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection), [aspect oriented programming (AOP)](http://en.wikipedia.org/wiki/Aspect-oriented_programming) and [factories](http://en.wikipedia.org/wiki/Abstract_factory_pattern) to name a few.  

These three things were first that came into my head at the time of writing. I still consider myself apprentice in DDD so maybe in the future I'll be thinking differently :). Also, I am about to finish writing how Transactional Scripts, thing that developers are most used to while writing business code, compare to pure DDD approach.