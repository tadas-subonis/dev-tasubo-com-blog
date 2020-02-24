This is continuation of the first part but while in the later I've 
focused more on the whole industry, this time I'll try to reflect
on how my own software development practices changed overtime.

If I had to point out one common pattern that I _try_ to 
adhere to, that would be "just make it simple. Make simple everything:
your code, your CI, DevOps. You can't be bother by worrying over
every little thing.


# Writing Code
I write a bit less code these days than I've used to 5 years ago but it's an activity
that still takes majority of my time.

## Design: Keep It Stupid Simple
One important piece of advice that I can share is to not make code complicated. Make it easy to read.
Make it easy to understand.

I believe that all of the [SOLID](https://en.wikipedia.org/wiki/SOLID)
advice boils down to keeping it simple so if you want to take a shortcut here, it's really easy - 
just do no try to outsmart yourself and your colleagues.

For example, when [Law of Demeter](https://wiki.c2.com/?LawOfDemeter) is broken
```java
param1.getA().getB().getC(),
```
you can see right away that a simpler version ```paramC``` could be passed instead and automatically you
start following LoD (while we are here, I'll add a note that passing [Aggregate](https://www.martinfowler.com/bliki/DDD_Aggregate.html)
is still OK).

### Make it easy to read and understand

Most likely, your code is gonna be written once and read many many times. So do not skimp on proper structure,
variable and function naming.

So instead of

```python
elem = object[2]
```

do 

```python
thirdPlayerInfo = recentlyVisitedPlayers[2]
```

Unless it's specific scientific or well-defined domain shorthand for a variable (like ```v = velocity```), always prefer the longer name.

### Premature Design

Stay away from premature abstractions. I'll expand on prototyping 
later but [premature optimization](https://wiki.c2.com/?PrematureOptimization)
is root of all evil. I believe this hold the same for software design as well.

You have to understand that before you start coding and get your hands dirty (with code and business knowledge)
you are not qualified to make sound design desitions. So instead of shooting yourself in the foot, leave yourself
some flexibility by just implementing the simplest approach that works (that's a heuristic that works surprisingly
well).

That holds true for code (de)duplication as well. Sometimes it's just a simple string formatter that you can see
that will be used in many different places so it's natural to get it extracted. Sometimes it's a part of the process
that guides some other thing. Things are not so obvious in these cases and straightforward deduplication will
turn out to be a pain in the ass to maintain as you will start adding some boolean flags and parameters.

Some code might appear to do the same initially but later you will find that actually the process is different and 
unique. However, now you are stuck with "generalized" solution that isn't general nor easy to work with.

Quite often people go really crazy with **extends** and generics only to wind up with a code that's 
impossible to work with and doesn't bear any similarity to the domain.



### Avoid inheritance
After spending my fair share amount of time debugging some convoluted inheritance trees with more than appropriate uses
of [Template (anti-)pattern](https://en.wikipedia.org/wiki/Template_method_pattern), I came to prefer 
[Composition-over-Inheritance]
(https://thoughtbot.com/blog/reusable-oo-composition-vs-inheritance). You get more code duplication by adding all of those
delegation methods, but the straightforwardness, flexibility, and peace of mind that you are not breaking anything, more
than compensates for that.


### Avoid generics
They can get complex really fast if you don't keep them in check. You might say "But hey, I am developing a lock-free
collections library. I can't do without generics!". That's a fair use case - go ahead. However, if you in the process of writing some general
data abstraction layer that "can be used by other teams as well", I have bad news for you. You gonna be lucky if actually anybody else
besides you reads that code and there is no need to commit to generics if you can avoid them.

In a nutshell, you don't really want to end up with something like this:

```java
public abstract class AbstractMessageLite<
    MessageType extends AbstractMessageLite<MessageType, BuilderType>,
    BuilderType extends AbstractMessageLite.Builder<MessageType, BuilderType>>
        implements MessageLite
```        

In reality, this is just another example of "avoiding premature optimization".


## Tactical Functional Programming
Java 8 made lots of functional code in Java possible

pass lambdas everywhere
much more functional

design patterns are relevant as ever
design patters are irrelevant as ever


Prefer immutable data structures

tactical functional programming

reactive programming. it's powerful but can be a royal pain.

currying is sweet


## Start with tests and then prototype


## Tests are the first-class part of your codebase

## Refactor often



### More OOP
I've found myself using why more objects and classes. Every time there is a new concept, I try to introduce a class for it. 

For example, if there is a specific format for a player ID, then create it. Next time you use it in the Map, you won't confuse it:

```java
Map<PlayerId, Player> idToPlayer = Maps.newHashMap();
```

And now, instead of upsetting your production environment with some random string, you will make the compiler complain about that right away.
Additionally, you will be able to add validation "for-free" just by updating the constructor.

Also, whenever I feel that I want to create a private method, I always consider if it should be a separate class instead.
Lots of private methods is a strong smell that your classes are trying to do too much.

### Avoid null ###
[Somebody](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/) called "null" the billion dollar mistake.
These days I wholeheartedly agree with that. Avoid them by using 
[Optional](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) (most of the [modern](https://doc.rust-lang.org/std/option/)
 languages have similar alternatives)
or [Null-Object](https://sourcemaking.com/design_patterns/null_object).



## My database is just a detail

Databases might as well be just a plain text file.

Aggregates are important. Entities are important.

Key-value store is enough for 80% of use cases. Query by prefix - 
CompositeDelegate()

Single entry storage - use Repositories


##

# DevOps

## Avoid Databases

## Avoid Servers

## APIs
Restful interfaces have won over

Do not skip the application layer

Is graphql any good?
## 



# Tests

tests are the first class citizen of the code

refactor state construction code constantly

tests only things that you use

test only things that matter

test behavior

break complex things into many separate simple things and
then test simple things

Stop focusing on unit tests


## Designing

## Practical notes

Write an API test

Make the code work


