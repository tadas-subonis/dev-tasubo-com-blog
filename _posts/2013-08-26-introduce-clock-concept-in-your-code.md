---
layout: post
title: Introduce clock concept in your code
date: '2013-08-26T06:54:00.000-07:00'
author: Tadas Šubonis
tags:
- unit tests
- test driven development
- software craftmanship
- design
- testing
modified_time: '2013-08-26T06:54:29.013-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-1988598744297701922
blogger_orig_url: http://dev.tasubo.com/2013/08/introduce-clock-concept-in-your-code.html
---

**Getting current time in the system** . If you have been writing unit tests or practising TDD, 
you may have stumbled with this problem: how do you mock "Date" constructor? Problem in detail: 
lots of people use "new Date()" to get current time in the system and when they start 
writing tests they can't prepare consistent unchanging testing environment since during each call it will 
return current time instead of the time that you "want".  

**Missing concepts.** If testing becomes hard (excluding UI testing - it's hard by default but this is another topic),
 it usually means that you have missing concept in your code. Let's think like this: if I am getting current
  time in my system how should I get it? Does "new Date()" tell me anything? Not really. 
  I need some kind of provider to do that... 
  and how do we call current time provider? Clock.  

**Code.** So instead of using constructor directly, create Clock to do that:  

{% highlight java %}
class Clock {
    public Date getNow() {
        return new Date();
    }
}
{% endhighlight %}

Now mocking becomes easy:  

{% highlight java %}
class MagicTest {
    @Test
    public void some_test() {
        Clock clock = mock(Clock.class);
        MyComponent component = prepareComponent();

        component.setClock(clock);

        when(clock.getNow()).thenReturn(mySpecificDate());

        [...]
    }

    private Date mySpecificDate() {
        return new Date(10025456454L);
    }

}
{% endhighlight %}

What would we do, if we would like to get time in different time zone for some specific component? Just create clock for that time zone:  

{% highlight java %}
TimeZone losAngeles = TimeZone.getTimeZone("America/Los_Angeles");
Clock losAngelesClock = Clock.forTimezone(losAngeles);
Date losAngelesCurrentTime = losAngelesClock.getNow();
[...]
{% endhighlight %}

Done! We can see that by introducing relevant concept in our code we made our life a lot easier. This holds true for various other cases (i.e. using "new Thread()")  

**Java 8.** In the near future you won't even need to do this :). New 
[JSR-310](http://jcp.org/en/jsr/detail?id=310) "Date and Time API" introduces  
[Clock](http://download.java.net/jdk8/docs/api/java/time/Clock.html) and other neat things for you.  
Everything will be available in standard Java package. Not sure about other languages 
since it has been a while since I used them but I am sure you can have something similar there.  

**For conclusion.** Initially I was exposed to this "trick" while reading 
[Growing Object-Oriented Software, Guided by Tests](http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627)
 (really good book and I recommend you to read it). 
Lesson here is that you have pay attention how code "talks" 
with you. Maybe you have something missing there that makes your life a 
lot harder than it should be. Also, this is great example how tests can
 help you discover those concepts :).