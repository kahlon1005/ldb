package com.bcldb.util;

import com.bcldb.exception.ValidationException;
import com.bcldb.services.wmsservice.TransactionType;
import com.bcldb.services.wmsservice.UpdateStuckTransactionsRequest;

public final class ParamValidator {

	public ParamValidator() {
		super();
	}

	public UpdateStuckTransactionsRequest validateRequest(UpdateStuckTransactionsRequest part) {
		if (part == null) {
			throw new ValidationException("The request is not valid.");
		}
		
		if(part.getTransactions() == null) {
			part.setTransactions(new TransactionType());
			if(part.getTransactions() == null) {
				throw new ValidationException("The are no orders found in the request to process.");	
			}
		}
		if (part.getTransactions().getId() == null) {
			throw new ValidationException("Transaction id cannot be null.");
		} else {
			part.getTransactions().setId(part.getTransactions().getId().toUpperCase());
		}
		if (part.getTransactions().getType() == null) {
			throw new ValidationException("Transaction type cannot be null.");
		} else {
			part.getTransactions().setType(part.getTransactions().getType().toUpperCase());
		}		
		
		if(part.getIncidentNumber() == null) {
			throw new ValidationException("Incident number can not null.");
		}else {
			part.setIncidentNumber(part.getIncidentNumber().toUpperCase());
		}
		
		
		return part;
	}


}
