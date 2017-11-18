---
layout: post
title: Handling parameter validation
date: '2013-06-30T04:15:00.000-07:00'
author: Tadas Šubonis
tags:
- design
- validation
- object oriented programming
modified_time: '2013-06-30T04:21:45.593-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-8950441405396564928
blogger_orig_url: http://dev.tasubo.com/2013/06/handling-parameter-validation.html
---

 It's usual practice to validate all kind of data in software engineering. The logic behind validation is quite easy to implement but the main question probably lies with how do you do that efficiently, ensure that there are no invalid data in your calls and [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself).  

Let me suggest a way how to handle that efficiently.  

First of all you want to validate data as soon as possible
 ([fail fast](http://en.wikipedia.org/wiki/Fail-fast)and hard).
  Most common place to do that is entries in your system such as 
  [Controllers](https://en.wikipedia.org/wiki/Model%E2%80%93View%E2%80%93Controller), [Facades](http://en.wikipedia.org/wiki/Facade_pattern) 
and etc. It could look something trivial like this:  

{% highlight java %}
class Controller {
    public void doAction(Request request) {
        String myBookingId = request.getParam("bookingId");
        new BookingValidator().validateId(myBookingId);
        nextCallInApi(myBookingId);
    }
}
{% endhighlight %}

Code looks quite nice and reasonable now, but what happens if I
 am going to call nextCallInApi from another place? We can add validation check again 
 before that call or we can move our code snippet in the nextCallInApi. Actually this, won't solve our
  [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) problem again, consider this example:  

{% highlight java %}
    /*
    * Method that contains validation call
    */
    nextCallInApi(myBookingId);

    secondCall(myBookingId);
{% endhighlight %}

Now we have to do second validation in secondCall. 
The problem is evident now: we either have multiple validation calls in most of the methods or we can't
 guarantee that data we are getting is valid. So how do you handle this contradicting situation.  

Introduce [Value Objects](http://en.wikipedia.org/wiki/Value_object) or 
[DTOs](http://en.wikipedia.org/wiki/Data_transfer_object). Start using them in your 
call chain as soon as possible and don't allow them to get in invalid state. Take a look here:  

{% highlight java %}
class BookingId {
    private BookingId(String bookingId) {
        this.id = bookingId;
    }

    public static BookingId fromString(String bookingId) {
        if (doesntMatchRegex(booking))
            throw new IllegalArgumentException("Please check format");
        return new BookingId(bookingId);
    }
}
{% endhighlight %}

BookingId is immutable value object that once created cannot be changed and before creating it we ensure that it is going to hold valid data.
 This is perfect to opportunity to make use of factory method pattern:  

{% highlight java %}
    public static BookingId fromString(String bookingId) {
        if (doesntMatchRegex(booking))
            throw new IllegalArgumentException("Please check format");
        return new BookingId(bookingId);
    }
{% endhighlight %}

Now we can pass BookingId wherever we want and we can be sure that data is going to be valid. Also, we aren't 
duplicating any of the validation logic because it's being executed only in that factory method. If validation logic is 
complex, of course we can extract it into separate validation class.  

The other good thing that we achieved now is that API is more descriptive now - we explicitly say that this is 
booking id and not some other random string.  

One may think that we are going to have lot's of redundant classes by doing this because sheer number of parameters 
sometimes can be discouraging. Well, in most cases those parameters are going to be grouped under single Value Object or DTO. If you need a 
few DTOs to make one call to your API it is good sign that you are not following Single Responsibility principle.  

Consider this situation which can be encountered 
quite often these days with frameworks like [Spring MVC](http://static.springsource.org/spring/docs/3.2.x/spring-framework-reference/html/mvc.html):  

<div class="gistLoad" data-id="5894768">Loading ....</div>
{% highlight java %}
class Controller {
    public void myControllerAction(MyValueObject valueObject) {
    }
}
{% endhighlight %}

Value object is created by external means (framework) and let's say it is already in invalid state. Personally I would
 suggest limiting utilization of this approach because it's hard to control how this object is created
  and it can result in invalid state. We would end calling some kind of validation logic always before using 
  the object and that would break DRY rule. Well, we could do something like this:  

<div class="gistLoad" data-id="5894769">Loading ....</div>
{% highlight java %}
class MyValueObject {
    private String nonValidField;
    private boolean validated;

    public String getNonValidField() {
        doValidation();
        return nonValidField;
    }

    public void doValidation() {
        if (validated) return;
        //... do validation here and throw ...
    }
}
{% endhighlight %}

But I wouldn't recommend this approach because it introduces unneeded complexity that we could avoided by utilizing simple and straightforward Factories.  

Situation would be somewhat different if we would like to get back 
validation result object and return those errors to client. In this case I would
 return complex exception (read with custom fields) that contains aggregated 
 validation result and later that exception is handled and translated in proper response depending on transport used and format expected.  

To conclude, I suggest this approach - use ValueObject or DTO as early as possible
 in your chain and fail as fast as possible. Simple. Let me know how that works 
 (or doesn't work) for you or other suggestions :).