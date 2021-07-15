package com.bcldb.dto;

import java.util.ArrayList;
import java.util.List;

public class TransactionReturnType {
	
	List<TransactionDto> transactionType = new ArrayList<TransactionDto>();	
	
	public List<TransactionDto> getTransactionType() {
		if(transactionType == null) {
			transactionType = new ArrayList<TransactionDto>();
		}
		return transactionType;
	}
	public void setTransactionType(List<TransactionDto> transactionType) {
		this.transactionType = transactionType;
	}
	
}
