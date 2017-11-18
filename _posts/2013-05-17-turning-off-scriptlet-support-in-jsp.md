---
layout: post
title: Turning off scriptlet support in JSP
date: '2013-05-17T15:47:00.000-07:00'
author: Tadas Šubonis
tags:
- java
- JSP
- templates
modified_time: '2013-05-17T15:47:03.762-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-8186061888236247214
blogger_orig_url: http://dev.tasubo.com/2013/05/turning-off-scriptlet-support-in-jsp.html
---

As I stated a little bit earlier I am not really fond of writing stuff about some specific 
technical topics but probably I'll start doing exemptions. In the end, it is the technology 
that makes our software work :).

Just recently I was talking with
 [+Mantas Aleknavičius](http://plus.google.com/107572716393707191258) and saying
 that [JSP](http://en.wikipedia.org/wiki/JSP) is one of the greatest templating 
 systems that I know of but it has that really annoying thing - scriptlets. 
 Apparently you can turn off them and I wasn't aware of this until he showed me 
 how actually to do that. Just put this in your web.xml:

{% highlight xml %}
    <jsp-config>
        <jsp-property-group>
            <url-pattern>*.jsp</url-pattern>
            <scripting-invalid>true</scripting-invalid>
        </jsp-property-group>
    </jsp-config>
{% endhighlight %}	

That should do it - no more in-line Java code. Though I am 
a little bit surprised that some of us hasn't learned of our past mistakes and are reintroducing 
inlined code in templates - I am talking here about [Play Framework](http://www.playframework.com/) 
[templates](http://www.playframework.com/documentation/2.1.1/JavaTemplates).