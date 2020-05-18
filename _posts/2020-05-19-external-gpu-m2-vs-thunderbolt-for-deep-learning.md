---
layout: post
title: "External GPU: M2 vs Thunderbolt for Deep Learning and Gaming"
date: '2020-05-19'
author: Tadas Šubonis
tags:
- egpu
- gpu
- rtx2080ti
- cuda
- deep learning
---

# Intro
A while ago I've wanted to bump up non-existing gaming and deep learning capabilities of [my workstation](#my-workstation).
Since it's a laptop, I've started looking into getting an external GPU. That's quite a convenient option -
you get a still portable machine that can hook into a beefy GPU when you are working in your regular
place.

This required quite a bit of research and the expected performance wasn't entirely clear (especially for 
deep learning related tasks) so after going through all at trouble I've decided to write up some of my experiences and 
things I've noticed.

Do not expect really sophisticated insights or benchmarks here but I hope that it's going to help you
build the intuition about the expected eGPU performance.

# External GPUs
The most common type of eGPU uses Thunderbolt 3. It's easy to connect  and its 40Gbps bandwidth provides
a decent performance so you could actually make use of that GPU.

There are [lots of eGPUs](https://egpu.io/best-egpu-buyers-guide/) available to choose from. I went with 
[Razer Core X](https://www.razer.com/eu-en/gaming-laptops/razer-core-x)
as it:
 - is relatively compact
 - has no external ports (a GPU won't have to share Thunderbolt bandwidth)
 - has a beefy PSU to support [RTX 2080 Ti](https://wccftech.com/review/gigabyte-geforce-rtx-2080-ti-gaming-oc-graphics-card-review/)


The only trickery that I had to do here was to do a complete and clean uninstall of NVIDIA Quadro drivers using
[DDU](https://www.guru3d.com/files-details/display-driver-uninstaller-download.html) and then installing regular
GeForce drivers. The only annoying thing after connecting Core X is that you can't have the internal-dedicated
GPU (M1000M) running because that will cause the fans on the GPU that's inside eGPU to go on a full blast.

Disabling M1000M using Device Manager and restarting the system helped here.

# My Workstation
It's a HP zBook G3 15" Laptop that has a dedicated **Quadro M1000M GPU**. Back in 2017 it was a decent mobile 
powerhorse but these days I would really like to get one of those Ryzen CPUs.

It has **Intel(R) Core(TM) i7-6820HQ CPU @ 2.70GHz 4C/8T** and **32GB DDR4 RAM**. Where this laptop excels
is its extensibility options: you can add additional drive, express card, and there are two M2 slots available
for another NVME drive or something else.

Also, it has a decent Thunderbolt 3 support and its PCI Express lane is not shared with other devices (AFAIK).

If you are interested to learn a bit more about the it, you can take a look at the review [here](https://www.notebookcheck.net/HP-ZBook-15-G3-Workstation-Review.162600.0.html).
You might want to take a note, that the reviewed laptop has **Quadro M2000M** and can get **3820 score on Firestrike**.

For the eGPU tests, I've used [Gigabyte Windforce RTX 2080 Ti](https://wccftech.com/review/gigabyte-geforce-rtx-2080-ti-gaming-oc-graphics-card-review/).

# M2 Options
Another option is to connect your eGPU to PCI-Express "directly" using something like [this](https://www.aliexpress.com/item/4000127931314.html).

![M2 + PSU](/assets/images/egpu-m2-thunderbolt/photos/m2_riser_psu.jpg "M2 Riser + PSU")

I got this setup after I've mistakenly thought that my Core X got busted. In the end, the fault was at
the active Thunderbolt cable. Hey, but I got to play around with the fancy M2-based setup.

You have to get an external PSU together with the riser above to make it work. Also, as you can probably guess
it is not as convenient as a Thunderbolt option as you have to remove a bottom cover (or make some kind of other
access) to the M2 connector on the motherboard. That's not something you want to plug and unplug everyday 
but it's not really a big deal.

However, apparently this has some 
[nice performance benefits](https://egpu.io/forums/builds/2015-15-dell-precision-7510-q-m1000m-6th4ch-gtx-1080-ti-32gbps-m2-adt-link-r43sg-win10-1803-nando4-compared-to-tb3-performance/) 
(or [this](https://egpu.io/forums/mac-setup/pcie-slot-dgpu-vs-thunderbolt-3-egpu-internal-display-test/)
) as there is no overhead of carrying the PCI Express
data over Thunderbolt.

![M2](/assets/images/egpu-m2-thunderbolt/photos/m2_connected.jpg "M2")

The whole M2 setup might look a bit strange (or cool) depending on how you judge.

### Driver Issues
Connecting eGPU via M2 is far from ideal experience. First of all, the default installation of drivers won't work and you will be greeted by error 43 after
installing the drivers. You will find instructions [here](https://egpu.io/forums/expresscard-mpcie-m-2-adapters/script-nvidia-error43-fixer/) how to deal with that.

Apparently, this happens because NVidia checks if M2 connector [is marked as hotplugable](https://egpu.io/error-43-fix-non-hotplug-mpciengffm-2-egpu-interfaces-nvidia-gtx10xx-cards/) or not.

Basically, if HWInfo shows something like 

![non-hotplugable](/assets/images/egpu-m2-thunderbolt/photos/not_hot_plugable_pci_express.jpg "Nope")

instead of 

![hotplugable](/assets/images/egpu-m2-thunderbolt/photos/hot_plugable_pci_express.jpg "Nope")

you will have to do run a magical script to fix that for you (I keep wondering how it works :/).

Finally, you can't standby the system. I am not sure what happens but it would seems that there is an unexpected power issue when the system
resumes from standby and it panics when there is no GPU  powered/connected (yet). There is a chance that this might not happen if the eGPU is
connected to M2 port that support hot plugging.

### Power Issues
This specific ADT-Link device had [some trouble](https://egpu.io/forums/expresscard-mpcie-m-2-adapters/mpcieecngff-m2-resolving-detection-bootup-and-stability-problems/)
 running  RTX 2080 Ti. On some specific heavy loads (e.g. Firestrike or Deep Learning tasks)
the eGPU would just disconnect and (sometimes) crash your system. Not cool. Apparently, this is a know problem and the mitigation is as follows

> This can be either a PSU or video card stability issue with the factory settings which may be clocked beyond what the components can handle. For the latter, downclock your video card by 15% - core/mem/target power using > MSI Afterburner. If the problem persists, then swap your PSU for a known good one and test again.

After dropping memory and core clocks by 200Mhz and the whole power by 20%, I've managed to run it without issues. 
I've also connected one of the power cables directly to PSU instead of 
supplying all of the power to the GPU via ADT-Link. However, that's far from optimal as you are basically losing
performance that you were hoping to get using M2 connection. Later, I'll refer to this as "Downclocked" in the
benchmarks.

I haven't tried another PSU or changing the power cords entirely.

# Benchmarks
I've tried collecting a set of benchmarks that would allow making some useful comparisons against other systems. However, since the current CPU of the system
is a bit limpy compared to modern desktop workhorses, it mostly makes sense to compare these results between to see wh Thunderbolt and M2 connections

Also, I hope that Deep Learning practitioners are going to get some useful hints of what they can expect from an eGPU-based setup compared to proper desktop
machines ([here](https://lambdalabs.com/blog/2080-ti-deep-learning-benchmarks/) or [here](https://timdettmers.com/2019/04/03/which-gpu-for-deep-learning/)).

## External vs Internal Screen
First of all, there is a difference in how you connect your screens to your eGPU. If you are using the internal laptop display, you can expect to lose
some performance compared to using an external display that's connected to the eGPU directly.

### 3Dmark Core X

![Firestrike Core X](/assets/images/egpu-m2-thunderbolt/firestrike_core_x.png "Firestrike Core X")

You can see 15% drop in terms of graphics score between internal and external screens. Below, the difference
between TimeSpy benchmarks is not that high - ~7%;

![TimeSpy Core X](/assets/images/egpu-m2-thunderbolt/time_spy_core_x.png "TimeSpy Core X")

However, overall, it is an extremely sweet improvement over M1000M because I am getting **~15k scores instead 
of 3820** (M2000M - unfortunately I have not made any benchmarks using my own M1000M).

### 3Dmark M2
Something similar can be observed using M2

![Firestrike M2](/assets/images/egpu-m2-thunderbolt/firestrike_m2.png "Firestrike M2")

![TimeSpy M2](/assets/images/egpu-m2-thunderbolt/time_spy_m2.png "TimeSpy M2")

You can also see that M2 can perform up to 20% faster compared (comparing Graphics Score only) to the Thunderbolt connection:


![Thunderbolt M2](/assets/images/egpu-m2-thunderbolt/thunderbolt_vs_m2.png "Thunderbolt M2")


### Superposition and Kombustor
I've also made some runs using Superposition and Kombustor if somebody were to look for those:

![Benchmarks Core X](/assets/images/egpu-m2-thunderbolt/other_benchmarks_core_x.png "Benchmarks Core X")

You can see 15% drop in terms of graphics score between internal and external screens. Below, the difference
between TimeSpy benchmarks is not that high - ~7%;

![Benchmarks M2](/assets/images/egpu-m2-thunderbolt/other_benchmarks_m2.png "Benchmarks M2")

## 4K
In case you are interested in the performance of 4K:

![4K](/assets/images/egpu-m2-thunderbolt/4k.png "4K")

You can see that the downclocking makes M2 perform worse than Thunderbolt. If not for those power issues,
M2 would probably perform here better too.

## AI Benchmark
There aren't many options to choose from when benchmarking Deep Learning libraries. One quite decent option 
is [AI Benchmark](http://ai-benchmark.com/alpha.html). The test runs on Tensorflow 1.x or Tensorflow 2.x and 
basically test the inference and training speed of the most popular neural network architectures.

I wasn't able to run the full testsuite on non-downclocked M2 but the initial runs might give some insight:

![AI Benchmark individual runs](/assets/images/egpu-m2-thunderbolt/ai_benchmark_raw.png "AI Benchmark individual runs")

Overall score comparison for the downclocked version (so the test would complete) can be seen below:

![AI Benchmark](/assets/images/egpu-m2-thunderbolt/ai_benchmark_scores.png "AI Benchmark")

If you were to compare that with a [public ranking](http://ai-benchmark.com/ranking_cpus_and_gpus.html), you would
see that using my system we are getting a petty ~20k scores instead of 32k that some people have reported.


In most of the cases for individual tests of AI Benchmark I've found that the performance is similar
between Thunderbolt and M2 except for NLP/RNN related tasks:


![AI Benchmark NLP](/assets/images/egpu-m2-thunderbolt/ai_benchmark_nlp.png "AI Benchmark NLP")

For example, *Pixel-RNN* training can be ~20% faster via M2 while *GNMT-Translation* inference is 23% faster.

## PyTorch
I've also wanted to test some PyTorch code as well because that's the framework I mainly use. Unfortunately, I could 
not find a decent testing framework so I've run [pytorch-examples](https://github.com/pytorch/examples).

For most of the examples it was quite difficult to get the data or I've ran into other issues while testing (like forgetting to
use `--cuda` :( ). In the end, I've managed to procure benchmarks for MNIST and LSTM language model examples. The results can be
seen below:

![PyTorch Core X](/assets/images/egpu-m2-thunderbolt/pytorch_core_x.png "PyTorch Core X")

![PyTorch M2](/assets/images/egpu-m2-thunderbolt/pytorch_m2.png "PyTorch M2")

As you can see, DL workloads really like M2 and having the whole GPU to themselves (no external monitor that's connected directly
to eGPU). It would seem, that if you are running RNN models, you could almost gain an improvement of ~28% if you stick with M2.

## PCI Bandwidth
Finally, I've made some PCI Bandwidth benchmarks using 3Dmark.

![PCI Benchmark](/assets/images/egpu-m2-thunderbolt/pci_benchmark.png "PCI Benchmark")


# Concluding Remarks
I am really glad that I got eGPU as it allowed me to do some proper 2x4K screen setup and substantially improved gaming experience. For deep learning stuff, I could 
use M1000M to test if the code runs locally and the run it on the server so it wasn't that of a big deal. 

Nevertheless, it's really awesome when you can
run some learning tasks really fast (~2-5min) instead of 30-50min as before. This helps a lot
when you are trying to figure out why the net is not converging and you would like to do a lot 
of iterations.

If you are interested in a bit more detailed numbers, 
I've included all of the original data in a [spreadsheet](https://docs.google.com/spreadsheets/d/1eh7y51NT4wkBaCouUottNSAFWZlZXSWQt-fFXaksPwU/).

The use of M2 vs Thunderbolt really depends on your preferences. If you are not moving around that much with your laptop and if you really care
about the performance, then M2 might seem like a really solid choice.

However, if you are more of a practical fellow, then it's really hard to beat Thunderbolt as the performance loses are rather tiny
but the setup is a lot more straightforward. I, personally, will be sticking with Core X.

