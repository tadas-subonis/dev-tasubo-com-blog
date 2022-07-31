---
layout: post
title: Crash course on Domain-Driven Design for juniors
author: Tadas Šubonis
date: '2022-07-31'
tags:
 - domain driven design
 - software development
---


# Intro

A goal of this write up is to introduce the main tools of domain-driven design to new developers 
so they can pick up the approach quickly.

There are two big parts of domain-driven design: organizational (arguably more important) and
tactical patterns for developers.

This will focus on the latter as for junior and mid-level developers the techniques here can
take the quality of their code to the next level. I would also argue that the developers
can become substancially more productive if they do TDD.

This post should be considered as a short intro and serious practitioners will want to 
read the following books:
 - Domain Driven Design - tackling the heart of software complexity
 - Domain Driven Design Distilled 
 - Implementing Domain Driven Design

The "blue book" is a must read for all level engineers if they haven't done so. The "red book" would be
more appriopriate for architect-level contributors. Finally, the distilled version is useful as a refresher
or as a review for more recent trends (like event sourcing).

# Organization aspect

Let's start with organizational part as it's quite important but let's keep it short and coincise. There are
three main tools to be aware of:

## Ubiquitous language
It's a way to ensure that everybody is speaking the same language. Developers, project managers, and domain experts.
Create and define all terms on some wiki page so when somebody write a class "Post" you know what it means and that
it isn't a "Blog" or something else.

Helps immensely to get everybody on the same page.

## Bounded context
It's basically a description of scope for what the team is responsibe for. Which parts of programs, features, or
functionality some team will cover.

## Context Map
This is useful for team leads and managers - it shows how different bounded contexts are connected and the connection
interfaces (HTTP Rest Interface, Shared Database, etc) are defined.

Great to understand a structure and responsibilities for bigger systems.

# Tactical developer patterns

The tactical patterns can make life a lot easier by shaping the software structure in such a way
that it is easier to understand and maintain.

It helps to **create a better distinction between infrastructure and domain code**. 

Quite often developers have a lot of trouble separating the core of the business code from something that's
shaped by the environment you are coding in. The first one delivers business value, while the second one
enables the delivery of it.

## Entities

Entity is an object (or a class) that has an identity. As soon as you see an ID field on the object
it's a strong sign it's an entity.

For example,

```typescript
class Post {
    id: UUID;
    title: String;
    content: Text;
}
```

## Value Objects

Value object is a simple class that contains the info but isn't necesseraly distinguishable by some identifier.

```typescript
class Weather {
    raining: bool;
    temperature: number;
    measurementTime: Date;
}
```

Event if you decide to save this object in the database for some timeseries logging/analysis purposes
 and you add some `_id` field it's still a value object - the identify
of this piece of data doesn't matter.


## Factory

A factory pattern is just a standard pattern that's used to **create** entities and value objects if the 
creation of such object is a complex process. Don't use it if you don't need it, but it should be ready
in your toolbox. 

A good use factories can ensure that even the most complex entities can be created in a simple and intuitive 
way.

Let's take a look at example, where we store `Post` objects that contain `Weather` information right 
at the time when the `Post` was created:

```typescript
class WeatherService {

    getCurrentWeather(): Weather {
        return ...;
    }
}

class Post {
    id: UUID;
    title: String;
    content: Text;
    currentWeather: Weather;
}


class PostFactory {
    weatherService: WeatherService;

    create(title: String): Post {
        
        return Post(
            randomUUID(),
            title,
            "",
            this.weatherService.getCurrentWeather()
        )
    }
}

```

However, if a simple constructor use is enough, just please use that. There is no need to make things more complicated
than nessary.

## Aggregates & Aggregate Root

Aggregates are extremely important to understand and this is simpler said than done. 

First of all, an aggregate is an Entity. Aggregates are about consistency and correctness of the state so when
we say that some entity is an aggregate it means that there are some state consistency guarantess.
I think it would be great to start
with a few rules for aggretates:
 1. At any point in time, the whole state of an aggregate is valid
 2. Two instances of different aggragates are independant and there are not consistency guarantees
 3. Aggregate is loaded and saved via aggregate root
 4. The state of an aggragate is changed via aggregate root



Repository

Service

Other 
 > Anti Corruption Layer
 > Shared Kernel
 > 

Overall structure

Building RESTful interfaces
