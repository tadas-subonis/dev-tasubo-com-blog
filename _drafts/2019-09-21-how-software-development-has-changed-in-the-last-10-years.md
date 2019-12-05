---
layout: post
title: How my software development has changed in the last 10 years
date: '2019-09-21'
author: Tadas Šubonis
tags:
- software
- programming
modified_time: '2019-09-21'
---


It's a new post to this almost-abandoned blog. I would even say that my inactivity here is a huge missed opportunity.
Despite that
I've been writing a bit elsewhere (Medium, Facebook, LinkedIn, Packt). 

To kick it off, I figured it would be perfect to do overview of how
software development has changed (in my eyes) over the last 10 years.

## Languages
First of all, the most important tool that we use while programming is the programming
language itself. There has been a lot of development in this area in the last 10 years.

Java, one of my main tools, has started evolving again thanks to Oracle (although they have
made some [controversial decisions](https://labs.consol.de/development/2019/02/05/oracle-license-is-the-free-lunch-over.html)).
These days Java has lambdas, modularized structure, streams, and some other cool stuff.

### Python

Python is my current tool of choice for Data Engineering and Machine Learning related tasks. No surprise here. 10 years ago
Python was a language that only students and non-Ruby hipster developers used. In meantime, ML community pushed Python's adoption
through the roof and at the moment it is one of the most popular languages (not only among data guys).

However, it was a bit strange seeing how long the migration to Python 3 took. Until a few years ago, people were still clinging
unto Python 2.7 even though Python 3 had many more features that would make you productive. But I guess async nailed it in the end.

What's bizarre is that still by the end of 2019 Python can't deal with GIL and multithreading is broken, while consumer CPUs have
32 cores.

### JavaScript
I would say that Web Development has been one of the more dynamic fields in the industry.
As I have worked quite a bit as a full stack developer, I am no stranger to JavaScript either. It is more of a hate-love relationship
though. It's amazingly poorly engineered language and people have been trying to get rid of it since way back. Dart, GWT, CoffeeScript,
and now TypeScript are all monuments to that.

In recent years, it looks like Typescript has started winning developer hearts over. I guess I fall into that category too. Having tried
GWT and Dart, I could say that Typescript helped me avoid more of the annoying bits of JavaScript, but it did not hurt my productivity in
terms of interoperability with the rest of JavaScript ecosystem.

JavaScript modernized as well. There are now proper classes, map and reduce functions, const variables and other nice things.
With the help of NodeJS it also got a lot more popular. For better or worse, people have started deploying server-side JavaScript
and MEAN (Mongo-Express.js-Angular-NodeJs) stack got extremely popular at some point in mid 2010s.

### Web Development

Web Development deserves some special attention. Last 10 years transformed web from semi-document and semi-application network to a 
full fledged application platform.

Progressive Web Apps, Web Components, and Service Workers are all the rage now. 
10 years ago people still struggled with IE6 and were just getting
 a hang of AJAX requests. AngularJS was just coming out and had to compete with BackboneJS. Both tools were horrible and difficult 
to use but it was still better than plain JavaScript. Strange times.

JavaScript and Web Community went a bit crazy (in a good sense) during that time. They've invented GraphQL, React
 (and then React Native), AngularJS transformed into Angular. Dart appeared and died. Then appeared again.

People invented/adopted Webpack, Redux, and Sagas. Even today, the pace of the ecosystem is so extreme, that if you do not update
dependencies of a project for a year, it will break apart completely, when you do. It might be far from ideal maintenance-wise but 
it fuels the innovation. 

Electron now allows to build and distribute desktop-web applications and lots of companies now have a shared code-base for their web, mobile,
and desktop platforms.

However, knowledge needed to build a big and performant web-based applications has exploded as well. You have to know most of the stuff
above to deliver a non-trivial application. In the old days, you had to just know a bit of jQuery and DOM.

### .NET
I haven't done any work with .NET platform but it deserves a special mention.
C# and its platform are now Open Source. 10 years ago people would not have believed that it would be possible. 
Mono project was struggling to get adoption and there were no dreams about getting a full .NET platform on Linux.

To fully appreciate the magnitude of the change you have to remember that Microsoft once called OpenSource (Linux) a cancer.

## Tooling
No developer can work without their IDE. Over the last 10 years, two main trends become apparent:

 * IntelliJ (and its platform) is a leader
 * power editors are now in the game

I used to be a big fan of Netbeans but now old-guard IDEs such as Eclipse and Netbeans are pretty much dead.
IntelliJ and friends took everything over. IntelliJ has an IDE for every language that you might want, and if they do not - 
there is a plug-in.

Also, a new wave of power editors such as Sublime, Atom, and Visual Studio Code stand strong with those who feel
that they want to stick with leaner tools. Visual Studio Code has gotten the edge in the last few years.


## DevOps
It turned out so that I've always had to do a fair share of operational/infrastructure work.

Quite a bit of changed in DevOps and infrastructure related work as well. I can still remember running
production server on Gentoo Linux for an e-shop and several other co-hosted websites in 2008. This
experience led me to avoid running my own infrastructure
as it is quite attention intensive business.

Luckily, I wasn't alone and a lot of infrastructure moved to the cloud.

### Cloud
10 years ago you could get either a dedicated server or a shared-hosting solution. AWS was far from its
prime and Google offered only a crappy App Engine solution.

These days getting any kind of server is super easy. You can get a server provision for you in a matter
of minutes and that can be completely scripted.

Infrastructure-as-a-code is now possible. Ansible and Chef help a lot here. Immutable infrastructure is 
now a thing. 
Compared to the old days, when rogue updates to the OS could kill the service, this is complete pleasure
to work with.

Also, there is no need to keep nagging administrators (SysAdmins) to get you a server with a 
right flavor of Linux and Apache installed. Developers can do that themselves and SysAdmins might just 
enforce some networking-firewall rules.


### Managed Databases
What's better than cloud servers? Cloud services. Managed databases became a thing. These days you can get 
any type of database (MSSQL, MySQL, MongoDB and etc...) in the cloud, and you won't have to worry about 
setting it up, scaling, managing backups.

It is extremely convenient and time saving. Obviously, some people might still want to do that manually to
squeeze out extra performance and savings, but it is no longer necessary. In my experience, the worst screw
ups that services experience are due to failures operating the database.

Managed internet-scale managed databases deserve some extra attention. I believe that the first one to
appear was Google Datastore (as a part of App Engine) in the late 2000s. Later, DynamoDB, Azure Table Service,
and CosmosDB followed. These services introduced automatic scaling, granular charges for the operations,
and virtually unbounded capacities. Personally, I believe that these services had huge consequences on
how we develop things. If you had a low volume service, you could get away by not paying anything for the database.
However, you could get punished severely for missing N+1 query on a high-traffic website.

### Containers
Probably one of the biggest changes happened in 2014 when (Docker) containers became prominent in the industry.
While some people seemed to use it as a facilitator for a reproduceable development environment, I think
containers are an ultimate way to package applications. 

JAR, WAR, EAR got somewhat halfway there as you could PROBABLY run your application on an application server given
that you included all the dependencies. But Docker was the next step - it included all of the OS so your application
could run without fixing libc, java, and libssl-dev versions. Basically, package once - run anywhere was achieved.

There were quite a few nice operational benefits as well - it became much easier to enforce CPU and Memory limits
on applications, security was improved, and logging with monitoring became arguably simpler.


### Container Orchestration
Together with containers another shift has occurred - developers have started building microservices. Before
2010 Service Oriented Architecture (SOA) was gaining traction but with the advent of containers, microservices
became possible and it took it over from SOA.

While people where crazy building microservices, they soon realized that they need some tools to manage the 
containers. So people started building tools for container orchestration.

One of the first attempts to do that came from CoreOS with fleetd and etcd. As one of the early adopters back
in the 2014, I would like that it was smooth journey but... I can't. In the beginning, there were lots of parts 
that were missing or just too simplistic- service discovery, smooth failovers, logging, persistent volumes. Later,
Docker Swarm, Rancher, Mesos, DCOS appeared. However, by the end of 2018, it became clear Kubernetes is the
winner.

Having used CoreOS and Docker Swarm, I must say that Kubernetes made lots of things possible (and easy) but also
it is a tool with a steep learning curve. For a novice, it is far from simple for deploying their first application
and especially making it ready for production. And, if you can't use a managed Kubernetes service such as GKE or
AKS, you are out-of-lock, as deploying your own cluster is even more complicated (but it is getting easier especially
with k3s and the likes).

## Data Engineer and Machine Learning
For the later half of the decade I was involved in data and machine learning engineering (and during the first half I was
only an aspirer). The amount of changes that occurred here deserves a post of its own but I'll try to summarize it here anyway.

### Neural Networks
This field just exploded. In 2010 people were doing just regular dense multi-layer perceptrons that could process only 2D arrays
(feature vector + batch). All of the training was being done on CPUs. Even when 
[https://arxiv.org/abs/1301.3781](Tomas Mikolov) released Word2Vec, it was trained on the CPUs. 
Only crazy 
people like [https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks.pdf](Alex Krizhevsky) 
would implement
training on the GPU using C\C++ with CUDA.

But Alex's paper was the breakthrough. It showed that Deep Neural Networks are feasible (again). Later, people picked up tools such as
Theano to help them with neural net training. By the end of the decade Theano was dead
and we had tools such as Tensorflow and PyTorch. Now they are
being used to train [https://arxiv.org/abs/1810.04805](BERTs), [https://arxiv.org/abs/1410.5401](Neural Turing Machines), and beat [https://deepmind.com/blog/article/alphastar-mastering-real-time-strategy-game-starcraft-ii](Starcraft).


### Python again
Data analysis and engineering changed a lot as well. Before, there was only numpy and matplotlib. Quite a few 
academics used R; some outcasts used Weka and Rapidminer.

However, quite quickly Python and friends took everything over. Jupyter, Pandas and Scikit became tools of everyday data
analyst/scientist/engineer. Analysis and machine learning brainstorming that used to take weeks now takes only a few days.

### Data Engineering
At the start of the decade, the only tool that people used was Hadoop and MapReduce. Take a bunch of distributed data, process it,
and put the results back in the same distributed database. Rinse and Repeat.

These days we have a much wider selection of tools. For starters, Apache Hadoop (and friends) ecosystem grew immensely and 
now we have:
 * Apache Pig - for SQL-like queries on Hadoop
 * Apache HBase - columnar storage on Hadoop
 * Apache Hive - SQL-like database on Hadoop
 * Apache Kafka - scalable queue service
 * Apache Spark - pipeline for distributed data processing
 * more...

Lots of these services have now managed alternatives in the cloud (Google BigQuery, Google Dataproc, Amazon Redshift) so you wouldn't 
need to worry setting everything up. However, you might need to commit to storing data on S3 or some other Block storage for cloud alternative.

Some other prominent tools propped up in Python ecosystem such as Airflow and Dask that can make your life easier.

### Other models
It looks like probabilistic (Bayesian) models are starting to pick up again. Using PyMC it is extremely easy to create and
prototype models. Pyro makes it easy to scale your probabilistic learning on GPUs.

I am not familiar with the state of MCMC in R ecosystem at the start of the decade but it seems they had some decent tools available. 
However, if I recall correctly, most of the software (samplers and models) where either custom build in-house or used specialized software.

Also, it seems that MCMC approaches completely took over other inference methods due to its simplicity and scalability. I've never heard using
[https://en.wikipedia.org/wiki/Belief_propagation](Message-passing) anymore and [https://arxiv.org/abs/1601.00670](Variational Inference) is not that popular either.

# Outro
It was a mouthful. Quite a bit has happened. What are the things that you've noticed?
In the next post, I'll share how my programming practices have changed (hopefully for better).