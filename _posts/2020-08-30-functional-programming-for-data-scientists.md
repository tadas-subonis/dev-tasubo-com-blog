---
layout: post
title: Functional Programming for Data Scientists
author: Tadas Šubonis
date: '2020-08-30'
tags:
 - functional programming
 - software development
 - data engineering
---

During my years as a software engineer, I got exposed to more and more
data-based projects where data engineering and model research were
major aspects of the system.

Over time, one main pattern became apparent: the functional programming
paradigm helps a lot when working with data-oriented systems.

For a regular data scientist or a data engineer, they will be quite familiar
with ETL (Extract, Transform, Load) pipelines. However, not all data scientists
and data engineers are familiar with functional programming and its
benefits.

# Functional Programming

I'll remind again, that according to Uncle Bob, 
the essence of functional programming is that

> Variables in functional languages do not vary

and

> Functional programming is disciple imposed upon variable assignment.



Or, according to [Wikipedia](https://en.wikipedia.org/wiki/Functional_programming):

>In computer science, functional programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that each return a value, rather than a sequence of imperative statements that change the state of the program.


In other words, you can assign variables a new value, but existing values cannot change.

A few examples:
```python
# BAD
my_var = {'c': 'value'}
my_var['b'] = 'new_value'
# or 
my_var['c'] = 'new_value'

# GOOD

my_var = {'c': 'value'}
my_var = dict(**my_var, b='new_value')

# or
my_var = {'c': 'new_value'}

```

using functions
```python
# BAD
def my_function(input_dict):
    input_dict['new_value'] = 'var'
    return True

# GOOD
def my_function(input_dict):
    return dict(**input_dict, new_value='var')    

```


This has a few important implications:
 - if you receive value, you can be sure that it won't change mid-processing because it was modified
 in another thread
 - as a function caller, you can be sure that after calling the function passed in arguments
 haven't changed and you can use them the same way before calling the function
 - as a function writer, you can do whatever you want with the data, as long as you do not change
 the original value and return results in the new one

As you can see, it reduces surprises and eases the cognitional context load of the programmer as
we do not  need to worry about the state of the entire program but just the 
local state (input)
of the function.

There is a common expectation that if you call the function with the same arguments, it will
return the same results. However, that is not always the case:
 - reading the same file, with the same filename, might produce a different result if the file was updated
 - calling function that returns current time should return different time during each call
 - etc

These edge cases usually creep in from the environment (boundaries with the environment) and a keen
functional practitioner could work around these by introducing Environment or Context
states but for practical purposes it is more work than it is worth.


The implications above often lead to code structure that looks like this:

```python

x1 = my_function_one(input)
x2 = another_call(x1)
b3 = third_call(x1, x2)
final_result = calculate(b3)
```

It's easier to reason about the calls step-by-step as the context of each function call is
always limited.

As it usually happens, in data engineering data processing flows are often quite simple, and
the pipeline above looks like:

```python
x = my_function_one(input)
x = another_call(x)
x = third_call(x)
final_result = calculate(x)
```

## Coupling
One missing, but quite important, piece of this puzzle is that the functions should be cohesive (
one responsibility) and loosely coupled. What does it mean to be loosely coupled?

Let's compare these two examples:

```python
def my_function_one(b):
    #...
    return c

def another_call(b):
    #...
    c = my_function_one(c)
    return c

def third_call(b):
    #...
    c = another_call(c)
    return c

def calculate(b):
    #...
    c = third_call(c)
    return c

final_result = calculate(x)

```

and 

```python
def my_function_one(b):
    #...
    return c

def another_call(b):
    #...
    return c

def third_call(b):
    #...
    return c

def calculate(b):
    #...
    return c

x = my_function_one(input)
x = another_call(x)
x = third_call(x)
final_result = calculate(x)
```

What will happen, if _we_ do not need to call `another_call`? In the first case, we could remove it
from the `third_call` function, but that would break functionality for all the other
users of `third_call` function.

Clearly, the latter case is more loosely coupled, because we can just drop the `x = another_call(x)`
line, we will achieve our goals, and the code won't be broken for the other users.

The other nice thing is that nested function calls build this mental complexity hierarchy that
becomes harder to follow with each function. You can't really understand what each function does
without traversing the hierarchy up and investigating all the other calls.

# So what?

Now, we now know how to write nice "functional" functions. What can we do with that?

In the examples above we had a pipeline that processed just a single value. In most of the cases,
we operate on the lists. Those lists can be anything:
 - lists of lists
 - lists of byte arrays
 - lists of tuples that are made of other objects and other lists
 - etc

but we usually get some kind of list first. In Python, it means a specific type of array-like collection
but in reality, we just need some kind of Iterable.


## Enter the map

When we are processing a list of items, it is extremely easy to use the functions that we've defined
above to process the list using a `map`.

On Python, the call would look something like this:

```python
x = items
x = map(my_function_one, x)
x = map(another_call, x)
x = map(third_call, x)
x = map(calculate, x)
```


## Reduce it

What if we want to get a single value as a result? Functional programming toolset has 
this function called [reduce](https://docs.python.org/3/library/functools.html#functools.reduce):

```python
from functools import reduce

#...
x = map(calculate, x)
x = reduce(lambda c, i: c + i, x)
```

Actually, `reduce(lambda c, i: c + i, x)` is the same as
`reduce(operators.add, x)`. It is also equivalent to `sum(x)` on Python,
so the same above could be expressed as:

```python
#...
x = map(calculate, x)
x = sum(x)
```

It is important to note here, that `lambda c, i: c + i` is a function
and could be replaced with anything. For example, calculating is not
that difficult either (but there are better ways):

```python
def accumulate(cumulative, current_item):
    count, sum = cumulative
    return count + 1, sum + current_item

#...
x = map(calculate, x)
x = reduce(accumulate, x, initial=(0, 0))
average = x[1] / x[0]
```

## Composing functions
I've just used (introduced?) an extremely important concept in FP -  function composition. It deserves
a special mention.

In the part `reduce(accumulate, ...)` you can see that we are calling a function, that takes another
function as the argument. To be used inside `reduce` the `accumulate` function has to satisfy 
the same signature requirements (if such a thing exists in Python at all...) - it takes two arguments
and returns a single value. The first argument and the return value should be (preferably) of the same 
type.

Then, when the time comes, `reduce` will call our supplied function to accumulate the stream of values
into a single value (it will get _reduced_). 
For developers who know their [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming), 
it is the same as a [Strategy pattern](https://en.wikipedia.org/wiki/Strategy_pattern).

We can use the same idea in our functions as well. For example, let's say we are writing a 
function to normalize some input data, but we want to let our users choose if the text
should be processed uppercased or lowercased. We could implement that like this:

```python
def noop(text): # default function that does nothing
    return text

def clean_text(text, text_processor=noop):
    text = text[:10]
    text = text_processor(text)
    return text

first_use = clean_text("aaAA", str.upper)
second_use = clean_text("aaAA", str.lower)
third_use = clean_text("aaAA")
```
### Factory functions

The version of the `clean_text` above can be unwieldy to use with `map` so it is often beneficial
to create a factory function, that creates the version of `clean_text` that has only a single
argument but you still get to choose which text processing function to use:

```python

def clean_text(text_processor=noop):
    def step(text):
        text = text[:10]
        text = text_processor(text)
        return text
    return step

items = map(clean_text(str.lower), items)
```

This is also a perfect way to create configurable functions.

### Better composition examples
In the example above, we could move the text_processor to the pipeline itself:

```python
def clean_text(text):
    text = text[:10]
    return text

items = map(clean_text, items)
items = map(str.lower, items)
```

so a better example would be a randomizing post-processing function, to augment 
text examples for your neural network. We will make this augment function configurable,
so the users of the function can choose the possible augmentations:

```python
import random

def clean_text(text):
    text = text[:10]
    return text

def augment(augmentations):
    def step(text):
        augmentation = random.choice(augmentations)
        return augmentation(text)
    return step

items = map(clean_text, items)
items = map(augment([noop, str.lower, str.upper]), items)
```


# Functional IF

Often, I get to see functions that look something like this:

```python

def some_big_function(x, z):
    if x is None:
        return None
    elif x == "a":
        return z
    else:
        i = 0
        counter = 0
        for y in z:
            i += 1
            counter += y / i

        return counter
```

while the specific example above is not that bad because it is rather clear 
what's happening just because it is ~10 lines long, I am not happy when I find
code like this.

This big function can be deconstructed in a few smaller functions (let's pretend
that this code is 100 lines long) and those functions can then become a part
of the pipeline.

```python
def is_empty(e):
    return e is None

def is_it_a(e):
    return e == "a"

def some_big_function(x, z):
    if is_empty(x):
        return None
    elif is_it_a(x):
        return z
    else:
        counter = sum(y / i for y, i in enumerate(z))
        return counter
```

Let's handle IFs first. I would say there are two types of ifs:
 - the ones that become `filter`s
 - the ones that become `map`s

If I can extract some `if` as a `filter`, that's always a win, because 
there are going to be fewer items downstream:

```python
from itertools import starmap

items = multiple_x_z

def some_big_function(x, z):
    if is_it_a(x):
        return z
    else:
        counter = sum(y / i for y, i in enumerate(z))
        return counter


items = filter(lambda x, z: is_empty(x), items)
items = starmap(some_big_function, items)
```

then, I would extract the remaining if/else as a map to ensure that each function is as simple
as possible and it only responsible for one task:

```python
from itertools import starmap

items = multiple_x_z

def count_it(z):
    return sum(y / i for y, i in enumerate(z))

def count_or_return(x, z):
    if is_it_a(x):
        return z
    else:
        return count_it(z)

items = filter(lambda x, z: is_empty(x), items)
items = starmap(count_it, items)
```

# More functions
When you start building flows like this, you will soon realize that there are many tricks you
can do by composing function and creating context-local utility functions

For example, let's say `x` is now a part of some context. We could rewrite the program like
this:

```python
items = multiple_z
x = context_x

def count_or_return(z):
    return z if is_it_a(x) else count_it(z)

def is_x_empty():
    return is_empty(x)

def create_counting(x):
    def step_a(z): # basically, identity function
        return z

    return step_a if is_it_a(x) else count_it

items = filter(is_x_empty, items) # this becomes basically a all or nothing switch
items = map(create_counting(x), items)
```

# Use classes

Using classes and or [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming) in the Functional Programming deserves [a separate post](/2020/04/functional-object-oriented-programming.html), 
but there are a few short notes that I would like to make here.

Building FP-based systems or pipelines, there will be functions
that  several arguments and return multiple values (tuple). For example,

```python
def fun(a, b, c, d):
    return a, b, c, d + 2, a + 3

# or

def fun(items_dict):
    return items_dict['a'] * 2, items_dict, items_dict['b']
```

this is a messy way to structure input and output. It is brittle and hard to maintain. Also,
you will end up abusing [starmap](https://docs.python.org/3.8/library/itertools.html#itertools.starmap)
quite a bit.

In cases like these, when you have to receive more than two values as an argument, 
or return more than two values, I recommend using [dataclasses](https://docs.python.org/3/library/dataclasses.html).

For example:

```python
from dataclasses import dataclass, field, replace

@dataclass
class Item:
    name: str
    price: float
    quantity: int = 0

    def total(self):
        return self.price * self.quantity

x = Item("Apple", 1.00)

def assign_quantity(x: Item):
    return replace(x, quantity=10)

items = map(assign_quantity, items)
items = map(Item.total, items)
total_cost = sum(items)
```

Using _dataclasses_ you get a few benefits:
 - it is easy to create a new and 
updated value (object) using [replace](https://docs.python.org/3/library/dataclasses.html#dataclasses.replace), 
without modifying the current value
 - classes become a natural place to keep class-specific methods
 - functions/methods that work on classes are easy to update and interfaces won't break as often

If you can't use dataclasses because you are stuck on the old version of Python (pre 3.7),
there is [attrs](https://www.attrs.org/en/stable/#) project that does the all of the above and more.


# Pushing it further

After a while, things like these will start catching your attention:
 - `if` statements - can they be simplified or extracted as `filter`s 
 - `for` loops - are they necessary? can they be replaced with a `map` or `enumerate`?
 - function calls inside functions - can they be moved to the main pipeline? can the current
 function be simplified by removing them?

It might not be immediately obvious how to fix or change that, but with each "exercise" it's 
gonna be easier and easier.

Naturally, your programs will become easier to compose and easier to maintain.
Loose coupling and high cohesion = maintainable code. And all of that will come for free if you are
just going to follow these FP principles. 
It will
help to avoid a classical spaghetti code mess that quite a few data engineering projects suffer.

# Outro 

In this article, I've tried to outline the most important principles (in my opinion) that
developers who are less experienced with Functional Programming could understand and would start
applying in their code to improve its quality. 

This is especially relevant to data-oriented developers, where the Functional Programming paradigm
will help immensely to avoid an unmaintainable mess.

I haven't properly touched the part where experienced FP developer would start composing functions
but that's for later. Also, I am planning to cover certain "recipes" later.

For the keen learners, I can recommend  [https://www.coursera.org/learn/progfun1/home/welcome](https://www.coursera.org/learn/progfun1/home/welcome) 
course which covers FP in more detail and better than me.
