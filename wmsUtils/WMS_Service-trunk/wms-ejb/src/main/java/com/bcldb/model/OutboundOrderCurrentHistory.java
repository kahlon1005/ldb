package com.bcldb.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "v_u_om_f")
@NamedQueries({
	@NamedQuery(name = "OutboundOrderCurrentHistory.findOrderDetails", query = "select o from OutboundOrderCurrentHistory o where o.warehouse = :warehouse and o.shipment = :shipment")
})
public class OutboundOrderCurrentHistory {

	public static final String FIND_ORDER_DETAILS = "OutboundOrderCurrentHistory.findOrderDetails";

	@Id
	@Column(name = "om_rid")
	private long id;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "shipment")
	private String shipment;
	
	@Column(name = "carrier_service")
	private String carrierService;

	@Column(name = "ob_oid")
	private String order;
	
	@Column(name = "ship_name")
	private String shipName;
	
	@Column(name = "ship_addr1")
	private String shipAddress1;
	
	@Column(name = "ship_addr2")
	private String shipAddress2;
	
	@Column(name = "ship_city")
	private String shipCity;
	
	@Column(name = "ship_state")
	private String shipState;
	
	@Column(name = "ship_cntry")
	private String shipCounty;
	
	@Column(name = "ship_custnum")
	private String shipCustomerNumber;
	
		
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	public String getShipment() {
		return shipment;
	}

	public void setShipment(String shipment) {
		this.shipment = shipment;
	}

	public String getCarrierService() {
		return carrierService;
	}

	public void setCarrierService(String carrierService) {
		this.carrierService = carrierService;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}
	
	public String getShipName() {
		return shipName;
	}

	public void setShipName(String shipName) {
		this.shipName = shipName;
	}

	public String getShipAddress1() {
		return shipAddress1;
	}

	public void setShipAddress1(String shipAddress1) {
		this.shipAddress1 = shipAddress1;
	}

	public String getShipAddress2() {
		return shipAddress2;
	}

	public void setShipAddress2(String shipAddress2) {
		this.shipAddress2 = shipAddress2;
	}

	public String getShipCity() {
		return shipCity;
	}

	public void setShipCity(String shipCity) {
		this.shipCity = shipCity;
	}

	public String getShipState() {
		return shipState;
	}

	public void setShipState(String shipState) {
		this.shipState = shipState;
	}

	public String getShipCounty() {
		return shipCounty;
	}

	public void setShipCounty(String shipCounty) {
		this.shipCounty = shipCounty;
	}

	public String getShipCustomerNumber() {
		return shipCustomerNumber;
	}

	public void setShipCustomerNumber(String shipCustomerNumber) {
		this.shipCustomerNumber = shipCustomerNumber;
	}

	@Override
	public String toString() {
		return "OutboundOrderCurrentHistory [id=" + id + ", warehouse=" + warehouse + ", shipment=" + shipment
				+ ", carrierService=" + carrierService + ", order=" + order + "]";
	}
	
	
}
