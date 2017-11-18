---
layout: post
title: Writing maintainable tests - basics
date: '2013-04-23T15:30:00.000-07:00'
author: Tadas Šubonis
tags:
- unit tests
- test driven development
- tdd
- testing
- junit
modified_time: '2013-04-24T03:17:11.593-07:00'
blogger_id: tag:blogger.com,1999:blog-8984970032050788710.post-2040547834194563506
blogger_orig_url: http://dev.tasubo.com/2013/04/writing-maintainable-tests-basics.html
---
  

Recently, when I attended [Adopt OpenJDK test fest](http://dev.tasubo.com/2013/03/adopt-openjdk-test-fest.html), 
I found good examples of test writing cases how NOT to do it. After that I decided that I would like to write a 
simple guide about how to write maintainable tests. 

If you haven't been writing tests already... well let's just say that you should do so. 
I am pretty sure that there are [lots](http://blog.approvaltests.com/2009/06/parts.html) 
[of](http://msdn.microsoft.com/en-us/magazine/cc163665.aspx) [literature](http://www.codinghorror.com/blog/2006/07/i-pity-the-fool-who-doesnt-write-unit-tests.html) [about](http://java.dzone.com/articles/unit-test-excuses) [that](http://www.onjava.com/pub/a/onjava/2003/04/02/javaxpckbk.html) topic. One thing that beginner test writers ignore is that they should pay the same 
attention and importance to tests as the actual code that tests are supposed 
to check. By not following this simple advice, you will get into cases when 
understanding test is almost impossible and changes required to be made in 
code are very hard to reflect in test. As an example, I am going to show 
this simple test from [OpenJDK](http://openjdk.java.net/) which is 
supposed to check thread pools' functionality:

{% highlight java %}
import java.util.concurrent.*;

public class CoreThreadTimeOut {

    static class IdentifiableThreadFactory implements ThreadFactory {
        static ThreadFactory defaultThreadFactory
                = Executors.defaultThreadFactory();

        public Thread newThread(Runnable r) {
            Thread t = defaultThreadFactory.newThread(r);
            t.setName("CoreThreadTimeOut-" + t.getName());
            return t;
        }
    }

    int countExecutorThreads() {
        Thread[] threads = new Thread[Thread.activeCount()+100];
        Thread.enumerate(threads);
        int count = 0;
        for (Thread t : threads)
            if (t != null &&
                    t.getName().matches
                            ("CoreThreadTimeOut-pool-[0-9]+-thread-[0-9]+"))
                count++;
        return count;
    }

    long millisElapsedSince(long t0) {
        return (System.nanoTime() - t0) / (1000L * 1000L);
    }

    void test(String[] args) throws Throwable {
        final int threadCount = 10;
        final int timeoutMillis = 30;
        BlockingQueue<Runnable> q
                = new ArrayBlockingQueue<Runnable>(2*threadCount);
        ThreadPoolExecutor tpe
                = new ThreadPoolExecutor(threadCount, threadCount,
                timeoutMillis, TimeUnit.MILLISECONDS,
                q, new IdentifiableThreadFactory());
        equal(tpe.getCorePoolSize(), threadCount);
        check(! tpe.allowsCoreThreadTimeOut());
        tpe.allowCoreThreadTimeOut(true);
        check(tpe.allowsCoreThreadTimeOut());
        equal(countExecutorThreads(), 0);
        long t0 = System.nanoTime();
        for (int i = 0; i < threadCount; i++)
            tpe.submit(new Runnable() { public void run() {}});
        int count = countExecutorThreads();
        if (millisElapsedSince(t0) < timeoutMillis)
            equal(count, threa  dCount);
        while (countExecutorThreads() > 0 &&
                millisElapsedSince(t0) < 10 * 1000);
        equal(countExecutorThreads(), 0);
        tpe.shutdown();
        check(tpe.allowsCoreThreadTimeOut());
        check(tpe.awaitTermination(10, TimeUnit.SECONDS));

        System.out.printf("%nPassed = %d, failed = %d%n%n", passed, failed);
        if (failed > 0) throw new Exception("Some tests failed");
    }

    //--------------------- Infrastructure ---------------------------
    volatile int passed = 0, failed = 0;
    void pass() {passed++;}
    void fail() {failed++; Thread.dumpStack();}
    void fail(String msg) {System.err.println(msg); fail();}
    void unexpected(Throwable t) {failed++; t.printStackTrace();}
    void check(boolean cond) {if (cond) pass(); else fail();}
    void equal(Object x, Object y) {
        if (x == null ? y == null : x.equals(y)) pass();
        else fail(x + " not equal to " + y);}
    public static void main(String[] args) throws Throwable {
        new CoreThreadTimeOut().instanceMain(args);}
    public void instanceMain(String[] args) throws Throwable {
        try {test(args);} catch (Throwable t) {unexpected(t);}
        System.out.printf("%nPassed = %d, failed = %d%n%n", passed, failed);
        if (failed > 0) throw new AssertionError("Some tests failed");}
}
{% endhighlight %}

We can clearly see that this is an old school test. I think it was actually written before any of JUnit or TestNG frameworks were present. Lack of testing framework has greatly shaped this test being unreadable. Lets focus on the test itself. It's "test(String[])" method. There are several problems with that code but main one is that we don't know what the code is supposed to test. From the test class name we could guess that it is somehow related to [core thread time out](http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ThreadPoolExecutor.html#allowCoreThreadTimeOut(boolean)) functionality. Also, this test has a bug in it and this is the reason why I initially picked it up.

In test there are main three stages: prepare thing you are going to test, execute code, make assertions on the ending state. There is one optional stage that depends on the thing you are testing - it's "cleanup". There are situations where you may want to release resources or restore environment state (though this would be more likely an [integration test](http://msdn.microsoft.com/en-us/library/aa292128(v=vs.71).aspx)). In the example above there is no clear separation between the three so we should introduce that. Now code could look something like this:

{% highlight java %}
void test(String[] args) throws Throwable {
    /*
     * Prepare
     */
    ThreadPoolExecutor tpe = prepareTestThreadPool(threadCount, timeoutMillis);

    long t0 = System.nanoTime();
    for (int i = 0; i < threadCount; i++)
            tpe.submit(new Runnable() { public void run() {}});

    int count = countExecutorThreads();
    if (millisElapsedSince(t0) < timeoutMillis)
            equal(count, threadCount);

    /*
     * Execute
     * (actually execution started when we started spawning runables,
     * so it is a little bit hard to define boundary but lets put this
     * one here)
     */
    while (countExecutorThreads() > 0 &&
            millisElapsedSince(t0) < 10 * 1000);

    /*
     * Assert
     */
    equal(countExecutorThreads(), 0);

    /*
     * Cleanup
     */
    tpe.shutdown();

    check(tpe.allowsCoreThreadTimeOut());
    check(tpe.awaitTermination(10, TimeUnit.SECONDS));
    System.out.printf("%nPassed = %d, failed = %d%n%n", passed, failed);
    if (failed > 0) throw new Exception("Some tests failed");
}
{% endhighlight %}

Notice that I also moved constants out of test body to reduce "noise". Furthermore, in ThreadPool preparation code I removed irrelevant checks – those checks tested whether we actually were setting pool in correct state which we did so explicitly. If our preparator won't work in correct way the test itself will fail (of course you have to be aware of false positives). After separating state preparation it would be sensible to remove legacy testing code and transition to [TestNG](http://testng.org/doc/index.html). The reason I am using TestNG is that the OpenJDK project is using TestNG as the preferred framework, but in reality it doesn't matter which one you choose. Change itself is quite trivial:

{% highlight java %}
@Test
void shouldRemoveThreadsAfterCoreThreadTimeoutPeriod() throws Throwable {
    ThreadPoolExecutor tpe = prepareTestThreadPool(threadCount, timeoutMillis);

    long t0 = System.nanoTime();
    for (int i = 0; i < threadCount; i++)
            tpe.submit(new Runnable() { public void run() {}});

    int count = countExecutorThreads();
    if (millisElapsedSince(t0) < timeoutMillis)
            assertEquals(count, threadCount);


    while (countExecutorThreads() > 0 &&
            millisElapsedSince(t0) < 10 * 1000);

    assertEquals(countExecutorThreads(), 0);

    tpe.shutdown();
    assertTrue(tpe.allowsCoreThreadTimeOut());
    assertTrue(tpe.awaitTermination(10, TimeUnit.SECONDS));
}
{% endhighlight %}

  
It makes sense to extract preparation and cleanup stages into @BeforeMethod and @AfterMethod handlers to ease code reuse and clarify structure:  

{% highlight java %}
private ThreadPoolExecutor threadPoolExecutor;

@BeforeMethod
void setUp() {
    threadPoolExecutor = prepareThreadPoolExecutor();
}

@AfterMethod
void tearDown() throws InterruptedException {
    threadPoolExecutor.shutdown();
    while (!threadPoolExecutor.isTerminated()) {
        Thread.sleep(20);
    }

    /*
     * Clean up our threadpool
     */
    assertTrue(threadPoolExecutor.awaitTermination(10, TimeUnit.SECONDS));
    threadPoolExecutor = null;
}
{% endhighlight %}



Utilizing framework functionality lets us focus on the test itself instead of how to track failures and display them – now that is being handled by TestNG. Also, after these changes we can see what does the test actually test – thus we rename our test method to expose that knowledge explicitly to “shouldRemoveThreadsAfterCoreThreadTimeoutPeriod”. This step is very important because having readable, easily understandable test intention makes our test act as a documentation. Naming style here isn't really important while it is readable. I am quite used to camelCasing but_you_can_use_other styles, too.

Paying closer attention to the test we can see where the problem resides – after executing threads we are checking for the amount of threads active that we have started but that isn't necessarily the case because some threads could have finished before we make that assertion. Also, that check isn't really relevant to our test – it checks data set up and not state after execution. Furthermore, we can see that this „timeOut“ waiting isn't effective either – on some machines, configurations or loads it could timeout before threads complete. In this case I would introduce [CyclicBarrier](http://docs.oracle.com/javase/1.5.0/docs/api/java/util/concurrent/CyclicBarrier.html) and wait until all threads end. And we should do this in readable way so maintainer would understand what is going on. In the end this test looks like this:

{% highlight java %}
@Test
public void shouldRemoveThreadsAfterCoreThreadTimeoutPeriod() throws Throwable {
    CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

    untilAllThreadsDone.await();

    waitUntilTimeoutOccurs();

    assertEquals(countExecutorThreads(), 0);
}

private CountDownLatch startaBunchOfThreads() {
    final CountDownLatch allThreadsDoneWaiter = new CountDownLatch(threadPoolSize);
    for (int i = 0; i < threadPoolSize; i++) {
        threadPoolExecutor.submit(new Runnable() {
            @Override
            public void run() {
                allThreadsDoneWaiter.countDown();
            }
        });
    }
    return allThreadsDoneWaiter;
}

private void waitUntilTimeoutOccurs() throws InterruptedException {
    Thread.sleep(timeoutMillis * 2);
}
{% endhighlight %}


We have almost fixed the test. The remaining problem is that we only check thread timeout case. What about the case if we aren't expiring threads? That should be checked also if we would like to avoid false positives. Adding this case would do that:

{% highlight java %}
@Test
public void threadsShouldBePresentAfterTimeoutIfWeDontAllowThreadTimeout() throws Throwable {
    threadPoolExecutor.allowCoreThreadTimeOut(false);

    CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

    untilAllThreadsDone.await();

    waitUntilTimeoutOccurs();

    assertEquals(countExecutorThreads(), threadPoolSize);
}
{% endhighlight %}

But we still have uncovered test case – what if we would like them to expire but only after our specified timeout? This code should do that:

{% highlight java %}
@Test
public void threadsShouldBePresentBeforeKeepAliveTimeKicks() throws Throwable {
    CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

    untilAllThreadsDone.await();

    waitBeforeTimeoutOccurs();

    assertEquals(countExecutorThreads(), threadPoolSize);
}

private void waitBeforeTimeoutOccurs() throws InterruptedException {
    Thread.sleep(timeoutMillis / 2);
}
{% endhighlight %}

It's worth noting that I have hidden all „noise“ in private methods at the bottom of the test file. This approach hides helper code from the eyes but it is still easily accessible. I also like private method approach because then if I see duplication I can move that method to separate class that is responsible for that concept, make that method as static and use static imports to easily fix compilation problems. Of course this would only work if you were using Java. In other languages you may have to take another approach but the main concept holds – extract, refactor, reuse. 

#### Conclusion

We covered test transformation from being unreadable and thus unmaintainable to test which describes our functionality. Before that we needed to actually check JavaDoc to understand how that feature behaves but now test itself describes intended functionality so in case something breaks you have documentation straight before your eyes.

In conclusion I would like to emphasize a few points which make tests maintainable:

*   Test are of same importance as the code it tests. Tests are valuable asset that enable change and confidence in your system. Thus all clean code concepts such as [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) should still be followed here. Extract common mocks or stubs. Extract preparation code as builders where appropriate.
*   Separate tests in three stages: prepare objects for testing, execute logic and check state.
*   Make variables and methods self describable – it should be clear from first sight why they are there. Use your test as documentation.
*   All "noise" (code that is irrelevant to test itself) should be hidden. Hide that in private methods or another test objects.
*   Don't make tests complicated – no "for" or "while" loops, no nested checks – all execution and checks should happen in the same method and in plain, linear fashion. This helps to keep flow of the test under control and makes it a lot more understandable

Additional literature:

*   [Test Driven Development](http://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) – classic book. Most of the concepts are now accepted as the _de facto_ standard, but at the time when it was released it was a groundbreaker. Since this book is really short, it is probably still worth reading even if you are familiar with testing already.
*   [Growing Object-Oriented Software Guided by Tests](http://www.growing-object-oriented-software.com/) – great book that shows how to solve problems that arise while using TDD in practical way. Covers entire application development lifecycle using TDD.

<div>

#### Full revamped test



<div class="gistLoad" data-id="5447832">[code]
{% highlight java %}
import java.util.concurrent.*;

import org.testng.annotations.*;
import static org.testng.Assert.*;

public class CoreThreadTimeOut {

    final int threadPoolSize = 10;
    final int timeoutMillis = 30;

    private ThreadPoolExecutor threadPoolExecutor;

    @BeforeMethod
    void setUp() {
        threadPoolExecutor = prepareThreadPoolExecutor();
    }

    @AfterMethod
    void tearDown() throws InterruptedException {
        threadPoolExecutor.shutdown();
        while (!threadPoolExecutor.isTerminated()) {
            Thread.sleep(20);
        }

        /*
         * Clean up our threadpool
         */
        assertTrue(threadPoolExecutor.awaitTermination(10, TimeUnit.SECONDS));
        threadPoolExecutor = null;
    }

    @Test
    public void correctThreadPoolExecutorShouldBeCreated() {
        assertTrue(threadPoolExecutor.allowsCoreThreadTimeOut());
        assertEquals(countExecutorThreads(), 0);
    }

    @Test
    public void threadPoolExecutorShouldBeAbleToChangeCoreThreadTimeoutSetting() {
        threadPoolExecutor.allowCoreThreadTimeOut(false);
        assertFalse(threadPoolExecutor.allowsCoreThreadTimeOut());


        threadPoolExecutor.allowCoreThreadTimeOut(true);
        assertTrue(threadPoolExecutor.allowsCoreThreadTimeOut());

    }

    @Test
    public void shouldRemoveThreadsAfterCoreThreadTimeoutPeriod() throws Throwable {
        CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

        untilAllThreadsDone.await();

        waitUntilTimeoutOccurs();

        assertEquals(countExecutorThreads(), 0);
    }

    @Test
    public void threadsShouldBePresentBeforeKeepAliveTimeKicks() throws Throwable {
        CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

        untilAllThreadsDone.await();

        waitBeforeTimeoutOccurs();

        assertEquals(countExecutorThreads(), threadPoolSize);
    }

    @Test
    public void threadsShouldBePresentAfterTimeoutIfWeDontAllowThreadTimeout() throws Throwable {
        threadPoolExecutor.allowCoreThreadTimeOut(false);

        CountDownLatch untilAllThreadsDone = startaBunchOfThreads();

        untilAllThreadsDone.await();

        waitUntilTimeoutOccurs();

        assertEquals(countExecutorThreads(), threadPoolSize);
    }

    private ThreadPoolExecutor prepareThreadPoolExecutor() {
        BlockingQueue<Runnable> queue = new ArrayBlockingQueue<Runnable>(2 * threadPoolSize);
        ThreadPoolExecutor threadPoolExecutorLocal = new ThreadPoolExecutor(threadPoolSize, threadPoolSize,
                timeoutMillis, TimeUnit.MILLISECONDS,
                queue, new IdentifiableThreadFactory());
        threadPoolExecutorLocal.allowCoreThreadTimeOut(true);
        return threadPoolExecutorLocal;
    }

    private CountDownLatch startaBunchOfThreads() {
        final CountDownLatch allThreadsDoneWaiter = new CountDownLatch(threadPoolSize);
        for (int i = 0; i < threadPoolSize; i++) {
            threadPoolExecutor.submit(new Runnable() {
                @Override
                public void run() {
                    allThreadsDoneWaiter.countDown();
                }
            });
        }
        return allThreadsDoneWaiter;
    }

    private void waitBeforeTimeoutOccurs() throws InterruptedException {
        Thread.sleep(timeoutMillis / 2);
    }

    private void waitUntilTimeoutOccurs() throws InterruptedException {
        Thread.sleep(timeoutMillis * 2);
    }

    static class IdentifiableThreadFactory implements ThreadFactory {

        static ThreadFactory defaultThreadFactory = Executors.defaultThreadFactory();

        @Override
        public Thread newThread(Runnable r) {
            Thread t = defaultThreadFactory.newThread(r);
            t.setName("CoreThreadTimeOut-" + t.getName());
            return t;
        }
    }

    private int countExecutorThreads() {
        Thread[] threads = new Thread[Thread.activeCount() + 100];
        Thread.enumerate(threads);
        int count = 0;
        for (Thread t : threads) {
            if (t != null
                    && t.getName().matches("CoreThreadTimeOut-pool-[0-9]+-thread-[0-9]+")) {
                count++;
            }
        }
        return count;
    }

    private long millisElapsedSince(long t0) {
        return (System.nanoTime() - t0) / (1000L * 1000L);
    }
}
{% endhighlight %}