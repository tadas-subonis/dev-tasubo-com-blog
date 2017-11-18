---
layout: post
title: Object Oriented Programming, part 2 - Communication
date: '2012-12-26T16:35:00.002-08:00'
author: Tadas Šubonis
tags:
- java
- design
- object oriented programming
- oop
modified_time: '2012-12-28T11:35:51.938-08:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-7030945827629485817
blogger_orig_url: http://dev.tasubo.com/2012/12/object-oriented-programming-part-2.html
---
  

As you remember in [previous part](http://dev.tasubo.com/2012/12/object-oriented-programming-part-1-scope.html) we talked about some OOP technical stuff that helps us make better software. Now lets talk about other Object Oriented Programming side that does the same. I think it is correct to call this part "communication of code". OOP enables us to use more convenient ways to express our ideas in code. Also, I believe that it is hard to define a way how to do "communication" correctly, but it is easy to tell when it's wrong. I am going to try to provide a few "wrong" examples of OOP usage and how we should avoid those pitfalls.




The most straightforward way that OOP helps us in communication is that we can model our application according to our understanding of the real world. Using OOP you can easily describe entities and things that you can do with them. Here I am going to stick with classical example of an order. Lets say you have an Order in your system that was placed by Customer. This can be handled by introducing {Order} class which has reference to your {Customer} to show to whom it belongs to. Also, lets add actual {Item}s to the {Order}. That would look like this:

{% highlight java %}
        class Customer {
            String name;
        }

        class Item {
            String sku;
            BigDecimal price;
        }

        class Order {
            Item[] items;
            String orderId;
            Customer customer;

            void addItem(Item item) {
            }
        }
{% endhighlight %}

Simple classical example of OOP. But we should emphasize the important thing that has happened here that other person which would be reading source code would notice that system has some kind of ordering capability for its users. And that wouldn't be some kind of text or numbers - each class would communicate its purpose by its name and its methods are going to tell what it can do (at least after we added some methods to it).

Now lets say we want to add additional functionality such as getting total value of order. We could do something like this:

{% highlight java %}
        class OrderManager {
            double getTotalPrice(Order order) {
                //...
                for (Item item : order.getItems()) {
                    //...
                }
                return num;
            }
        }
{% endhighlight %}

Is there anything wrong with that? A lot :). We introduced a class, that takes responsibility that {Order} class should have handled by itself. We shouldn't ask {OrderManager} to return {Order} price because we don't care about any {OrderManager}. We care about {Order} and its price and {Order} itself should tell that. This isn't far from plain procedural programming because your are taking some values and calculating result depending on them instead of asking someone just to give it.  This would have been a much better approach:

{% highlight java %}
        class Order {
            Item[] items;
            String orderId;
            Customer customer;

            void addItem(Item item) {
            }

            double getTotalPrice() {
                //...
                for (Item item : items) {
                    //...
                }
                return num;
            }
        }
{% endhighlight %}

Why you may ask? Because code now is simpler and more intuitive. We ditched unneeded Order parameter that has been passed around and now we can access stuff that belongs to us (items). Even more, this {OrderManager} may be confusing because in our  hypothetical system you would see that each order in your GUI has that "total price" but yet when you open {Order} class that part is missing. You would be forced to search for that functionality across entire project which may not be most pleasant activity if your project has thousands of classes.

Now lets think about situation where you would need to cache price of an order because counting all items each time isn't quite effective. Using {OrderManager} would look like:

{% highlight java %}
        class OrderManager {
            Map<Order, Double> prices;

            double getTotalPrice(Order order) {
                if (prices.containsKey(order)) {
                    return prices.get(order);
                }
                for (Item item : order.getItems()) {
                    //...
                }
                prices.put(order, num);
                return num;
            }
        }
{% endhighlight %}

Now things are starting to get really ugly. This added complexity of managing state for multiple objects by a single entity. But that isn't all. What happens when you add new item to an order? How do you update {OrderManager} to know about new info? Are you going to call {OrderManager.evict(Order)} whenever you are making changes to orders? Or are you going to add {OrderManager} dependency to {Order} to update that calculated price after each new item addition? All of these approaches introduce unneeded complexity that could have been avoided if we would have just made that calculation reside where it belongs ({Order}). Also, this could easily lead to many bugs because forgetting to call some specific method after some specific action would mean that you program is in wrong state.

{% highlight java %}
        class Order {
            Item[] items;
            String orderId;
            Customer customer;
            Double totalPrice;

            void addItem(Item item) {
                //...
                totalPrice = null;
            }

            double getTotalPrice() {
                if (totalPrice != null) {
                    return totalPrice;
                }
                //...
                for (Item item : items) {
                    //...
                }

                totalPrice = num;
                return num;
            }
        }
{% endhighlight %}

I hope the code above looks simpler to you as well and I hope I managed to show that by not following OOP style you lose clarity of your code and increase effort to maintain your code. Actually example above isn't quite good as I would like to be. To make that "cleaner" even more, I would apply [Decorator](http://en.wikipedia.org/wiki/Decorator_pattern) pattern to do caching logic and I would hide it under the [Factory](http://www.oodesign.com/factory-pattern.html).

One more pitfall about "Doers" (this is how I call redundant classes that take responsibilities from those classes where that logic should belong) is worth separate mentioning.  [Transaction Scripts](http://martinfowler.com/eaaCatalog/transactionScript.html) is a common way of organizing logic these days (is it me or I am really seeing them in almost every project?)  . I even heard about situation from my colleague where any business logic from Domain Entity classes was stripped out intentionally by an architect and put to transaction scripts. I would say this would be perfect example of  <span style="line-height: 17.33333396911621px; text-indent: 0pt;">[Anaemic](http://en.wikipedia.org/wiki/Anemic_domain_model)[ Domain Model](http://en.wikipedia.org/wiki/Anemic_domain_model) (or [here](http://martinfowler.com/bliki/AnemicDomainModel.html)). An example of transaction script would be something like this:  

{% highlight java %}
        String orderId = request.getParam("id");
        String sku = request.getParam("sku");
        Order order = orderDao.findOneById(orderId);
        Item item = itemDao.findOneBySku(sku);

        order.addItem(item);

        double total = 0.0;
        for (Item item : order.getItems()) {
            total += item.getPrice();
        }

        order.setTotalPrice(total);
        order.setLastUpdated(new Date());
{% endhighlight %}

It's easy to see that lot's of logic could be moved to {Order} class as it is closely related to our {OrderManager} example. These transaction scripts often end up as "Services" (which have nothing to as ones as are defined in [DDD](http://en.wikipedia.org/wiki/Domain-driven_design)), Controllers (as in [MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)) or other various "actions" in system. The problem with them is that business logic gets dispersed around many unrelated classes but that logic describes a business processes that  actually  are closely related to each other. This makes hard to extend code and track all places which may need update. Reading code fails you inform about ways how system works. Fowler in his [PoEAA](http://www.amazon.co.uk/Enterprise-Application-Architecture-Addison-Wesley-Signature/dp/0321127420) book argues that transaction scripts are chosen as an easy way to start describing application logic compared to Domain Driven Design that requires more initial effort, but transaction scripts tend to get harder to maintain in  exponential rate as system size increases.

So how do you design "good" OOP programs/systems? It's hard to tell (sorry for repeating myself x) ), but at least it is easy to know when you are doing it wrong. Also, there are guidelines to help you to avoid similar pitfalls. To name a few: [Law of Demeter](http://c2.com/cgi/wiki?LawOfDemeter), [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)), [Design Patterns](http://en.wikipedia.org/wiki/Design_pattern). I am not going to talk about these in detail right now, but I hope I will be able to cover them in upcoming parts.

First thing that needs mentioning is that you should communicate with others to clearly understand what code should do. This usually involves talking a lot with domain specialist to whom you are making that application. Having good insight about domain and what software should do will help you to design application that will follow good OOP style. A great sign would be if you would have shown your source code to domain specialist who isn't programmer, he/she would understand what does the code do. If there are any classes that make you say, that they are regarding some "programming stuff", I would say your design has room for improvement.  

Second thing that I would like you to pay attention to would be various "Manager", "Util", "Helper" or other "Doer" classes. This usually means that there are methods that take some kind of arguments, apply specific logic and return result. Usually code that resides in there could be moved to appropriate classes. Applying [move method](http://sourcemaking.com/refactoring/move-method) or [convert procedural design to objects](http://sourcemaking.com/refactoring/convert-procedural-design-to-objects) refactoring would be the best choice here. Though there are places where you must use those Util and Helper classes - these should only be used when you must simplify interface or extend it with the code you don't have control over. For example, your current framework or library.

Next thing would be to try to keep your business logic separate from infrastructure and presentation. What is  infrastructure you may ask? I would define it as the layer that makes our business logic work. This would include database to store our entities, ORM framework, messaging service, mailing service, etc. Ideally I would keep domain logic, infrastructure and presentation layers in separate projects (modules) and preferably I would have package structure something like this at the very root level:  

{% highlight java %}
        //domain
        package com.company.bigproject.domain;
        //or just
        package com.company.bigproject;
        //[...]

        //presentation
        package com.company.bigproject.web;
        //[...]

        //infrastructure (system)
        package com.company.bigproject.sys;
        //[...]
{% endhighlight %}

  
This may be hard  to achieve in [conventional layered architecture](http://en.wikipedia.org/wiki/Multitier_architecture#Three-tier_architecture) so I suggest reading about [Onion architecture](http://jeffreypalermo.com/blog/the-onion-architecture-part-1/) and about making best of [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection). I hope to write about this in the future, too. Applying such segregation will help to extract essential domain information that drives your application. When you are able to clearly see the business logic and its intent, making a change to it becomes a lot easier.

The last topic that I would like to touch is inheritance. One should not abuse it because you if you do, you are going to be punished by endless maintenance hours x). [This article](http://lostechies.com/chadmyers/2010/02/13/composition-versus-inheritance/) explains why you should prefer composition over inheritance. So what is abuse then? I would say if your inheritance tree goes deeper than one level you are doing something wrong. There are perfect cases of inheritance usage such as [Null Object](http://www.oodesign.com/null-object-pattern.html) pattern (IMO this pattern is way too underused :( ) or object which requires special case handling. In both cases details of subclasses should be hidden with  polymorphism by factories or repositories. For the sake of completeness lets see an example:  


{% highlight java %}
        //regular customer
        class Customer {
            private String name;
            String getName() {
                return name;
            }
            boolean canCancelDispatchedOrder() {
                return false;
            }
        }

        //In case valid user isn't logged in
        class GuestCustomer extends Customer{
            @Override
            String getName() {
                return "Anonymous";
            }
        }

        //Customer for special order cancelling to use by support team
        class SuperUserCustomer extends Customer {
            @Override
            boolean canCancelDispatchedOrder() {
                return true;
            }
        }

        //hides our inheritance tree complexity and helps to construct appropriate
        //object as needed
        class CustomerFactory {
            Customer getCustomer(Context context){
                //[...]
                return customer;
            }
        }
{% endhighlight %}

  
If you are in position where big inheritance structure has become a big burden you should read about [ways teasing it apart](http://sourcemaking.com/refactoring/tease-apart-inheritance).  



Although making good OOP may sound easy here, in practice it's often difficult to achieve this because systems tend to "grow out of control" and there is need of sophisticated knowledge and experience to tame this. Perfect read regarding this matter would be [Domain Driven Design](http://www.amazon.co.uk/Domain-driven-Design-Tackling-Complexity-Software/dp/0321125215) book by Eric Evans. A few things to mention why this does happen would be the lack of OOP experience, intrusive frameworks and libraries, lack of refactoring when software evolves.

In the next part of this series I am probably going to write in detail about SOLID and other principles that help us to make better OOP software.



