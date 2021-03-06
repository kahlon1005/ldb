package com.bcldb.web.wms.service;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bcldb.services.common.EmptyRequestType;
import com.bcldb.services.common.GetVersionResponse;
import com.bcldb.services.common.LastChangeDateTimeType;
import com.bcldb.services.common.type.PostServiceResponseType;
import com.bcldb.services.wmsservice.GetStuckTransactionsResponse;
import com.bcldb.services.wmsservice.TransactionType;
import com.bcldb.services.wmsservice.UpdateStuckTransactionsRequest;
import com.bcldb.web.wms.dto.Transaction;
import com.bcldb.web.wms.dto.TransactionReturnType;
import com.bcldb.web.wms.endpoint.WmsUtilServiceEndPoint;

import wmsservice.ErrorMessage;

@Service
public class WmsUtilService {
	
	private static final Logger log = LoggerFactory.getLogger(WmsUtilService.class);	
	
	@Autowired
	private WmsUtilServiceEndPoint endpoint;
	
	/**
	 * get wms service version number
	 * 
	 * @return
	 * @throws ErrorMessage
	 */
	public String getVersion() {
		EmptyRequestType part = new EmptyRequestType();
		GetVersionResponse response = new GetVersionResponse();
		try {
			response = endpoint.getService().getVersionInfo(part);
		} catch (ErrorMessage e) {
			log.error(e.getMessage());			
		}
		return response.getVersion();

	}

	/**
	 * get stuck transactions
	 * 
	 * 
	 * @return
	 */
	public List<Transaction> getStuckTransactions() {
		EmptyRequestType part = new EmptyRequestType();
		List<Transaction> transactions = new ArrayList<Transaction>();
		try {
			GetStuckTransactionsResponse response = endpoint.getService().getStuckTransactions(part);
			List<TransactionType> list = response.getTransaction();
			for (TransactionType from : list) {
				Transaction to = new Transaction();
				to.setName(from.getId());
				to.setType(from.getType());
				to.setMessage(from.getIssueDescription());
				to.setWarehouse(from.getWarehouse());
				if(null == from.getId() || from.getId().trim().isEmpty()) {
					continue;
				}else {
					transactions.add(to);
				}
			}
		} catch (ErrorMessage e) {
			log.error(e.getMessage());			
		}

		return transactions;
	}

	/**
	 * 
	 * update stuck transactions
	 * 
	 * @param orderNumbers
	 * @return
	 */
	public TransactionReturnType updateStuckTransaction(Transaction transaction) {
		UpdateStuckTransactionsRequest part = new UpdateStuckTransactionsRequest();
		TransactionReturnType responseType = null;
		try {
			
			part.setTransactions(new TransactionType());
			
			part.setIncidentNumber(transaction.getIncidentNumber());
			
			LastChangeDateTimeType stamp = new LastChangeDateTimeType();
			stamp.setLastUpdatedBy(transaction.getUsername());			
			part.setLastUpdated(stamp);
			
			TransactionType transactionType = new TransactionType() ;
			transactionType.setId(transaction.getName());
			transactionType.setType(transaction.getType());
			transactionType.setIssueDescription(transaction.getMessage());
			transactionType.setWarehouse(transaction.getWarehouse());
			
			part.setTransactions(transactionType);	

			PostServiceResponseType response = endpoint.getService().updateStuckTransactions(part);
			responseType = new TransactionReturnType(response.getAuxMessage(), response.isSuccess());

		} catch (ErrorMessage e) {			
			responseType = new TransactionReturnType(e.getMessage(), Boolean.FALSE);
			log.error(e.getMessage());
		}
		return responseType;
	}


}
