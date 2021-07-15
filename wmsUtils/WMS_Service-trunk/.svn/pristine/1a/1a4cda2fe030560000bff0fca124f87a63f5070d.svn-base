package com.bcldb.services;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

import com.bcldb.dto.TransactionDto;
import com.bcldb.dto.TransactionReturnType;
import com.bcldb.ejb.WmsServiceBean;
import com.bcldb.services.common.EmptyRequestType;
import com.bcldb.services.wmsservice.GetStuckTransactionsResponse;
import com.bcldb.services.wmsservice.TransactionType;
import com.bcldb.services.wmsservice.UpdateStuckTransactionsRequest;

import wmsservice.ErrorMessage;

public class WMSServiceImplTest {
	
	private static final String TRANSACTION_STUCK_IN_TRUCK_LOCATION = "Inventory Stuck in TRUCK location";
	
	private static final String ORDER_1001 = "1001";

	private static final String TRANSACTION_ID_REQUIRED = "Transaction id cannot be null.";
	private static final String TRANSACTION_TYPE_ORDER = "Order";

	@Mock
	WmsServiceBean service;
	
	WMSServiceImpl soap;
	
	@Rule public MockitoRule mockitoRule = MockitoJUnit.rule();
	
	String incidentNumber = "INC-123456";
	String username = "Test";
	String errorMessage = "Inventory Stuck in TRUCK Location.";
	String warehouse = "VCD";
	
	@Before
	public void setup(){
		soap  = new WMSServiceImpl(service);
		
		TransactionReturnType result = new TransactionReturnType();
		TransactionDto dto = new TransactionDto();
		dto.setName(ORDER_1001);
		dto.setMessage(TRANSACTION_STUCK_IN_TRUCK_LOCATION);
		result.getTransactionType().add(dto);
		
		when(service.getStuckShipments()).thenReturn(result);		
		
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("success", Boolean.TRUE.toString());
		map.put("message", "Order number: " + ORDER_1001 + " update successfully.");
		when(service.updateStuckShipment(ORDER_1001, TRANSACTION_TYPE_ORDER,incidentNumber, username, errorMessage, warehouse)).thenReturn(map);

	}
	
	@Test
	public void validateGetStuckTransactionsReturnListIsNotEmptyTest() throws ErrorMessage {
		
		EmptyRequestType part = new EmptyRequestType();
		GetStuckTransactionsResponse response = soap.getStuckTransactions(part);
		List<TransactionType> list = response.getTransaction();		
		assertTrue(!list.isEmpty());
	}
	
	@Test
	public void validateGetStuckTransactionsFoundTransactionStuckInTruckLocationTest() throws ErrorMessage {
		
		EmptyRequestType part = new EmptyRequestType();
		GetStuckTransactionsResponse response = soap.getStuckTransactions(part);
		List<TransactionType> list = response.getTransaction();		
		for (TransactionType transaction : list) {
			if(transaction.getId().equals(ORDER_1001)) {
				assertEquals(TRANSACTION_STUCK_IN_TRUCK_LOCATION, transaction.getIssueDescription());
			}
		}	
		
	}
	
	
	@Test
	public void validateOrderCountInGetStuckTransactionsTest() throws ErrorMessage {
		
		EmptyRequestType part = new EmptyRequestType();
		GetStuckTransactionsResponse response = soap.getStuckTransactions(part);
		List<TransactionType> list = response.getTransaction();
		assertEquals(1, list.size());
	}
	


	@Test
	public void validateUpdateStuckTransactionsReturnMessageTest2() {
		
		UpdateStuckTransactionsRequest part = new UpdateStuckTransactionsRequest();
		
		
		
		try {
			soap.updateStuckTransactions(part);
		
		}catch (Exception e) {
			assertEquals(TRANSACTION_ID_REQUIRED, e.getMessage());			
		}
		
		
	}
}
