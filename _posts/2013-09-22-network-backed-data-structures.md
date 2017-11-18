---
layout: post
title: Network backed data structures
date: '2013-09-22T09:42:00.002-07:00'
author: Tadas Šubonis
tags:
- data structures
- network
- software design
- design patterns
- oop
modified_time: '2013-09-22T10:37:52.441-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-6725400518235815492
blogger_orig_url: http://dev.tasubo.com/2013/09/network-backed-data-structures.html
---
For some time I have been thinking about game development. Particularly 
in multiplayer HTML5 game development. Why? Because it's interesting :D.  

One problem that I ran into while doing my mind experiments was how
 to exchange data effectively (in regards of API and actual performance) over the network for game world state sharing. 
 The actual thing I would like to do would be to hide network implementation 
 details from API user and expose my data structures as
  POO (Plain Old Objects). I am partially inspired for this approach 
  after seeing [ObservableList](http://docs.oracle.com/javafx/2/api/javafx/collections/ObservableList.html) in JavaFX implementation.  

More fine grained requirements. Lets do that as Scrum 
stories so my reasoning would be a little bit more clear:  

*   As a developer, I would like to have hidden network details, so it would be easier to use in code
*   As as user and developer, I would like to exchange data structure deltas (modifications) only so I would have better performance
*   As a developer, I would like to be able to listen for data changes on my data structure
*   As a user and developer, I would like to be able to recover out-of-sync data structures so game wouldn't diverge in different paths
*   As a developer, I would like to be able to use familiar data structures such as Lists, Sets and etc., so it would be easier to develop it.

Currently it's only idea of a library that I would like to have so probably 
sometime in the future I am going to implement it. If anyone, 
by any chance knows something similar implemented I would really 
appreciate pointing me there :). Myself I was hoping to do that in [Dart language](https://www.dartlang.org/).

One of the bigger problems, that I see is that probably there 
will be need for some kind of decent serialization of deltas for developer 
defined objects such as GameWorld or Player that aren't general data structures 
such as List or similar. The problematic part is that you can't change implementation
 of object as in List case where you can just swap something entirely different with 
 same interface. Here I would need to implement some kind of smart [proxying](http://en.wikipedia.org/wiki/Proxy_pattern).

Another interesting problem is lag compensation if we 
are talking about real time shooters or something similar. For example, 
AFAIK, some multiplayer racing games or shooters would guess your peer 
location before it gets actual position information from another player by calculating it's 
velocity and current time and would extrapolate it from 
hat. And if there is some misalignment it would just gradually 
(quite fast but user shouldn't notice it) change current variable state to confirmed one. 
I imagine this wouldn't be so simple implement if we intend to 
hide those networking details.

  
Third thing that bothers me, is how do to handle 
multiple concurrent updates in your structure? What if one peer has out 
of date copy and updates it? Gut feeling tells me that I should take a 
look how NoSQL databases handles distributed updates 
(see [Vector clocks](http://en.wikipedia.org/wiki/Vector_clock) 
and [here](http://architects.dzone.com/articles/introduction-nosql-patterns) 
and [here](http://martinfowler.com/articles/nosqlKeyPoints.html)) and eventual consistency.  



Anyway, this idea looks promising and could be used in lot's of different applications such as real time editors, 
chat applications and etc. Hope I'll find some time to dedicate myself to it :).