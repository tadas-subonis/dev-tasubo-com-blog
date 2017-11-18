---
layout: post
title: Use of EventBus in Domain Model
date: '2013-03-30T15:56:00.003-07:00'
author: Tadas Šubonis
tags:
- event bus
- software design
- domain driven design
modified_time: '2013-03-31T08:39:52.414-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-4863754382256740751
blogger_orig_url: http://dev.tasubo.com/2013/03/use-of-eventbus-in-domain-model.html
---
  

This time I decided to cover interesting topic about integrating subsystems using EventBus. EventBus is like enhanced [observer pattern](http://en.wikipedia.org/wiki/Observer_pattern). Depending on implementation you can synchronously or asynchronously wire different parts of application. This is done through event-like messaging mechanism that works like this: interesting parts of application send events to the bus when something of importance happens and other system parts which are subscribed to the bus listen to specific kind of events. Main difference from observer pattern here is that bus is central Observable through which all the traffic go.

This has several advantages over plain Observer pattern: it's easier to track and log events, it's easier to subscribe to specific type of events (since there is single source of events) and it's simpler to publish events since the framework for doing that must be implemented once.  One of the most notable uses of EventBus is Swing event system.

EventBus, I would say, is almost universal solution in event-based scenarios that should work in business domain. What I mean is that in high-concurrency systems you may be better off with actor model since centralized EventBus may soon become bottleneck.

Back to Domain Model... Sometimes there are parts in the system that shouldn't be coupled by direct method invocation to each other. Good example in this case would be customer Order subsytem and Mailing system. Usually order system doesn't care when or whether at all the email was sent to customer when his order was made. This is because usually none of the invariants in ordering system are broken if email wasn't delivered.

Making these systems coupled wouldn't make a lot of sense too because we would be tying technology with business which may not be what we actually want. Some businesses are based on some kind of technology but in this case the concept of notifying user is important to us not sending the email. Maybe we would like to be able to notify users through different channels such as SMS message, Phone Call, instant messaging system are all of them at once.

To solve this strong coupling problem we could use interface that defines business action and provide implementation using Inversion of Control techniques. See:

{% highlight java %}
    class ShopSellerService {

        @Inject
        @SMS
        private Notifier notifier;

        public void sell(Order order) {
            order.toPlaced();

            notifier.sendOrderPlacedNotification(order.getCustomer());
        }

    }
{% endhighlight %}

So why would we use EventBus? EventBus would fit our case perfectly if we would decide that we would like to do multiple actions when customer makes an order. Let's say we would like to send an email and notify some kind of our internal system that we have a new order. Code could look something like this:

{% highlight java %}
    class OrderPlacedEvent {
        private Order order;
    }

    class ShopSellerService {

        @Inject
        private EventBus eventBus;

        public void sell(Order order) {
            order.toPlaced();

            eventBus.publish(new OrderPlacedEvent(order));
        }

    }

    class SmsNotifier {
        @Inject
        private EventBus eventBus;
        @Inject
        private SmsGateway smsGateway;

        @Listener
        public void listen(OrderPlacedEvent event) {
            Template message = TemplateFactory.createOrderPlacedMessage();

            /*
             * Infer destination customer and other variables for template
             */
            Message message = message.assign(event.getOrder());

            smsGateway.send(message);
        }


        @PostConstruct
        public void loaded() {

            /*
             * After the bean has been initialized we start listening for events on
             * event bus. There is no need to unsubscribe on PreDestroy because we
             * assume this will get called when the whole application is stopped -
             * this listener is application scoped.
             */
            eventBus.subscribe(this);
        }
    }

    class WarehouseJobUpdator {
        @Inject
        private EventBus eventBus;

        @Inject
        private JmsGateway jmsGateway;

        @Listener
        public void listen(OrderPlacedEvent event) {

            /*
             * Forward message to Warehouse JMS queue
             */
            jmsGateway.sendToWarehouse(event);
        }


        @PostConstruct
        public void loaded() {
            eventBus.subscribe(this);
        }
    }
{% endhighlight %}

  
This way we have nice and easily maintainable mechanism for attaching new events for various system events.

There is one thing that developer should watch for in GC based/enabled languages - leaking references. It is easy to create "short-lived" object that should listen to event only for short amount of time and after ditching it, expect it to be garbage-collected. But since you subscribed to EventBus, there is a reference from Bus to our short lived object and that object isn't going to be garbage collected. One way to solve this is to use Weak References and other is to unsubscribe explicitly when that object should be removed. Weak references should be used with care since if there are no external references to our object it may be garbage collected even if we intended to use it permanently  Personally I would solve this problem by introducing subscribe and weakSubscribe methods that would use different types of references depending on method used to register listener.

Having this loosely coupled system using EventBus allows us to easily refactor our application. Since we don't have any direct dependencies we may move entire packages to different projects and evolve them separately with ease. Ability to do such thing is often underestimated and at some point in the future for long running project, we may be forced to rewrite the same functionality in external application instead of extracting service and reuse it. This extraction would only involve changing backend code of subscribe to work over some kind of remote protocol. HTTP, Sockets, JMS or whatever.

One additional thing that requires our attention is custom types for event messages. We may not be happy using only basic language types to pass around messages. Defining custom event types, that carry multiple fields of information is more convenient for us. But doing so we may create unnecessary dependencies between independent parts of the system since they are going to share same codebase. In my opinion a good way to solve this problem is to introduce a separate package that contains events for your system. This may not be the best way looking from the package-by-feature perspective but we can look this from the other way: these events do crosscut through entire application and are used by multiple packages so it isn't so bad to put them into one package. And if you decide that these event types should be shared between multiple projects, it is easy to extract them into separate tiny library-like project that may be reused.

Also, don't forget to checkout these EventBus implementations:

  

*   [Guava](https://code.google.com/p/guava-libraries/wiki/EventBusExplained)
*   [EventBus](http://eventbus.org/)



To conclude I would like to try to come up with a few guidelines when using EventBus makes sense:

*   Two parts of system should be loosely coupled.
*   Event initiating system shouldn't be blocked by long running actions.
*   Event initiating system doesn't care what is being done in other system after event is fired.
*   There are multiple observers (anticipators) for that type of event (action).