package com.bcldb.web.wms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bcldb.web.wms.dto.Transaction;
import com.bcldb.web.wms.dto.TransactionReturnType;
import com.bcldb.web.wms.service.EmailService;
import com.bcldb.web.wms.service.WmsUtilService;

@RestController
@RequestMapping("/api/v1")
public class TransactionController {
	
	
	@Autowired
	private WmsUtilService  wmsUtilService;
	
	@Autowired
	private EmailService emailService;
	
	@GetMapping("/version")
	private String version() {
		String version = wmsUtilService.getVersion();		
		return version;
	}

	
	@GetMapping("/transactions")
	public List<Transaction> getStuckOrders(){
		return wmsUtilService.getStuckTransactions();
	}
	
	
	//update order rest api
	@PutMapping("/transactions/{name}")
	public ResponseEntity<Map<String,String>>  updateStuckOrders(@PathVariable String name, @RequestBody Transaction transaction) {
		
		TransactionReturnType ret = wmsUtilService.updateStuckTransaction(transaction);
		
		if(ret.isSuccess()) {
			emailService.sendEmail(transaction);	
		}
		
		
		Map<String, String> response = new HashMap<>();
		response.put("updated", Boolean.toString(ret.isSuccess()));
		response.put("message", ret.getMessage());
		return ResponseEntity.ok(response);
	}
		
}
