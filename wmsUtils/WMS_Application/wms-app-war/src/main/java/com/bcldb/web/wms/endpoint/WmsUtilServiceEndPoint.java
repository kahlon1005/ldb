package com.bcldb.web.wms.endpoint;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.UnsupportedCallbackException;

import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.frontend.ClientProxy;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.apache.cxf.transport.http.HTTPConduit;
import org.apache.cxf.transports.http.configuration.HTTPClientPolicy;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.wss4j.common.ext.WSPasswordCallback;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import wmsservice.WMSService;

@Component
public class WmsUtilServiceEndPoint {
	private static final Logger log = LoggerFactory.getLogger(WmsUtilServiceEndPoint.class);

	private static final long WSDL_CONNECTION_TIMEOUT = 120000;
	private static final long WSDL_RECEIVE_TIMEOUT = 120000;
	
	@Value("${wms.service.endpoint}")
	private String endPoint;

	@Value("${wms.service.endpoint.username}")
	private String wms_service_wsdl_username;

	@Value("${wms.service.endpoint.password}")
	private String wms_service_wsdl_password;

	private WMSService service;

	public WMSService getService() {

		if (service == null) {
			try {
				service = createSecureService(this.endPoint, wms_service_wsdl_username,
						wms_service_wsdl_password);

			} catch (Exception e) {
				log.error("Fail to initialize wms service instance");
				throw e;
			}
		}
		return service;
	}
	
	
	
	public static WMSService createSecureService(String url, 
			 String username, String password) {
		log.info("Create secure connenction for wsdl " + url);
		JaxWsProxyFactoryBean jaxWsFactory = new JaxWsProxyFactoryBean();
		jaxWsFactory.setServiceClass(WMSService.class);
		jaxWsFactory.setAddress(url);
		WMSService service = (WMSService) jaxWsFactory.create();
		Client client = ClientProxy.getClient(service);		
		if(!username.isEmpty()) {
			Endpoint cxfEndpoint = client.getEndpoint();
			Map<String, Object> outProps = new HashMap<String, Object>();
			outProps.put(WSHandlerConstants.ACTION, WSHandlerConstants.USERNAME_TOKEN);
			outProps.put(WSHandlerConstants.USER, username);
			outProps.put(WSHandlerConstants.PASSWORD_TYPE, WSConstants.PW_TEXT);
			outProps.put(WSHandlerConstants.PW_CALLBACK_REF, new CallbackHandler() {
				@Override
				public void handle(Callback[] callbacks) throws IOException, UnsupportedCallbackException {
					Arrays.stream(callbacks).filter(WSPasswordCallback.class::isInstance)
							.map(WSPasswordCallback.class::cast).forEach(callback -> callback.setPassword(password));
				}
			});
			WSS4JOutInterceptor wssOut = new WSS4JOutInterceptor(outProps);
			cxfEndpoint.getOutInterceptors().add(wssOut);
		}
		HTTPConduit http = (HTTPConduit) client.getConduit();
		HTTPClientPolicy httpClientPolicy = new HTTPClientPolicy();
		httpClientPolicy.setConnectionTimeout(WSDL_CONNECTION_TIMEOUT);
		httpClientPolicy.setReceiveTimeout(WSDL_RECEIVE_TIMEOUT);
		http.setClient(httpClientPolicy);
		return service;
	}

}
