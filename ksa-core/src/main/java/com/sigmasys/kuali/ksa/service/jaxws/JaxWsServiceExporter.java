package com.sigmasys.kuali.ksa.service.jaxws;

import com.sigmasys.kuali.ksa.annotation.AnnotationUtils;
import com.sigmasys.kuali.ksa.annotation.Url;
import com.sun.net.httpserver.HttpServer;
import org.springframework.remoting.jaxws.SimpleHttpServerJaxWsServiceExporter;

import javax.xml.ws.Endpoint;
import java.net.BindException;
import java.net.InetSocketAddress;
import java.net.URL;

/**
 * JaxWsServiceExporter.
 * This class uses the internal Java HTTP server for publishing WS endpoints.
 * Inherited from Spring's SimpleJaxWsServiceExporter to work with endpoints that have @Url annotation.
 * For endpoints it can use not only the service name as part of the result URL,
 * but the service URL also. If present the service URL has a higher priority than the service name.
 * <p/>
 * <p/>
 *
 * @author Michael Ivanov
 */
public class JaxWsServiceExporter extends SimpleHttpServerJaxWsServiceExporter {

    private String baseServiceUrl;
    private String contextPath;
    private HttpServer server;

    private String getContextPath(URL url) {
        String path = url.getPath();
        if (path != null) {
            if (!path.startsWith("/")) {
                path = "/" + path;
            }
            return path;
        }
        return "/";
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        if (baseServiceUrl != null) {
            URL url = new URL(baseServiceUrl);
            InetSocketAddress address = new InetSocketAddress(url.getHost(), url.getPort());
            // Calculating the context path
            contextPath = getContextPath(url);
            try {
                server = HttpServer.create(address, -1);
                if (logger.isInfoEnabled()) {
                    logger.info("Starting HttpServer at address " + address);
                }
                server.start();
                setServer(server);
            } catch (BindException be) {
                String msg = be.getMessage() + ", host = " + url.getHost() + ", port = " + url.getPort();
                logger.error(msg, be);
                return;
            }
        }
        super.afterPropertiesSet();
    }

    @Override
    protected String calculateEndpointPath(Endpoint endpoint, String serviceName) {
        if (baseServiceUrl != null) {
            String endpointUrl = contextPath;
            if (!endpointUrl.endsWith("/")) {
                endpointUrl += "/";
            }
            // We have to find @Url annotation on one of the WS interfaces and
            // use it for constructing endpoint URL
            Url urlAnnotation = AnnotationUtils.getAnnotation(Url.class, endpoint.getImplementor());
            String serviceUrl = urlAnnotation.value();
            endpointUrl += (serviceUrl != null) ? serviceUrl : serviceName;
            logger.debug("calculateEndpointPath(): endpoint URL = " + endpointUrl);
            return endpointUrl;
        }
        return super.calculateEndpointPath(endpoint, serviceName);
    }

    public void setBaseServiceUrl(String baseServiceUrl) {
        this.baseServiceUrl = baseServiceUrl;
    }

    @Override
    public void destroy() {
        super.destroy();
        if (baseServiceUrl != null) {
            logger.info("Stopping HttpServer");
            server.stop(0);
        }
    }

}

