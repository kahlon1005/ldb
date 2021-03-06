package com.bcldb.web.wms.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Transaction {
	
	private String name;
	private String type;
	private String warehouse;
	private String message;
	private String incidentNumber;
	private String username;
	
	public Transaction() {
		super();
	}

	public Transaction(int id , String name) {
		super();		
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	

	public String getIncidentNumber() {
		return incidentNumber;
	}

	public void setIncidentNumber(String incidentNumber) {
		this.incidentNumber = incidentNumber;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Override
	public String toString() {
		return "Transaction [name=" + name + ", type=" + type + ", warehouse=" + warehouse + ", message=" + message
				+ ", incidentNumber=" + incidentNumber + ", username=" + username + "]";
	}
	
	
}
