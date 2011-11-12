package org.kuali.maven.mojo.s3.threads;

import java.lang.Thread.UncaughtExceptionHandler;

import org.kuali.maven.mojo.s3.ProgressTracker;

public class ThreadHandler implements UncaughtExceptionHandler {

    ThreadGroup group;
    Thread[] threads;
    Throwable exception;
    boolean stopThreads;
    int requestsPerThread;
    int threadCount;
    ProgressTracker tracker;

    public ThreadGroup getGroup() {
        return group;
    }

    public void setGroup(ThreadGroup group) {
        this.group = group;
    }

    public Thread[] getThreads() {
        return threads;
    }

    public void setThreads(Thread[] threads) {
        this.threads = threads;
    }

    public void executeThreads() {
        start();
        join();
    }

    protected void start() {
        for (Thread thread : threads) {
            thread.start();
        }
    }

    protected void join() {
        try {
            for (Thread thread : threads) {
                thread.join();
            }
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public synchronized void uncaughtException(Thread t, Throwable e) {
        this.stopThreads = true;
        group.interrupt();
        this.exception = new RuntimeException("Unexpected issue in thread [" + t.getId() + ":" + t.getName() + "]", e);
    }

    public Throwable getException() {
        return exception;
    }

    public synchronized boolean isStopThreads() {
        return stopThreads;
    }

    public int getRequestsPerThread() {
        return requestsPerThread;
    }

    public void setRequestsPerThread(int requestsPerThread) {
        this.requestsPerThread = requestsPerThread;
    }

    public int getThreadCount() {
        return threadCount;
    }

    public void setThreadCount(int threadCount) {
        this.threadCount = threadCount;
    }

    public ProgressTracker getTracker() {
        return tracker;
    }

    public void setTracker(ProgressTracker tracker) {
        this.tracker = tracker;
    }
}
