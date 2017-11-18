---
layout: post
title: Why do I use Java
date: '2012-09-05T13:23:00.001-07:00'
author: Tadas Šubonis
tags:
- ruby
- java
- tools
- compilation
- security
- php
- aop
- jit
modified_time: '2012-12-26T16:45:38.238-08:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-1881525833276194659
blogger_orig_url: http://dev.tasubo.com/2012/09/why-do-i-use-java.html
---
   I will begin my dev blog on Google platform by post why I am using Java.

I have been using Java for quite some time and I think language is truly productive and has many capabilities. I have been
   using some  other languages but this is main one witch I use to do the heavy lifting. Additionally I have been using
   Python, C++, Ruby, Matlab and PHP. C++ I have been using from my early days and I can say that it is quote verbose language.
   It is powerful tool but it lacks expressiveness of solution to given problem and is really hard to master.

Later I adopted PHP. This one tool I have been using for quite a long time but as my experience with PHP grew so did my
   [frustration with language](http://me.veekun.com/blog/2012/04/09/php-a-fractal-of-bad-design/). I became annoyed
   by constant bugs coming from VM, inconsistent naming system, flawed OOP design, interpreter updates that could break already
   running systems and so on.... The last nail was when I had to use [PHPDoc functionality to get at least somewhat usable auto-completion](http://www.edmondscommerce.co.uk/netbeans/netbeans-autocomplete-on-class-properties-using-phpdoc/)
   in IDE.



When I got enough of PHP I started evaluating other tools that could take its place. Of course I have heard of Java before
   but now I took a more serious approach thinking how could I use Java in web development. After some Java evaluation, I
   was really amazed how it was doing in my tasks. I will try to list benefits that I liked here:
   
* **Syntax** I really like C type syntax. It is actually clean and easy to read, no retarded "begin" and "end".

* **Speed** Java is a lot faster than most of interpreted languages (some say that Java is compiled and not interpreted
      but actually that isn't really true - Java is compiled but also it is (bytecode) interpreted in its JVM). Maybe Java isn't
      fast as code compiled to machine code (C++ or [D](http://en.wikipedia.org/wiki/D_(programming_language))),
      but its [JIT compiler](http://en.wikipedia.org/wiki/Just-in-time_compilation) is doing really well. Often you
      can get speeds as with [C++](http://shootout.alioth.debian.org/u64q/java.php) and usually Java is faster than
      any other interpreted language such as [Ruby](http://shootout.alioth.debian.org/u64q/benchmark.php?test=all&amp;lang=java&amp;lang2=yarv) or
      [PHP](http://shootout.alioth.debian.org/u64q/benchmark.php?test=all&amp;lang=java&amp;lang2=php). I would like
      to note that Python is [really fast](http://shootout.alioth.debian.org/u64q/benchmark.php?test=all&amp;lang=java&amp;lang2=python3)		
      compared to other interpreted languages in Java context.

* **Compilation and Static Strong Typing**  Some will argue that [compilation](http://en.wikipedia.org/wiki/Compiler)			
    and [static](http://en.wikipedia.org/wiki/Type_system#Static_typing) [strong typing](http://en.wikipedia.org/wiki/Strong_typing) 
    are
      the weak spots of Java but they couldn't be further from the truth. Compilation in combination with Strong Typing helps
      you to catch A LOT OF errors even before deploying and running your solution. This is very important if you are building
      big system instead of guestbook. This isn't so obvious when you are building new system parts but it helps tremendously
      if you are modifying existing code. Unit tests could help you in this case if you don't have strong typing and compilation,
      but it is nice to have additional layer of confidence. Additionally, compilation can help you apply 
[AOP](http://en.wikipedia.org/wiki/Aspect-oriented_programming) in a non intrusive manner and almost without any of runtime performance penalty if you use [bytecode instrumentation during compilation](http://theholyjava.wordpress.com/2010/06/25/implementing-build-time-instrumentation-with-javassist/). One drawback of compilation is delayed time between writing code and testing it in server environment where usually other interpreted languages can do it instantly. Now this isn't such a big problem since we have tools as [JRebel](http://zeroturnaround.com/software/jrebel/).

* **Security.** While there was some [recent Java security breaches](http://www.securityweek.com/new-java-exploit-spotted-wild), 
it's JVM is considered to be quite safe. Out-of-bounds array access checking and other security sandbox
 features provides you more security than most other languages.

* **Tools.** One of most powerful aspects of Java is its fascinating IDEs (Eclipse, 
Netbeans, IntelliJ). With modern IDE you can refactor your code at ease: automatically generate setters and getters for 
class fields, implement interfaces, move inner classes to outer classes, rename method names from interface to all
 implementations, move classes between packages. And after all these changes you code still compiles successfully.
  Fascinating. IDEs provide many other benefits such integration with application server,
 building systems and etc.

* **Libraries.** Abundance of frameworks and libraries that saves you time in almost 
any situation. Dependency Injection frameworks ([Guice](http://code.google.com/p/google-guice/),
 [Spring](http://www.springsource.org/spring-framework)), Web frameworks ([Vaadin](https://vaadin.com/home),
  [Play](http://www.playframework.org/)) and [other](http://code.google.com/p/guava-libraries/) libraries that help
   in various fields (math, file formats and etc.) are always ready to be included in your project.

I will conclude this post by saying that 
Java isn't perfect language and shouldn't be used everywhere.
 It is a tool that has use cases where it can shine brilliantly
  and cases where it would be overkill. For example I would think 
  twice before solving [Euler](http://projecteuler.net/) problems with Java instead of Python :).