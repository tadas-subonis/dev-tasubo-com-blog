---
layout: post
title: Transactional Scripts (aka Services) and Domain Model
date: '2013-08-19T04:01:00.003-07:00'
author: Tadas Šubonis
tags:
- software design
- software craftmanship
- domain driven design
modified_time: '2013-08-19T04:35:17.344-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-8236550586804668805
blogger_orig_url: http://dev.tasubo.com/2013/08/transactional-scripts-aka-services-and.html
---

This post has been compiling in my head for some time now. I think I created entry in blogger with such title back in February. Probably the thing that was keeping me off this work was the amount of detailed explanations and code examples to prepare. Also, topic isn't really that interesting for myself now since I had multiple discussions and arguments on this subject. However, I still see people that often falls in the trap of "Transactional scripts" so I decided that it is probably worth writing about this so more programmers would be able to identify flaws in their design and improve.  

Let's start with [Transactional Scripts](http://martinfowler.com/eaaCatalog/transactionScript.html). What are they? I would 
say that this is [Procedural Programming](http://en.wikipedia.org/wiki/Procedural_programming) 
disguised as OOP. In practice, it looks something like this: you have a bunch of 
objects that have only values but only few methods (probably setters and getters) and 
a bunch of "Services"* that manipulate those objects to get them into desired state (and persist) 
according your business process. Let rephrase that to emphasize what's happening - you have multiple 
scenarios that hold your business logic but your "model" objects don't have any.  

Example for completeness:  

<div class="gistLoad" data-id="6268164">Loading...</div>
{% highlight java %}

class BasketAddService {
    public void addItem(long basketId, String sku) {
        Item item = itemDao.getItemById(sku);
        Basket basket = basketDao.getBasketById(basketId);

        basket.getItems().add(item);
        /*
         * Using new Date() directly isn't really a good practice but it will suite as here
         */
        basket.setLastUpdate(new Date());
        basket.setTotalPrice(calculatePrice(basket.getItems()));

        basketDao.persist(basket);
    }

    private BigDecimal calculatePrice(List<Item> items) {
        [...]
    }


}

class Basket {
    private List<Item> items;
    private Date lastUpdate;
    private BigDecimal totalPrice;

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
}
{% endhighlight %}

Domain oriented model on the other hand, does encourage keeping 
closely related processes and business objects or entities 
together. If some specific process is related to object, they will probably
 be in the same class. Most importantly, code is shaped after actual business 
 language and flow, instead of being placed somewhere predefined.  

For comparison, let's take a look here:  

<div class="gistLoad" data-id="6268160">Loading...</div>
{% highlight java %}
/**
 * Facade here is like entry point to our Domain Logic. In web applications it may
 * usually be Controller or something similar.
 */
class BasketAddItemFacade {
    public void addItem(long basketId, String sku) {
        Item item = itemRepository.findOneBySku(sku);
        Basket basket = basketRepository.findOneById(basketId);

        basket.addItem(item);

        basketRepository.save(basket);
    }

}

class Basket {
    private List<Item> items;
    private Date lastUpdate;
    private BigDecimal totalPrice;

    public List<Item> getItems() {
        return Collections.unmodifiableList(items);
    }

    public void addItem(Item item) {
        items.add(item);
        lastUpdate = new Date();
        totalPrice = updatePrice();
    }


    public Date getLastUpdate() {
        return lastUpdate;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    private void updatePrice() {
        [...]

        totalPrice = something;
    }
}
{% endhighlight %}

According to Fowler, using Transactional Scripts is justifiable for 
small projects. For larger ones you want to 
Domain Driven Design. Why is that? The problem with Transactional Scripts is that while 
they are easy to start with, maintenance costs rumps up quite quickly when your 
project size increases. I would say this happens due to distributed 
logic among different parts of system - let's say you have special 
"corporate" order type which needs to be executed using different rules than for 
regular customer. You will end up writing all of that logic under separate 
Transactional Script that has to be incorporated into existing ones. 
This may not be so trivial task when you have around 100 or more. 
Additional flow might break existing scripts' functionality, 
new script may not be able to reuse same code for other scripts since it's hard to 
extract from current ones. 
DDD'ish approach would probably solve the same problem using plain polymorphism.  

Shorter version: it's a lot harder to apply [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design))principles 
while using Transactional Scripts. Also, these scripts tend to 
have circular dependencies between each other for different modules. 
Business logic isn't encapsulated by business entities.  

It's really hard to come up with decent examples here 
because we want to have example short so it would be easier to follow what is this 
example about. However, while it is easy to understand it will negate main 
point of showing why such transactional scripts are harder to maintain 
compared to proper Domain Model. Also, having really big examples here 
wouldn't look nice and main text would be hard to read.  

If you can notice any of these problems in your projects, it could mean that Transactional Scripts aren't working well for you:  

*   Adding additional step in our flow requires major restructuring
*   Changing "domain" object's rules ripples through multiple files
*   Different feature modules have cyclic dependencies between them
*   Code cannot be changed since it is used in MANY files
*   Entity's lifecycle cannot be described or can be only partly
*   Big project cannot be broken into smaller modules (SOAish) because of spaghetti dependencies

In the end this sums up to that that Transactional Scripts don't follow OOP principles and 
thus results in code that's harder to maintain. Remember that part where you 
have to keep your business logic (Transactional Scripts) for your Entities that 
are saved in database? That's basically means that you are going to have low cohesion[link]. Let me elaborate on this point next.  

There is nice interpretation about orthogonality and [cohesion](http://en.wikipedia.org/wiki/Cohesion_(computer_science))in 
"[The Pragmatic Programmer](http://pragprog.com/the-pragmatic-programmer)" book. Orthogonality in software 
projects basically means that changing one piece of system won't impact another 
one because they are "orthogonal" (independent) to each other. 
What does cohesion have to do with this? Cohesion shows how much module or class depends on itself 
to accomplish its task and how few other components it uses. Since Transactional Scripts approach 
to handling business logic always results in low cohesion (classes will always heavily depend on other classes) 
it basically means that your project in the end will be a lot harder to maintain than DDD'ish approach.  

One may think that just using plain old good OO Design and SOLID principles would mitigate this 
problem and this is totally true. But basically Domain Driven Design is the good practices 
applied your business domain context :).  

I hope I made my reasoning clear why do I prefer DDD approach to 
tackling business logic and I hope it will help you to refine 
your design or help choosing better approach too :).  

_*They are often called "Services" but actually "Services" are 
different things in Domain Driven Design. What do people 
usually call "Services" in software actually are "Transactional Scripts"._