package com.bcldb.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.jws.WebService;

import org.jboss.logging.Logger;

import com.bcldb.common.util.Version;
import com.bcldb.dto.TransactionDto;
import com.bcldb.dto.TransactionReturnType;
import com.bcldb.ejb.WmsServiceBean;
import com.bcldb.services.common.EmptyRequestType;
import com.bcldb.services.common.GetVersionResponse;
import com.bcldb.services.common.type.PostServiceResponseType;
import com.bcldb.services.wmsservice.GetStuckTransactionsResponse;
import com.bcldb.services.wmsservice.TransactionType;
import com.bcldb.services.wmsservice.UpdateStuckTransactionsRequest;
import com.bcldb.util.ErrorHandler;
import com.bcldb.util.ParamValidator;
import com.bcldb.util.WMSUtilServiceException;

import wmsservice.ErrorMessage;
import wmsservice.WMSService;

@WebService(serviceName = "WMSService", endpointInterface = "wmsservice.WMSService")
public class WMSServiceImpl implements WMSService {

	private static final Logger log = Logger.getLogger(WMSServiceImpl.class);

	ErrorHandler handler = new ErrorHandler();
	ParamValidator validator = new ParamValidator();	
	
	
	
	public WMSServiceImpl() {			
	}

	public WMSServiceImpl(WmsServiceBean service) {		
		this.service = service;
	}

	@Inject
	WmsServiceBean service;

	@Override
	public GetVersionResponse getVersionInfo(EmptyRequestType part) throws ErrorMessage {
		GetVersionResponse versionResponse = new GetVersionResponse();
		versionResponse.setVersion(Version.get().getVersionNumber());
		log.info("getVersion: version number : " + Version.get().getVersionNumber());
		
		return versionResponse;
	}

	@Override
	public GetStuckTransactionsResponse getStuckTransactions(EmptyRequestType part) throws ErrorMessage {
		GetStuckTransactionsResponse ret = new GetStuckTransactionsResponse();
		List<TransactionDto> dtos = new ArrayList<TransactionDto>();
		try {

			TransactionReturnType returnType = service.getStuckShipments();

			dtos.addAll(returnType.getTransactionType());

			for (TransactionDto dto : dtos) {
				TransactionType transaction = new TransactionType();
				transaction.setId(dto.getName());
				transaction.setIssueDescription(dto.getMessage());
				transaction.setType(dto.getType());
				transaction.setWarehouse(dto.getWarehouse());
				ret.getTransaction().add(transaction);
			}

		} catch (Exception e) {
			log.error(e.getMessage());
			handler.reportError(e, e.getMessage());
		}

		return ret;

	}

	@Override
	public PostServiceResponseType updateStuckTransactions(UpdateStuckTransactionsRequest part) throws ErrorMessage {
		PostServiceResponseType ret = new PostServiceResponseType();
		
		boolean success = Boolean.FALSE;
		try {
			part = validator.validateRequest(part);
			

			String incidentNumber = part.getIncidentNumber();
			String username = null;
			
			if(part.getLastUpdated() != null) {
				username = part.getLastUpdated().getLastUpdatedBy();
			}
			
			TransactionType transaction = part.getTransactions();
			
			String errorMessage = transaction.getIssueDescription();
			String warehouse = transaction.getWarehouse();
							
			Map<String, String> updateTransaction = service.updateStuckShipment(transaction.getId(), transaction.getType(), incidentNumber, username, errorMessage, warehouse);				
			
			success = Boolean.valueOf(updateTransaction.get("success"));
			
			ret.setSuccess(success);
			ret.setAuxMessage(updateTransaction.get("message"));
			
		}catch (WMSUtilServiceException e) {			
			ret.setAuxMessage(e.getMessage());			
		}catch (Exception e) {
			log.error(e.getMessage());
			handler.reportError(e, e.getMessage());
		}	
		ret.setSuccess(success);
		return ret;
	}
	
}