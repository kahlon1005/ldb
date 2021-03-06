package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name="shipunit_h")
@NamedQueries({
	@NamedQuery(name = "ShippableUnitHistory.findAllShipmentContainers", query = "select s from ShippableUnitHistory s where s.warehouse = :warehouse and s.shipment= :shipment and s.cont <> ''"),
	@NamedQuery(name = "ShippableUnitHistory.palletCount", query = "select COUNT(s) from ShippableUnitHistory s where s.warehouse = :warehouse and s.shipment = :shipment"),
	@NamedQuery(name = "ShippableUnitHistory.totalWeight", query = "select SUM(s.weight) from ShippableUnitHistory s where s.warehouse = :warehouse and s.shipment = :shipment")
})
public class ShippableUnitHistory implements Serializable {
	
	private static final long serialVersionUID = -4497519416241621064L;

	public static final String FIND_ALL_SHIPMENT_CONTAINER = "ShippableUnitHistory.findAllShipmentContainers";
	public static final String PALLET_COUNT = "ShippableUnitHistory.palletCount";
	public static final String TOTAL_WEIGHT = "ShippableUnitHistory.totalWeight";

	@Id
	@Column(name = "shipunit_rid")
	private long id;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "cont")
	private String cont;
	
	@Column(name = "shipment")
	private String shipment;
	
	@Column(name = "bol")
	private String bol;
	
	
	@Column(name = "cont_packlist")
	private String contPackList;
	
	@Column(name = "packlist")
	private String packlist;
	
	@Column(name = "trailer")
	private String trailer;
	
	@Column(name = "wgt")
	private double weight;

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

	public String getCont() {
		return cont;
	}

	public void setCont(String cont) {
		this.cont = cont;
	}

	public String getShipment() {
		return shipment;
	}

	public void setShipment(String shipment) {
		this.shipment = shipment;
	}

	public String getBol() {
		return bol;
	}

	public void setBol(String bol) {
		this.bol = bol;
	}

	public String getContPackList() {
		return contPackList;
	}

	public void setContPackList(String contPackList) {
		this.contPackList = contPackList;
	}

	public String getPacklist() {
		return packlist;
	}

	public void setPacklist(String packlist) {
		this.packlist = packlist;
	}

	public String getTrailer() {
		return trailer;
	}

	public void setTrailer(String trailer) {
		this.trailer = trailer;
	}

	public double getWeight() {
		return weight;
	}

	public void setWeight(double totalWeight) {
		this.weight = totalWeight;
	}
	
}
