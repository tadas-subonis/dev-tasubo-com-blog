---
layout: post
title: Tips for tasks on Codility
date: '2012-09-30T02:46:00.003-07:00'
author: Tadas Šubonis
tags:
- java
- algorithms
- test
- codility
modified_time: '2012-12-26T16:45:00.194-08:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-8974767771658220584
blogger_orig_url: http://dev.tasubo.com/2012/09/tips-for-tasks-on-codility.html
---

Recently I was interviewed at the very first stage with [codility](http://codility.com/).
 It's a tool used to measure programming capabilities of given specialist
  giving usually three selected tasks which involve creating code that 
  meets running time and space requirements in [Big O](http://en.wikipedia.org/wiki/Big_O_notation) 
  notation within short amount of time ( I believe there is given 30min per task).

Tasks can be quite challenging even for developers with decent amount of 
experience and will be definitely hard for novices. When I was done 
with my Codility stage I thought that I can provide some tips that would help others.

 Here are some tips, that should help codility tests:

**Do the [demo](http://codility.com/demo/take-sample-test/) on codility page**

This will help you to get used to the platform and will show you what it is like to code under time constrains (unless the task will be way to easy to you). Try to get perfect score :). It may won't be possible after the first try, but after multiple attempts it is definitely possible.

**Refresh algorithms class knowledge**

You should feel comfortable using Big O notation (you should understand that O(n) + O(n) = O(n) ). Also, you should remember how to code (fast) those simple algorithms such as [Merge](http://en.wikipedia.org/wiki/Merge_sort) or [Bubble](http://en.wikipedia.org/wiki/Bubble_sort) sort. Recall (learn) how to use hash tables and hash functions properly. They will surely come handy.

**Master your language**

This should go without saying. You should know how to use standard libraries from your language so you won't be reinventing wheel when you are trying to code some king of sort.

**Familiarize with unit testing**

You can use unit tests on codility so you should know how to test code properly - if you have written unit tests before you should be fine. Have at least two cases where code would return true or false (depends on the task, but there should usually be situations when you need to return some kind of array or number and situation when you need to return -1 - false).

**Get calm workplace**

Take test where surrounding are quiet and nothing will disturb you. Turn of the mobile phone and other unneeded stuff. The same goes to skype, mail notifications and other distractions.

**Pay attention to task**

Do not rush while reading task. Pay attention and concentrate on it. Make sure you understand it. Nothing could be worse when you misunderstood given task.

**Identify problem**

I have taken this section from the book (["Algorithms for Interviews"](http://www.amazon.com/Algorithms-For-Interviews-Adnan-Aziz/dp/1453792996) see below) as there is good overview how problems should be solved. You should identify what kind of problem you have and is there some patterns that you could use to come up with solution. Here is the list as is given in the book:

  

1.  Divide-and-Conquer: Can you divide the problem into two or more smaller independent subproblems and solve the original problem using solutions to the subproblems?
2.  Recursion, dynamic programming: If you have access to solutions for smaller instances of a given problem, can you easily construct a solution to the problem?
3.  Case analysis: Can you split the input/execution into number of cases and solve each case in isolation?
4.  Generalization: Is there a problem that subsumes your problem and is easier to solve?
5.  Data-structures: Is there a data-structure that directly maps to the given problem?
6.  Iterative refinement: Most problems can be solved using brute-force approach. Can you formalize such a solution and improve upon it.
7.  Small examples: Can you find a solution to small concrete instances of the problem and then build a solution that can be generalized to arbitrary instances?
8.  Reduction: Can you use a problem with a known solution as a subroutine?
9.  Graph modeling: Can you describe your problem using a graph and solve it using an existing algorithm?
10.  Write an equation: Can you express relationships in your problem in the form of equations (or inequalities)?
11.  Auxiliary elements: Can you add some new element to your problem to get closer to a solution?
12.  Variation: Can you solve a slightly different problem and map its solution to your problem?
13.  Parallelism: Can you decompose your problem into subproblems that  can be solved independently on different machines?
14.  Caching: Can you store some of your computation and look it up later to save work?
15.  Symmetry: Is there symmetry in the input space or solution space that can be exploited?

To look into these problems in detail please [see the book](http://www.amazon.com/Algorithms-For-Interviews-Adnan-Aziz/dp/1453792996) that I mentioned.



**Think up initial solution**

Try to come up with solution that could satisfy given O constrains. If you can't do that, try to come up with solution that could work and return correct results.

**Write main body first**

By my intuition you should write main algorithm body first. I mean, for example, that you should write code as there is no start of array and no end. Just some kind of working prototype. After you have done that and code looks like working do the edge cases. Edge cases are correct handling of input start and end.

**Test edge cases**

Pay lots of attention to edge cases in your algorithm. Firstly, You should test (test I mean provide testing data inside codility) how your algorithm behaves when input numbers are really large. There could be problems if you read input as int and you are given number that is larger than int. Also, take care when doing arithmetic because two numbers that are smaller than max integer could result in error if you try to add them up and their result is larger than max integer. Secondly, you should test (again, I mean provide test data) case where some kind of stuff that you are searching (depends on task) is at the beginning of input or at the end of input. Be ready for all kind of input x).

**Use IDE**

I bet codility would like us to use their Web IDE as they can see then how much we pressed test code button or how our code evolved over time. This can show them what kind of mind flow we had or similar stuff. But there is one big problem with their IDE - it's lag. You have to wait for several seconds ( I guess it heavily depends on their servers load) while your test cases execute and returns results. Also, they don't have  autocompletion :). I would like to suggest to use IDE (or editor) that you are comfortable with on your local machine. Prepare correct environment before hand (Python, Java etc.. versions, correct compilers). Also don't forget to prepare testing system that could easily handle codility-like data inputs. By doing so you should be able to save enormous amounts of time as code on local machine usually executes instantly.

  
That's about all that I could think of. Not surprisingly, I doubt that this is complete guide :). 

**Additional resources**

There are a few good resource that could be used to ramp up your codility preparedness

*   A. Aziz, A. Prakash "Algorithms for Interviews" - great book that is designed to help specifically during interviews.
*   S. Skiena's "The Algorithm Design Manual" - You can read this book in your free time as you will surely learn a lot. I think that applies to experienced programmers as well.
*   Online algorithms class. Now there are online classes that could help you to remember some important stuff. Please check [Udacity](http://www.udacity.com/) and [Coursera](https://www.coursera.org/).
