package com.bcldb.web.wms.controller;


import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import com.bcldb.web.wms.dto.Transaction;
import com.bcldb.web.wms.service.WmsUtilService;
import com.fasterxml.jackson.databind.ObjectMapper;

@RunWith(SpringRunner.class)
@WebMvcTest(TransactionController.class)
public class WMSServiceEndpointTest {
	
	
	private static final String WMS_SERVCE_VERSION = "1.0.0";
	
	
	@MockBean
	private WmsUtilService service;
	
	ObjectMapper mapper = new ObjectMapper();
	
	@Autowired
	private MockMvc mockMvc;
	
	
	@Before
	public void setup() {
		List<Transaction> orders = new ArrayList<Transaction>();
		for (int i = 0; i < 10; i++) {
			Transaction order = new Transaction(i, "1000" + i);
			orders.add(order);
		}
		
		
		Mockito.when(service.getVersion()).thenReturn(WMS_SERVCE_VERSION);
		Mockito.when(service.getStuckTransactions()).thenReturn(orders);
	}
	
	@Test
	public void it_should_test_version() throws Exception {
		when(service.getVersion()).thenReturn(WMS_SERVCE_VERSION);
		mockMvc.perform(get("/api/v1/version").contentType(MediaType.APPLICATION_JSON)).andExpect(status().isOk());
		
	}
	
	@Test
	public void validateWMSServiceVersionIsNotEmpty() {
		assertThat(service.getVersion()).isNotEmpty();
		assertThat(service.getVersion()).isEqualTo(WMS_SERVCE_VERSION);
	}

	@Test
	public void validateWMSServiceGetStuckTransactionListIsNotEmpty() {
		assertThat(service.getStuckTransactions()).isNotEmpty();
		assertThat(service.getStuckTransactions()).hasSize(10);
	}
}
