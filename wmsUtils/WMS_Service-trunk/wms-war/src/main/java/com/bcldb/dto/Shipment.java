package com.bcldb.dto;

public class Shipment {
	String shipment;
	String order;
	
	public String getShipment() {
		return shipment;
	}
	public void setShipment(String shipment) {
		this.shipment = shipment;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	@Override
	public String toString() {
		return "Shipment [shipment=" + shipment + ", order=" + order + "]";
	}
	
}

