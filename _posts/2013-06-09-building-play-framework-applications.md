---
layout: post
title: Building Play Framework applications using drone.io
date: '2013-06-09T05:41:00.000-07:00'
author: Tadas Šubonis
tags:
- java
- drone.io
- play framework
- continuous integration
modified_time: '2013-06-09T05:44:20.342-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-6612301903292581230
blogger_orig_url: http://dev.tasubo.com/2013/06/building-play-framework-applications.html
---

Just recently I was in the need to set up continuous integration for OSS project that I am working on right
 now ([DDocumentor](https://github.com/Knifemonkey/DDocumentor)) and I 
 found that that [drone.io](http://drone.io/) others great free service 
 for open source projects.  

I created a few projects and everything went fluently since 
I was using Maven in those other projects but that wasn't the case 
with DDocumentor - in this project we are using [Play Framework](http://www.playframework.com/) which handles 
dependency pulling and building. But as it turns out, solution is pretty simple - use these steps for your build script:  

{% highlight java %}
wget -q http://downloads.typesafe.com/play/${PLAY_VERSION}/play-${PLAY_VERSION}.zip
unzip -q play-${PLAY_VERSION}.zip

play-${PLAY_VERSION}/play clean-all
play-${PLAY_VERSION}/play compile
play-${PLAY_VERSION}/play test
{% endhighlight %}

And add this (or whichever version you are using) to Environment variables section:  

{% highlight java %}
PLAY_VERSION=2.1.1
{% endhighlight %}

Now you are able to build and test Play apps on drone.io. Thanks goes to drone.io for providing such a great service :).