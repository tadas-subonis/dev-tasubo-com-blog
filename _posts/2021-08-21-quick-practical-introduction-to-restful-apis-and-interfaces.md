---
layout: post
title: Quick and Practical Introduction to RESTful APIs
author: Tadas Šubonis
date: '2021-08-21'
tags:
 - api
 - restful
 - software development
 - data engineering
---

# Intro
This is a quick and rough introduction for fresh developers
to RESTful APIs.

It should cover just enough to get you started while focusing only
on the practical aspects of REST APIs.


# Why?
Why should you build a RESTful API? The reason is, basically,
that it's easy to use and support such interfaces.

As Wikipedia defines it:

> Representational state transfer (REST) is a software architectural style that was created to guide the design and development of the architecture for the World Wide Web. 

It was noticed by Roy Fielding, that the early WWW concepts can be applied not only 
to the websites but the APIs too. There were a few traits of web-based systems:
 - They use HTTP protocol which is simple to implement
 - Operations are limited to a few main methods (GET, DELETE, POST, PATCH/PUT)
 - The web is stateless (at least most of the early web)
 - The responses are cacheable

Using these insights he derived a few main guidelines to follow.

I would like to believe that REST-like interfaces are here to stay for a long time and
will be a fundamental technique to build distributed APIs on the web.

The web itself is REST-like and we've seen now for the last 40 years that it works quite well, so
it's reasonable to believe that APIs might follow the same case.

## Architectural Constraints

These constraints (guidelines) are (were):
 * Client-server architecture
 * Statelessness
 * Cacheability
 * Layered system
 * ~~Code on demand~~
 * Uniform Interface:
    * Resource identification in requests
    * Resource manipulation through representations
    * Self-descriptive messages
    * Hypermedia as the engine of application state (HATEOAS)


There is no need to explain their original definitions but for the modern APIs, it
roughly translates to the guidelines outlined below.

# Modern guidelines

So what does all of that mean? Let's rework these rules into something
 easy to understand.

## Use HTTP protocol
The HTTP protocol is simple and well-understood. There is a lot of infrastructure to facilitate 
HTTP-based APIs (client and server libraries) so it's easy to use it.

Almost all programming languages support HTTP protocol out-of-the-box which wouldn't
be the case with RPC-based frameworks like [RMI](https://en.wikipedia.org/wiki/Java_remote_method_invocation).

## Resources should have well-defined locations (URIs)

First of all, what is a resource? The easiest way to describe, it would be to say
that the resource is an 
[entity](https://khalilstemmler.com/articles/typescript-domain-driven-design/entities/). 
It could be a *User*, *Order*, *LogEntry*, etc.

Resource should be identifiable so it means it should have an ID.

Next, each resource should have an easy to use URI (URL since we are using HTTP(S)). 
Here are some examples:
 - `/users/{user-id}`
 - `/users/{user-id}/orders/{order-id}`

The nesting of resources should reflect the logical structure:
 - `/users/` - a place to find all of the users
 - `/users/{user-id}` - a place to find one specific user
 - `/users/{user-id}/orders` - a place to retrieve all orders for one specific user
 - `/users/{user-id}/orders/{order-id}` - retrieve one specific order for a specific user (and throw an error (404) if the order with `order-id` doesn't belong to that specific user )
 - `/orders` - return all orders on the system
 - `/orders?status=completed` - return all completed orders

This makes resources easy to find and retrieve. Naturally, these URLs should contain
full URL like `https://mydomain.com/users/{user-id}` .

## Use HTTP methods to facilitate different operations
Now we know where is our stuff is stored, so we can start doing something with it.

For that, we use the following HTTP verbs

### GET
*GET* is used to retrieve content
  - `GET /users/` - get all of the users 
  - `GET /users/123` - get one specific user

Please note, that the *GET* should be idempotent meaning that if you request the resource
multiple times, it shouldn't change the state of the resource and it should always return
the same resource.

Basically, besides logging, you should not make any changes
on the system because of GET request.

### POST  
*POST* - to create new content
  - `POST /users/` @CONTENT - create a new user with the details that have been specified in the @CONTENT payload.

When doing the post requests, there are a few ways to handle the responses:
 1. Return the object immediately as a part of the response with its current state
 2. Return the "Location" header and redirect the user to the newly created resource

Both ways will work fine.

### DELETE
*DELETE* - to remove entities/content:
  - `DELETE /users/123/` - delete a specific user from a system
  - `DELETE /users/1234/orders/AR203` - cancel an order after it was created.

### PUT/PATCH  
*PUT/PATCH* - update/change existing contents.
 - `PUT /users/123` email=tadas@email.com - update some specific value in the resource

# HATEOS
HATEOS (Hypermedia as the engine of application state), in my opinion, is a bit too
fancy thing for a regular developer to care about.

I'll borrow an example from here:
```
GET http://api.domain.com/management/departments/10
{
    "departmentId": 10,
    "departmentName": "Administration",
    "links": [
        {
            "href": "10/employees",
            "rel": "employees",
            "type" : "GET"
        }
    ]
}
```

The `links` part shows us related resources and we can follow up on them. This is useful if 
you are exploring API and can provide an additional context of what could be done 
with the entity.

There is a so-called [Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html) for APIs:
 - Level 0 - no RESTful aspects on the API
 - Level 1 - API has a concept of resources
 - Level 2 - HTTP Verbs are used to facilitate domain logic
 - Level 3 - API is using HATEOS

In practice, Level 2 is plenty. HATEOS is usually an overkill for an API that's gonna be used
by 2-10 people. And that's the most common use case because most of the APIs are internal
and are consumed by internal teams.

Burdening your developers with fancy stuff like links to the sub-resources (somebody needs
to build that stuff) is often too much, and a much simpler approach like "Hey Jack, where
I can get a list of orders for the user?" is often good enough solution.

# Practical tips
There are some practical aspects of building RESTful APIs.

## Use JSON
It might be an obvious one, but just use JSON to transfer the data.

JSON is as widely supported as HTTP itself and you will have fewer problems with your clients.
Also, it's easy for humans to read and understand (definitely better than ProtoBuf).

XML used to be an option 10-15 years ago but these days it's too verbose and XML parsing libraries
are quite heavy (dependency wise) and sluggish.

## Version API
There are two ways to version APIs:
 1. Use Content-Type with custom vendor extensions and include the version there like 
 `vnd.mycompany.OrderV2+json`
 2. Include the version as part of the URL: `/api/v1/orders/`

I find it better and easier to use the URL version of the versioning because dealing with
Headers is often much more tedious.

Also, please note that if we introduce a new version of orders via URL, it doesn't mean
that the other versions need to be moved/bumped two. There could be multiple versions active at the same
time:
 - `/api/v1/orders/`
 - `/api/v2/orders/`
 - `/api/v1/users/`
 - etc

and the new version of the API use can be rolled out gradually on the client
side while supporting the old clients.

Furthermore, it's a good idea to prefix the API service
with `/api` to allow you to 
add non-API endpoints in the future and route/redirect them differently if there is a need.

## Return the full resource
Quite often, you can hear people worrying about sending too much data
over the wire. They start introducing all sorts of Data Transfer Objects
and will stop working with the original Entities.

An argument that comes up quite often is

> I only need a list of order IDs - why do I need to fetch all the other information
> from the database and then send it over the HTTP?

If you are following Domain-Driven Design (or at least if you are using Aggregates), you
will have to retrieve the entire document from the database. And then, there is
a very little extra cost of sending a few more kB over the wire.

However, you only have one URL for the same resources. Multiple clients will be accessing 
the same URL with different needs. So why you might need only the ID of the Order,
the other users might need many more fields.

Normally, there should be no problems handling 1-4MB response sizes
for your HTTP client. In 4MB you can fit in 1000 entries that are 4kB big. And 4kB is a lot 
of text. Compressing that with gzip (and you should enable that on your webserver), 
can reduce that size 10x. Also, here you would normally be using pagination :).

Finally, if you really want to limit data to just a few fields you need, depending on your 
framework (or your skills), you can add an option `fields` or something similar to return only
the fields you need:
```
GET /orders?fields=id,status
[
  {
    "id": 1,
    "status": "pending",
  },
  {
    "id": 2,
    "status": "pending",
  }
]
```

In the end, premature optimization is the root of all evil. Optimize your payloads when
it's actually needed.

## Do not make API breaking changes
Seldom it is a good idea to break API for existing users. Let's take a look at the 
changes which are breaking and which are not.

What's OK:
 - Adding new field
 - Adding new endpoint/resource
 - Adding additional query parameters

What's BAD:
 - Renaming/Removing existing field
 - Renaming/Removing existing URL/Resource
 - Renaming default Content-Type
 - Renaming/Removing existing query parameters

# Pitfalls to avoid
Some pitfalls are easy to notice and should be avoided.

## Do not use verbs in the URL

If you find "RESTful" APIs with URLs like these:
 - `POST /orders/create`
 - `GET /users/{user-id}/delete`

It means they are failing to use URIs as a way to communicate the structure of the resources
and HTTP verbs are crying in the corner because you are not using them.

Even HTTP clients will be confused as you will be getting errors with GET requests:
 - `GET /users/1/delete` - OK
 - `GET /users/1/delete` - Error. Not found.

## HTTP and REST is not your domain layer

This is a tricky one. Just because you are getting some content from the client
it doesn't mean that you have to accept it.

For example, let's say there is an order:
```
{
  "id": 1,
  "total": 12,
  "status": "pending"
}
```

and let's say there is a business process that requires the order to be approved
first before it can be shipped. The whole state machine looks like this:
```
pending -> approved -> handling -> shipped"
```

So if your order is in "pending" status, and the client sends a request like this:
```
{
  "status": "handling"
}
```
you will have to reject it.

And it would be the wrong approach to add just a bunch of ifs on the REST layer. You should
facilitate a process like this:
```
order = findOrderById(id)
order = order.readyForHandling()
// OR
order = order.status("handling") // "handling" is retrieved from the request
```
and `.readyForHandling()` or `.status()` should throw an exception because 
we want to move it to an illegal states.

Business process logic should be the domain logic and it shouldn't be part of the RESTful interface.

## Supporting multiple content types

While often it is easy to add support for XML and JSON and whatever else using  
frameworks (like Spring Boot) often there is no need to do that.

Just having JSON is enough on 99% of occasions and if by pure chance somebody will start
using the XML version of the API, you will have to maintain that.

Just stick to one content type and do not change it.


## Reinventing too complex security

In 95% of cases, it should be enough to use:
 1. HTTP Basic Authentication.
 2. HTTPS

HTTP Basic Auth should be in the format `user_id:api_key` . This way you will support all of the HTTP
clients out-of-the-box and it will be super simple to use.

There is no need to do strange stuff like digests, hashing, encryption, and so on because
HTTP**S** will handle that for you.

These days there is almost no excuse for not using HTTPS.

## Not using existing HTTP status codes

If every request responds with [HTTP status](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
 code 200 or 500 there might be missed opportunities to utilize the HTTP stack better.

Use the following codes:
 - 201 - Resource created
 - 401 - Unauthenticated
 - 403 - Unauthorized (originally, it's 401 unauthorized)
 - 404 - no such resource
 - 409 - Resource is already out-of-date

# Resources
 - The initial dissertation can be found [here](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm)
 - A great resource by [InfoQ](https://www.infoq.com/articles/rest-introduction/)
 - [RESTful Web APIs: Services for a Changing World](https://www.oreilly.com/library/view/restful-web-apis/9781449359713/)
 - [RESTful Web Services](https://www.oreilly.com/library/view/restful-web-services/9780596529260/)
