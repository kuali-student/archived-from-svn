package com.sigmasys.kuali.ksa.service.aop;

import org.aopalliance.aop.Advice;
import org.springframework.aop.framework.Advised;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * AopBeanPostProcessor
 *
 * @author Michael Ivanov
 */
@Service
public class AopBeanPostProcessor implements BeanPostProcessor {

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if (bean instanceof AopProxy) {
            List<Advice> advices = ((AopProxy) bean).getAdvices();
            if (advices != null) {
                Advised advised;
                if (bean instanceof Advised) {
                    advised = (Advised) bean;
                } else {
                    ProxyFactory proxyFactory = new ProxyFactory(bean);
                    proxyFactory.setProxyTargetClass(true);
                    advised = proxyFactory;
                }
                for (Advice advice : advices) {
                    advised.addAdvice(advice);
                }
                return (bean instanceof Advised) ? bean : ((ProxyFactory) advised).getProxy();
            }
        }
        return bean;
    }

}
