---
layout: post
title: Functional Programming for Data Scientists
author: Tadas Šubonis
date: '2020-09-02'
tags:
 - tag
 - draft
---

During my years as a software engineer I got exposed to more and more
data-based projects where data engineering and model research were
major aspects of the system.

Over time, one main pattern became apparent: functional programming
paradigm is help a lot on data oriented systems.

For a regular data scientist or a data engineer, they will be quite familiar
with ETL (Extract, Transform, Load) pipelines. However, not all data scientists
and data engineers are familiar with functional programming and its
benefits. That's especially true if they are junior developers.

# Functional Programming

I'll remind again, that according to Uncle Bob, 
the essence of functional programming is that

> Variables in functional languages do not vary

and

> Functional programming is disciple imposed upon variable assignment.



Or, according to [Wikipedia](https://en.wikipedia.org/wiki/Functional_programming):

>In computer science, functional programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that each return a value, rather than a sequence of imperative statements which change the state of the program.


In other words, you can assign variables new values, but existing values cannot change.

A few examples:
```python
# BAD
my_var = {'c': 'value'}
my_var['b'] = 'new_value'
# or 
my_var['c'] = 'new_value

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
 - if you receive a value, you can be sure that it won't change mid-processing because it was modified
 in another thread
 - as a function caller, you can be sure that after calling the function the passed in arguments
 haven't changed and you can use them the same way before calling the function
 - as a function writer, you can do whatever you want with the data, as long as you do not change
 the original value and return results in the new one

As you can see, it reduces surprises and eases the cognitional context load of the programmer as
we do not really need to worry about the state of the entire program but just local state (input)
of the function.

It also there is common expectation that if you call the function with the same arguments, it will
return the same results. However, that is not always the case:
 - reading the same file, with the same filename, might produce a different result if the file was updated
 - calling function that returns current time should return different time during each call
 - etc

These edge cases usually creep in from environment (boundaries with the environment) and a keen
functional practioner could actually work around these by introducing Environment or Context
states but for practical purposes in is more work than it is worth.


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
    c = another_call(c)
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

Now, we now how to write nice "functional" functions. What can we do with that?

In the examples above we had a pipeline that processed just a single value. In most of the cases,
we operate on the lists. Those lists can be anything:
 - lists of lists
 - lists of byte arrays
 - lists of tuples that are made of other objects and other lists
 - etc

but we usually get some kind of list first. In Python, it means a specific type of array-like collection
but in reality we just need some kind of Iterable.


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
this function called `reduce`:

```python
from functools import reduce

#...
x = map(calculate, x)
x = reduce(lambda c, i: c + i, x)
```

Actually, `reduce(lambda c, i: c + i, x)` is the same as
`reduce(operators.add, x)` is equivalent to `sum(x)` on Python,
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

In the part `reduce(accumulate, ...)` you can see that we a calling function, that takes another
function as the argument. To be used in inside `reduce` the `accumulate` function has to satisfy 
the same signature requirements (if such a thing exists in Python at all...) - it takes two arguments
and returns a single value. The first argument and the return value should be (preferably) of the same 
type.

Then, when the time comes, `reduce` will call our supplied function to accumulate the stream of values
into a single value (it will get _reduced_). 
For developer who know their [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming), 
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

so a better example would be a randomizing post-processing function, to, let's say, augment 
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
there are going to be less items downstream:

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
When you start building flows like this, you will soon realize that there are many tricks, you
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

This is especially relevant to data oriented developers, where Functional Programming paradigm
will help immensely to avoid unmaintainable mess.

I haven't properly touched the part where experienced FP developer would start composing functions
but that's for later. Also, I am planning to cover certain "recipes" later.
