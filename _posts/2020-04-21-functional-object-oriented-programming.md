---
layout: post
title: Functional Object Oriented Programming
date: '2020-04-21'
author: Tadas Šubonis
tags:
- software
- programming
- immutable
- oop
- object oriented programming
---

Due to strange reason lots of people take Object Oriented Programming and Functional Programming as
mutually exclusive paradigms. That doesn't have to be the case, and with this post I'll present a few
simple techniques to make your code a bit easier to reason about while preserving the
communicative nature of OOP.


# Immutable objects and Functional Programming
According to Uncle Bob, the essence of functional programming is that

> Variables in functional languages do not vary

and

> Functional programming is disciple imposed upon variable assignment.


It's a huge win in productivity when you do not need to worry about external mutations on the object that you
are working with.

A few classical examples where such mutations can occur and how they can mess up the flow of your program:
 1. Object is received in the function your are working on. Everything is working fine but in production environment
 there is an asynchronous thread that modifies the passed in value while your are working with it - the results are
 unexpected.
 1. You need to pass a variable to some external function developed by another team. The function returns void
 and it is supposed only to save the value to the database. However, unbeknownst to you, the value is also 
 modified while being persisted. Now you continue working with the modified data while you think that it is
 still the same at it was passed in - the results are unexpected.

 Unexpected modifications to the objects like that are a major pain in the ass and developers of choose 
 to do some defensive programming to avoid that.

 In Python, it is quite common to find:
 ```python
my_dict = dict(passed_in_dict)
#or
my_dict = passed_in_dict.copy()
 ```

 As we see, there is clearly some value in following the functional approach here and making the
 variables immutable.

# Object Oriented Programming

To me personally, one of the biggest benefits of Object Oriented Programming is the 
communication framework this paradigm provides.

While R. C. Martin states that the core of OOP is

> Object Oriented Programming is disciple imposed upon indirect transfer of control

(it's about an ability to depend on abstract interfaces while the concrete implementation is provided
indirectly by the environment thus avoiding the dependencies on the details).

I would still probably say that I like OOP mainly because of:
1. It is easy to communicate the presence of the concepts in the domain (`User`, `BlogPost` etc.)
1. It is easy to communicate the available actions and processes in the domain (`User.ban()`, `Repository.publish(blogPost)` etc.)
1. It is easy to communicate what data goes together and how it is related to the domain (fields in the class)

This list isn't refined or final but you get the gist - using OOP it is quite straightforward to model your domain. It's not 
like you can't do that with Functional Languages - you can do basically the same albeit you will probably
won't be sure that you've found all methods/functions that can or are supposed to modify the data
in one nice place (class).

It's worth pointing out, that it doesn't mean the code is OOP if you are using OOP language - mediocre developers often
throw out the concepts of encapsulation, cohesion, and low coupling through the window in OOP languages like Java or C#.

# Immutable Object Oriented Programming
Finally, we are getting to the core of this article - combining the functional and object oriented approaches. However, before that,
I would like to bring up one of the main reasons why I've decided to talk a bit about this.

## Flux and Redux

[Flux](https://facebook.github.io/flux/docs/in-depth-overview) is arguably one of the best patterns to implement GUI-related interfaces 
these days. One of the most popular implementations is [Redux](https://redux.js.org/introduction/getting-started). Overall, I am very happy
with this pattern and have a few success stories where I was able to avoid a convoluted mess by following it.

However, I am not happy with the quality of the code examples on the Reducer (the bit that calculates the new state) part of the Flux pattern.

In most cases, it goes something like this:
```javascript
function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      return state.concat([{ text: action.text, completed: false }])
    case 'TOGGLE_TODO':
      return state.map((todo, index) =>
        action.index === index
          ? { text: todo.text, completed: !todo.completed }
          : todo
      )
    default:
      return state
  }
}
```
You get some data, you modify the data, and then you return it. Yes, it's functional. However, it also missing a domain "hints" on what is happening.

## Enter OOP
Let's rework this JavaScript example a bit. I am a big fan of making implicit concepts explicit by defining them early and clearly. Let's start with the
state and let's make use of this great [immutable-js](https://immutable-js.github.io/immutable-js/docs/#/Record) library.

```javascript
const { Record } = require('immutable')

class Task extends Record({ text: '', completed: false }) {
}

class State extends Record({tasks: []}) {
}

```

That's all great, but the reducer above is still a pain to look at. By introducing a few methods, we can fix the situation:

```javascript
class Task extends Record({ text: '', completed: false }) {
    toggleTodo() {
        return this.set('completed', !this.completed);
    }
}

class State extends Record({tasks: []}) {
    toggleTodo(taskIndex) {
        const task = this.tasks[index].toggleTodo();
        return this.set('tasks', this.tasks.set(taskIndex, task));
    }

    addTask(task) {
        return this.set('tasks', this.tasks.push(task));
    }
}
```

So now the reducer will become:

```javascript
function todos(state = new State(), action) {
  switch (action.type) {
    case 'ADD_TODO':
      return state.addTask(new Task({ text: action.text, completed: false }));
    case 'TOGGLE_TODO':
      return state.toggleTodo(action.index);
    default:
      return state
  }
}
```

which is much more readable and clearly communicates what is happening in the code. Warning: I haven't run this
code through the interpreter so it might be that it doesn't actually work but I assume that the idea 
is clear from the code provided above.


## Java
Java has a great library called [Immutables](https://immutables.github.io/) which makes
use of code generation to create extremely performant, easy to use and non-intrusive immutable classes.

The immutable class would look like
```java
@Value.Immutable
public abstract class Person {
    abstract String getName();
}

ImmutablePerson me = ImmutablePerson.builder()
  .name("Tadas")
  .build();
```

While you can find lots of examples of how the object is updated using `with*` methods like
```java
if (somethingTrue)  {
    Person you = me.withName("you");
}
```

that should be avoided and, in my opinion, you should go for OOP like descriptive methods:

```java
@Value.Immutable
public abstract class Person {
    abstract String getName();

    public Person makeMeYou(){
        return ImmutablePerson.copyOf(this).withName("you"); // copyOf() is noop in this case
    }
}


## Python
Python since version 3.7 can provide similar means to work with immutable code:

```python
from dataclasses import dataclass, replace

@dataclass(frozen=True)
class Person:
    name: str

    def make_me_you(self):
        return replace(self, name="you")
```        



# Outro
There is no need to make OOP and functional programming mutually exclusive as both paradigms ofter mutually 
exclusive paradigms which can be combined to create robust and maintainable code.
