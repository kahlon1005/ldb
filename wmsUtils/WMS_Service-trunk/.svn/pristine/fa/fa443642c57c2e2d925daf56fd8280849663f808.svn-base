package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@IdClass(MpackOrderId.class)
@Table(name = "mpack_order")
public class MpackOrderEntity implements Serializable{

	private static final long serialVersionUID = -5175662556499342244L;
	
	@Id
	@Column(name = "mpack_id")
	private long mpackId;
	
	@Id
	@Column(name = "mpack_order_seq")
	private long mpackOrderSeq;
	
	@Column(name = "om_rid")
	private long orderId;
	
	@Column(name = "probill")
	private String probill;
	
	
	@Column(name = "carrier_service")
	private String carrierService;
	
	@Column(name = "carrier_trailer")
	private String carrierTrailer;
	
	@Column(name = "fullskid")
	private String fullskid;
	
	@Column(name = "num_crtn")
	private int numCrtn;
	
	@Column(name = "wgt")
	private double wgt;	
	
	@Column(name = "total_ship_qty")
	private double totalShipQty;
	
	@Column(name = "total_extended_price")
	private double totalExtendedPrice;
	
	@Column(name = "total_sales_order_qty")
	private double totalSalesOrderQty;
	
	@Column(name = "total_open_ord_qty")
	private double totalOpenOrdQty;
	
	@Column(name = "total_ship_to_date_qty")
	private double totalShipToDateQty;
	
	@Column(name = "freight_class")
	private String freightClass;
	
	@Column(name = "shipment")
	private String shipment;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "seller_name")
	private String sellerName;
	
	@Column(name = "seller_gln")
	private String seller_gln;
	
	@Column(name = "seller_address1")
	private String sellerAddress1;
	
	@Column(name = "seller_address2")
	private String sellerAddress2;
	
	@Column(name = "seller_city")
	private String sellerCity;
	
	@Column(name = "seller_state")
	private String sellerState;
	
	@Column(name = "seller_zip")
	private String sellerZip;
	
	@Column(name = "seller_country")
	private String sellerCountry;
	
	@Column(name = "seller_dscsa_statement")
	private String sellerDscsaStatement;
	
	

	public MpackOrderEntity() {
		super();
	}
		

	public MpackOrderEntity(long mpackId, long orderId, String carrierService, String shipment,
			String warehouse) {
		super();
		this.mpackId = mpackId;
		this.mpackOrderSeq = 1;
		this.orderId = orderId;
		this.carrierService = carrierService;
		this.shipment = shipment;
		this.warehouse = warehouse;
		
		this.probill = "NONE";
		this.carrierTrailer = "";
		this.fullskid = "Y";
		this.numCrtn = 0;
		this.wgt = 0;
		this.totalShipQty = 0;
		this.totalExtendedPrice = 0;
		this.totalSalesOrderQty = 0;
		this.totalOpenOrdQty = 0;
		this.totalShipToDateQty = 0;
		this.freightClass = "";
		this.sellerName = "";
		this.seller_gln = "";
		this.sellerAddress1 = "";
		this.sellerAddress2 = "";
		this.sellerCity = "";
		this.sellerState = "";
		this.sellerZip = "";
		this.sellerCountry = "";
		this.sellerDscsaStatement = "";
	}




	public long getMpackId() {
		return mpackId;
	}

	public void setMpackId(long mpackId) {
		this.mpackId = mpackId;
	}

	public long getMpackOrderSeq() {
		return mpackOrderSeq;
	}

	public void setMpackOrderSeq(long mpackOrderSeq) {
		this.mpackOrderSeq = mpackOrderSeq;
	}

	public long getOrderId() {
		return orderId;
	}

	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}

	public String getProbill() {
		return probill;
	}

	public void setProbill(String probill) {
		this.probill = probill;
	}

	public String getCarrierService() {
		return carrierService;
	}

	public void setCarrierService(String carrierService) {
		this.carrierService = carrierService;
	}

	public String getCarrierTrailer() {
		return carrierTrailer;
	}

	public void setCarrierTrailer(String carrierTrailer) {
		this.carrierTrailer = carrierTrailer;
	}

	public String getFullskid() {
		return fullskid;
	}

	public void setFullskid(String fullskid) {
		this.fullskid = fullskid;
	}

	public int getNumCrtn() {
		return numCrtn;
	}

	public void setNumCrtn(int numCrtn) {
		this.numCrtn = numCrtn;
	}

	public double getWgt() {
		return wgt;
	}

	public void setWgt(double wgt) {
		this.wgt = wgt;
	}

	public double getTotalShipQty() {
		return totalShipQty;
	}

	public void setTotalShipQty(double totalShipQty) {
		this.totalShipQty = totalShipQty;
	}

	public double getTotalExtendedPrice() {
		return totalExtendedPrice;
	}

	public void setTotalExtendedPrice(double totalExtendedPrice) {
		this.totalExtendedPrice = totalExtendedPrice;
	}

	public double getTotalSalesOrderQty() {
		return totalSalesOrderQty;
	}

	public void setTotalSalesOrderQty(double totalSalesOrderQty) {
		this.totalSalesOrderQty = totalSalesOrderQty;
	}

	public double getTotalOpenOrdQty() {
		return totalOpenOrdQty;
	}

	public void setTotalOpenOrdQty(double totalOpenOrdQty) {
		this.totalOpenOrdQty = totalOpenOrdQty;
	}

	public double getTotalShipToDateQty() {
		return totalShipToDateQty;
	}

	public void setTotalShipToDateQty(double totalShipToDateQty) {
		this.totalShipToDateQty = totalShipToDateQty;
	}

	public String getFreightClass() {
		return freightClass;
	}

	public void setFreightClass(String freightClass) {
		this.freightClass = freightClass;
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

	public String getSellerName() {
		return sellerName;
	}

	public void setSellerName(String sellerName) {
		this.sellerName = sellerName;
	}

	public String getSeller_gln() {
		return seller_gln;
	}

	public void setSeller_gln(String seller_gln) {
		this.seller_gln = seller_gln;
	}

	public String getSellerAddress1() {
		return sellerAddress1;
	}

	public void setSellerAddress1(String sellerAddress1) {
		this.sellerAddress1 = sellerAddress1;
	}

	public String getSellerAddress2() {
		return sellerAddress2;
	}

	public void setSellerAddress2(String sellerAddress2) {
		this.sellerAddress2 = sellerAddress2;
	}

	public String getSellerCity() {
		return sellerCity;
	}

	public void setSellerCity(String sellerCity) {
		this.sellerCity = sellerCity;
	}

	public String getSellerState() {
		return sellerState;
	}

	public void setSellerState(String sellerState) {
		this.sellerState = sellerState;
	}

	public String getSellerZip() {
		return sellerZip;
	}

	public void setSellerZip(String sellerZip) {
		this.sellerZip = sellerZip;
	}

	public String getSellerCountry() {
		return sellerCountry;
	}

	public void setSellerCountry(String sellerCountry) {
		this.sellerCountry = sellerCountry;
	}

	public String getSellerDscsaStatement() {
		return sellerDscsaStatement;
	}

	public void setSellerDscsaStatement(String sellerDscsaStatement) {
		this.sellerDscsaStatement = sellerDscsaStatement;
	}

	
	
	
}
