# Before 

There have been to many unit tests and way too many mocks

Too focused on generalization.
Worrying too much on whether it will scale and whether it will be exendible - do not worry
about extendability and just refactor it when the time comes.

State was a mess.

First proper shaping was done by:
 * DDD
 * Refactoring
 * Growing Object Oriented Software


# Storing Data

Databases might as well be just a plain text file.

Aggregates are important. Entities are important.

Key-value store is enough for 80% of use cases. Query by prefix - 
CompositeDelegate()

Single entry storage - use Repositories

# Tests

tests are the first class citizen of the code

refactor state construction code constantly

tests only things that you use

test only things that matter

test behavior

break complex things into many separate simple things and
then test simple things

Stop focusing on unit tests

## OOP vs. Functional
Java 8 made lots of functional code in Java possible

pass lambdas everywhere
much more functional

design patterns are relevant as ever
design patters are irrelevant as ever


Prefer immutable data structures

tactical functional programming

reactive programming. it's powerful but can be a royal pain.

currying is sweet


## Forgotten OOP bits
Avoid nulls - use null/default object OR Optional

Use state pattern

Missing Value Objects

Micromanaging objects

## Designing
Keep it stupid simple

Stay away from premature abstractions

Let the use of the code be your north star

SOLID principles are still solid

Law of Demeter

Again - keep code simple

## Practical notes

Write an API test

Make the code work

Defensive programming? Avoid if it is your code. No opinion if it's used by others.


## APIs
Restful interfaces have won over

Do not skip the application layer

Is graphql any good?
