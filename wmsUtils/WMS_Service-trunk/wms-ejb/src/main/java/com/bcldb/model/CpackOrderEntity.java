package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;


@Entity
@IdClass(CpackOrderId.class)
@Table(name = "cpack_order")
public class CpackOrderEntity implements Serializable {
	
	private static final long serialVersionUID = 7385517893813661526L;
	
	@Id
	@Column(name = "cpack_id")	
	private long cpackId;
	
	@Id
	@Column(name = "cpack_order_seq")
	private long cpackOrderSeq;
	
	@Column(name = "om_rid")
	private long orderId;
	
	@Column(name = "carrier_service")
	private String carrierService;
	
	@Column(name = "probill")
	private String probill;
	
	@Column(name = "fullskid")
	private String fullskid;
	
	@Column(name = "freight_class")
	private String freightClass;
	
	@Column(name = "num_crtn")
	private int numCrtn;
	
	
	@Column(name = "wgt")
	private int wgt;
	
	@Column(name = "total_ship_to_date_qty")
	private int totalShipToDateQty;
	
	@Column(name = "total_extended_price")
	private int totalExtendedPrice;
	
	@Column(name = "total_open_ord_qty")
	private int totalOpenOrdQty;
	
	@Column(name = "total_sales_order_qty")
	private int totalSalesOrderQty;
	
	@Column(name = "total_ship_qty")
	private int totalShipQty;
	
	@Column(name = "shipment")
	private String shipment;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	public CpackOrderEntity() {
		super();
	}
	
	
	public CpackOrderEntity(long cpackId, long orderId, String carrierService, String shipment, String warehouse) {
		super();
		this.cpackId = cpackId;
		this.cpackOrderSeq = 1;
		this.orderId = orderId;
		this.carrierService = carrierService;
		this.shipment = shipment;
		this.warehouse = warehouse;
		
		this.probill = "NONE";
		this.fullskid = "Y";
		this.freightClass = "";
		this.numCrtn = 0;
		this.wgt = 0;
		this.totalShipToDateQty = 0;
		this.totalExtendedPrice = 0;
		this.totalOpenOrdQty = 0;
		this.totalSalesOrderQty = 0;
		this.totalShipQty = 0;
		
	}
	
	
	
	public long getCpackId() {
		return cpackId;
	}


	public void setCpackId(long cpackId) {
		this.cpackId = cpackId;
	}


	public long getCpackOrderSeq() {
		return cpackOrderSeq;
	}


	public void setCpackOrderSeq(long cpackOrderSeq) {
		this.cpackOrderSeq = cpackOrderSeq;
	}


	public long getOrderId() {
		return orderId;
	}
	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}
	public String getCarrierService() {
		return carrierService;
	}
	public void setCarrierService(String carrierService) {
		this.carrierService = carrierService;
	}
	public String getProbill() {
		return probill;
	}
	public void setProbill(String probill) {
		this.probill = probill;
	}
	public String getFullskid() {
		return fullskid;
	}
	public void setFullskid(String fullskid) {
		this.fullskid = fullskid;
	}
	public String getFreightClass() {
		return freightClass;
	}
	public void setFreightClass(String freightClass) {
		this.freightClass = freightClass;
	}
	public int getNumCrtn() {
		return numCrtn;
	}
	public void setNumCrtn(int numCrtn) {
		this.numCrtn = numCrtn;
	}
	public int getWgt() {
		return wgt;
	}
	public void setWgt(int wgt) {
		this.wgt = wgt;
	}
	public int getTotalShipToDateQty() {
		return totalShipToDateQty;
	}
	public void setTotalShipToDateQty(int totalShipToDateQty) {
		this.totalShipToDateQty = totalShipToDateQty;
	}
	public int getTotalExtendedPrice() {
		return totalExtendedPrice;
	}
	public void setTotalExtendedPrice(int totalExtendedPrice) {
		this.totalExtendedPrice = totalExtendedPrice;
	}
	public int getTotalOpenOrdQty() {
		return totalOpenOrdQty;
	}
	public void setTotalOpenOrdQty(int totalOpenOrdQty) {
		this.totalOpenOrdQty = totalOpenOrdQty;
	}
	public int getTotalSalesOrderQty() {
		return totalSalesOrderQty;
	}
	public void setTotalSalesOrderQty(int totalSalesOrderQty) {
		this.totalSalesOrderQty = totalSalesOrderQty;
	}
	public int getTotalShipQty() {
		return totalShipQty;
	}
	public void setTotalShipQty(int totalShipQty) {
		this.totalShipQty = totalShipQty;
	}
	public String getShipment() {
		return shipment;
	}
	public void setShipment(String shipment) {
		this.shipment = shipment;
	}
	public String getWarehouse() {
		return warehouse;
	}
	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}


	@Override
	public String toString() {
		return "CpackOrderEntity [cpackId=" + cpackId + ", cpackOrderSeq=" + cpackOrderSeq + ", orderId=" + orderId
				+ ", carrierService=" + carrierService + ", probill=" + probill + ", fullskid=" + fullskid
				+ ", freightClass=" + freightClass + ", numCrtn=" + numCrtn + ", wgt=" + wgt + ", totalShipToDateQty="
				+ totalShipToDateQty + ", totalExtendedPrice=" + totalExtendedPrice + ", totalOpenOrdQty="
				+ totalOpenOrdQty + ", totalSalesOrderQty=" + totalSalesOrderQty + ", totalShipQty=" + totalShipQty
				+ ", shipment=" + shipment + ", warehouse=" + warehouse + "]";
	}
	
	
	
	
	
}
	
