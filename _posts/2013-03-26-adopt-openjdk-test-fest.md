---
layout: post
title: Adopt OpenJDK test fest
date: '2013-03-26T10:40:00.003-07:00'
author: Tadas Šubonis
tags:
- java
- adoptopenjdk
- community
- openjdk
modified_time: '2013-03-30T10:28:18.446-07:00'
thumbnail: http://4.bp.blogspot.com/-viGNAEgRiPA/UVHdHVB-sbI/AAAAAAAAJ00/F9Y58Nm5L-I/s72-c/IMG_20130323_123354.jpg
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-8448405701821445812
blogger_orig_url: http://dev.tasubo.com/2013/03/adopt-openjdk-test-fest.html
---
  

It looks like I am catching up habit writing about tech events or talks... and probably that's OK since it is still related to software development :)

This time I've attended [OpenJDK Test Fest](http://www.meetup.com/Londonjavacommunity/events/107500552/) organized by London Java Community in cooperation with IBM and Oracle. Later one provided place and lunch so without its help it would have been definitely harder to make it happen. That is very nice move from Oracle and overall I think that this is really beneficial and healthy for Java.

I certainly did like intention to make [OpenJDK](http://openjdk.java.net/) accessible more to everyone by involving community a little bit more. It definely helps to promote OpenJDK as an open platform since the last lawsuit against Google it started lacking in that regard.

Test fest started with an introduction to current test situation in JDK and how do we make tests actually run. The tool used to do that is jtreg. It runs plain Java files as tests, shell tests and testng ones. This tool predates junit and other frameworks and it is still used today. There are a few thing to know about it before you are able to write tests on your own but apart that it is mostly straightforward.

Regarding tests themselves, initial it looked for me that situation is quite good since guys maintaining OpenJDK showed that they have quite a lot of tests (over 4000 files that have multiple tests), but later other problems became apparent. It was shown to us that quite a few tests are actually shell tests and need to be rewritten to be more maintainable. Furthermore, because the project's code base is quite old and lots of tests are just execution of Java files that check return status. And due to same reasons testing framework usage (such an TestNG and JUnit) isn't widespread.

Also, while some parts are covered fairly well, some don't have any at all. The case was made with JDBC, JNDI and other parts. Later we were a little bit more relieved to hear that Oracle and other vendors do have tests for those parts but they are just unable to open source them.

During the test fest we all had the chance to improve that situation even if just a little. I took my chances with one of the easiest things probably - there was a problematic concurrency test that wasn't very well written and wasn't working correctly under certain conditions. What amazed was the dreadful readability of the test. If not the title of the class and JavaDoc in actual API I wouldn't have understood what it was supposed to test there. I think I am going to write separate post about basics how to write readable and maintainable tests.

Other thing that should be taken care of is shortage of libraries/frameworks to choose from when writing tests. I can see that if you are using TestNG, it is better to leave JUnit, but it is quite inconvenient to when you don't have access to Hamcrest and Mockito. As +Jose Llarena pointed out, it would be quite hard to attract talent that actually knows how to write quality tests when you strip them of tools that are regarded as must have these days. Although I can see why we would be reluctant to use Mockito to test Java itself - code generation and other bytecode magic may tamper with the things that we actually want to test. It may not be the best fit to test core or low level Java language but it should be able to find its use in Java API testing.


[![](http://4.bp.blogspot.com/-viGNAEgRiPA/UVHdHVB-sbI/AAAAAAAAJ00/F9Y58Nm5L-I/s1600/IMG_20130323_123354.jpg)](http://4.bp.blogspot.com/-viGNAEgRiPA/UVHdHVB-sbI/AAAAAAAAJ00/F9Y58Nm5L-I/s1600/IMG_20130323_123354.jpg)

Test festers :)

Overall the test fest was great event and it is nice to see increasing involvement of the community. Waiting for another one! It's kinda nice to know that the things you are doing will help lots and lots of developers :).

Please let me know if I did forget to mention something important.  

UPDATE: Maybe I haven't emphasized enough, but if you are wondering whether you should get involved with OpenJDK you should definitely do that since there is lots of things to do, really helpful community and it a great chance to learn a lot. For more info see [introduction](http://java.net/projects/adoptopenjdk/pages/AdoptOpenJDK#Introduction).