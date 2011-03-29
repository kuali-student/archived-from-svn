package org.kuali.spring.util;

import junit.framework.Assert;
import net.sf.cglib.proxy.Callback;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.NoOp;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.FactoryBean;

public class SimpleProxyFactoryBean implements FactoryBean<Object> {
	Callback callback = NoOp.INSTANCE;
	String classname;
	Object sourceBean;
	boolean copySourceBeanProperties = true;

	public SimpleProxyFactoryBean() {
		this(null, NoOp.INSTANCE);
	}

	public SimpleProxyFactoryBean(String classname) {
		this(classname, NoOp.INSTANCE);
	}

	public SimpleProxyFactoryBean(String classname, Callback callback) {
		super();
		this.classname = classname;
		this.callback = callback;
	}

	@Override
	public Object getObject() throws Exception {
		Assert.assertTrue(this.classname != null || this.sourceBean != null);
		Assert.assertNotNull(this.callback);
		if (this.copySourceBeanProperties) {
			Assert.assertTrue(this.sourceBean != null);
		}

		Class<?> targetClass = getTargetClass();
		Enhancer enhancer = new Enhancer();
		enhancer.setSuperclass(targetClass);
		enhancer.setCallback(getCallback());
		Object proxy = enhancer.create();
		if (this.copySourceBeanProperties) {
			BeanUtils.copyProperties(this.sourceBean, proxy);
		}
		return proxy;
	}

	protected Class<?> getTargetClass() throws ClassNotFoundException {
		if (this.classname != null) {
			return Class.forName(this.classname);
		} else {
			return this.sourceBean.getClass();
		}
	}

	@Override
	public Class<?> getObjectType() {
		return Object.class;
	}

	@Override
	public boolean isSingleton() {
		return false;
	}

	public Callback getCallback() {
		return callback;
	}

	public void setCallback(Callback callback) {
		this.callback = callback;
	}

	public String getClassname() {
		return classname;
	}

	public void setClassname(String classname) {
		this.classname = classname;
	}

	public Object getSourceBean() {
		return sourceBean;
	}

	public void setSourceBean(Object source) {
		this.sourceBean = source;
	}

}
