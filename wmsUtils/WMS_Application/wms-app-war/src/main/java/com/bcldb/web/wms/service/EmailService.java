package com.bcldb.web.wms.service;

import java.net.MalformedURLException;
import java.text.MessageFormat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.bcldb.emailservice.SendEmailFault_Exception;
import com.bcldb.osb.emailrequest.EmailType;
import com.bcldb.web.wms.dto.Transaction;
import com.bcldb.web.wms.endpoint.EmailServiceEndPoint;

@Service
public class EmailService {

	private static final Logger LOG = LoggerFactory.getLogger(EmailService.class);

	
	@Autowired
	EmailServiceEndPoint endpoint;

	@Value("${to.email}")
	String toEmail;
	
	@Value("${from.email}")
	String fromEmail;
	
	@Value("${reply.address}")
	String replyAddress;

	@Value("${reply.to}")
	String replyTo;
	
	@Value("${email.header.text}")
	String headerText;
	
	public String sendEmail(Transaction transaction) {
		// send email
		try {
			EmailType emailType = new EmailType();
			
			String formattedSubjectLine = MessageFormat.format(getEmailSubject(transaction.getType()), transaction.getType(), transaction.getName(), transaction.getIncidentNumber().toUpperCase());
			String formattedEmailContent = MessageFormat.format(getEmailContent(transaction.getType()), transaction.getType(), transaction.getName(), transaction.getUsername());		
			emailType.setContent(formattedEmailContent);
			emailType.setContentType("text/html");
			emailType.setFrom(fromEmail);
			emailType.setTo(toEmail);
			emailType.setReplyAddress( replyAddress );
			emailType.setReplyTo( replyTo );
			emailType.setSubject(formattedSubjectLine);

			return endpoint.getService().sendEmail(emailType);
		} catch (MalformedURLException | SendEmailFault_Exception e) {
			LOG.error(e.getStackTrace().toString());
			e.printStackTrace();
			
		}
		return null;
	}

	private String getEmailSubject(String transactionType) {
		String subject ="";
		if(transactionType.toUpperCase().contains("DOC")) {
			subject = "{2} - WMS Utils - data-fix applied Shipping document for Shipment : {1}";
		}else {
			subject = "{2} - WMS Utils - data-fix applied for {0} : {1}";
		}		
		return subject;
	}
	private String getEmailContent(String transactionType) {
		String content = "";
		
		if(!headerText.isEmpty()) {
			content = "<p><strong>"+headerText+"</strong></p>";
		}
		
		if(transactionType.toUpperCase().contains("DOC")) {
			content = content + "<p>This is to inform that a data fix is appiled for shipping documents using WMS Utils application for Shipment number <strong>{1}</strong> by user {2}<p><br/><br/>"
					+ "<p>This is an auto generated email, please contact helpdesk for support.</p>";
		}else {
			content = content + "<p>This is to inform that a data fix is applied using WMS Utils application for {0} number <strong>{1}</strong> by user {2}<p><br/><br/>"
				+ "<p>This is an auto generated email, please contact helpdesk for support.</p>";
		}
		return content;
	}

		

}
