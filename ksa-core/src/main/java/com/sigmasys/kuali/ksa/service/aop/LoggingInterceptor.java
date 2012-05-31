package com.sigmasys.kuali.ksa.service.aop;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.lang.reflect.Method;

/**
 * Logging interceptor. Works with Apache commons logger.
 *
 * @author Michael Ivanov
 */
public class LoggingInterceptor implements MethodInterceptor {

    private final Log logger = LogFactory.getLog(getClass());

    private Object targetObject;

    public LoggingInterceptor() {
    }

    public LoggingInterceptor(Object targetObject) {
        this.targetObject = targetObject;
    }

    public void setTargetObject(Object target) {
        this.targetObject = target;
    }


    public Object invoke(MethodInvocation invocation) throws Throwable {
        Method targetMethod = invocation.getMethod();
        for (Method method : targetObject.getClass().getMethods()) {
            if (methodsMatch(targetMethod, method)) {
                Object result = invocation.proceed();
                log(invocation);
                return result;
            }
        }
        return invocation.proceed();
    }

    private boolean methodsMatch(Method method1, Method method2) {
        if (!method1.getName().equals(method2.getName())) {
            return false;
        }
        Class<?>[] paramTypes1 = method1.getParameterTypes();
        Class<?>[] paramTypes2 = method2.getParameterTypes();
        if (paramTypes1.length != paramTypes2.length) {
            return false;
        }
        for (int i = 0; i < paramTypes1.length; i++) {
            if (!paramTypes1[i].getName().equals(paramTypes2[i].getName())) {
                return false;
            }
        }
        return true;
    }

    private void log(MethodInvocation invocation) {

        Method method = invocation.getMethod();
        String className = method.getDeclaringClass().getSimpleName();
        Object[] arguments = invocation.getArguments();
        Class<?>[] paramTypes = method.getParameterTypes();

        StringBuilder logBuffer = new StringBuilder("Performed method call: ");
        logBuffer.append(className);
        logBuffer.append(" :: ");
        logBuffer.append(method.getReturnType().getSimpleName());
        logBuffer.append(" ");
        logBuffer.append(method.getName());
        logBuffer.append("(");

        for (int i = 0; i < arguments.length; i++) {
            if (i > 0) {
                logBuffer.append(", ");
            }
            logBuffer.append(paramTypes[i].getSimpleName());
            logBuffer.append(" '");
            logBuffer.append(arguments[i]);
            logBuffer.append("'");
        }
        logBuffer.append(")");

        logger.info(logBuffer.toString());

    }

}


