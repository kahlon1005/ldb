package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "ca_f")
@NamedQueries({
	@NamedQuery(name = "Carrier.findByCarrierService", query = "select c from Carrier c where c.carrierService = :carrierService and c.warehouse = :warehouse")
})
public class Carrier implements Serializable{

	private static final long serialVersionUID = 1L;
	
	public static final String FIND_BY_CARRIER_SERVICE = "Carrier.findByCarrierService";
	
	
	@Id
	@Column(name ="ca_rid")
	private long id;
	
	@Column(name = "carrier_service")
	private String carrierService;
	
	@Column(name = "carrier_code")
	private String carrierCode;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getCarrierService() {
		return carrierService;
	}

	public void setCarrierService(String carrierService) {
		this.carrierService = carrierService;
	}

	public String getCarrierCode() {
		return carrierCode;
	}

	public void setCarrierCode(String carrierCode) {
		this.carrierCode = carrierCode;
	}
	
	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	@Override
	public String toString() {
		return "Carrier [id=" + id + ", carrierService=" + carrierService + ", carrierCode=" + carrierCode
				+ ", warehouse=" + warehouse + "]";
	}
	
}
