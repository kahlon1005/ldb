package com.bcldb.web.wms.endpoint;

import java.net.MalformedURLException;

import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.bcldb.emailservice.Email;

/**
 * 
 * The connection configuration to the service
 *
 */
@Component
public class EmailServiceEndPoint {
	
	private static final Logger LOG = LoggerFactory.getLogger(EmailServiceEndPoint.class);	

	@Value("${email.service.endpoint}") 
	private String endPoint;

	private Email emailService;

	
	public Email getService() throws MalformedURLException {
		if (emailService != null) {
			return emailService;
		}
		
		try {
			JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();
			factory.setServiceClass(Email.class);
			factory.setAddress(endPoint);
			
			// output REQUEST and RESPONSE
			factory.getInInterceptors().add(new LoggingInInterceptor());
			factory.getOutInterceptors().add(new LoggingOutInterceptor());
				
			emailService = (Email) factory.create();
			return emailService;			
		} catch (Exception e) {
			LOG.error("Failed to call Product Service. ", e);
			throw e;
		}
	}
	
}
