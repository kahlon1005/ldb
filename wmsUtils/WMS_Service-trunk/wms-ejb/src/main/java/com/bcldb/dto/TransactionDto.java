package com.bcldb.dto;

public class TransactionDto {
	
	public static final String WAVE_TRANSACTION_TYPE = "WAVE";
	public static final String ORDER_TRANSACTION_TYPE = "ORDER";
	
	
	private String name;
	private String type;
	private String message;
	private String warehouse;
	
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
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getWarehouse() {
		return warehouse;
	}
	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}
	
	@Override
	public String toString() {
		return "TransactionDto [name=" + name + ", type=" + type + ", message=" + message + ", warehouse=" + warehouse
				+ "]";
	}
	
}
