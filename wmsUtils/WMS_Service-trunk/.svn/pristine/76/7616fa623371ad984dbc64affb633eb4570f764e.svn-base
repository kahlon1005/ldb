package com.bcldb.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "bol")
@NamedQueries({
	@NamedQuery(name = "Bol.findBolByShipment", query = "select b from Bol b where b.warehouse = :warehouse and b.shipment = :shipment"),
	@NamedQuery(name = "Bol.findBolByBolNumber", query = "select b from Bol b where b.warehouse = :warehouse and b.bol = :bol")
})
public class Bol implements Serializable{

	private static final long serialVersionUID = 8019676219330214501L;

	public static final String FIND_BOL_BY_SHIPMENT = "Bol.findBolByShipment";

	public static final String FIND_BOL_BY_BOLNUMBER = "Bol.findBolByBolNumber";

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "bol_id")
	private long id;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "bol")
	private String bol;
	
	@Column(name = "shipment")
	private String shipment;
	
	@Column(name = "probill")
	private String probill;
	
	@Column(name = "carrier_code")
	private String carrierCode;
	
	@Column(name = "carrier_service")
	private String carrierService;
	
	@Column(name = "trailer")
	private String trailer;
	
	@Column(name = "ship_name")
	private String shipName;
	
	@Column(name = "ship_addr1")
	private String shipAddress1;
	
	@Column(name = "ship_addr2")
	private String shipAddress2;

	@Column(name = "ship_addr3")
	private String shipAddress3;

	@Column(name = "ship_city")
	private String shipCity;
	
	@Column(name = "ship_state")
	private String shipState;
	
	@Column(name = "ship_zip")
	private String shipzip;
	
	@Column(name = "ship_cntry")
	private String shipCountry;
	
	@Column(name = "ship_custnum")
	private String shipCustomerNumber;
	
	@Column(name = "ship_phone")
	private String shipPhone;
	
	@Column(name = "total_pallet_qty")
	private int totalPalletQty;
	
	@Column(name = "total_carton_qty")
	private int totalCartonQty;
	
	
	@Column(name = "total_weight")
	private double totalWeight;
	
	@Column(name = "creation_queue_msg_id")
	private Long createQueueMsgId;
	
	@Column(name = "station")
	private String station;
	
	@Column(name = "seal")
	private String seal;
	
	@Column(name = "freight_payment_terms_type")
	private int freightPaymentTermsType;
	
	@Column(name = "create_stamp")
	private Date createDate;
	
	@Column(name = "create_user")
	private String createUser;
	
	@Column(name = "mod_counter")
	private int modCounter;
	
	public Bol() {
		super();
	}

	
	public Bol(String warehouse, String bol, String shipment, String carrierCode,
			String carrierService, String trailer, String shipName, String shipAddress1, String shipAddress2,
			String shipCity, String shipState, String shipCountry, String shipCustomerNumber, int totalPalletQty,
			double totalWeight, Long createQueueMsgId) {
		
		this.warehouse = warehouse;
		this.bol = bol;
		this.shipment = shipment;
		this.probill = "NONE";
		this.carrierCode = carrierCode;
		this.carrierService = carrierService;
		this.trailer = trailer;
		this.shipName = shipName;
		this.shipAddress1 = shipAddress1;
		this.shipAddress2 = shipAddress2;
		this.shipCity = shipCity;
		this.shipState = shipState;
		this.shipCountry = shipCountry;
		this.shipCustomerNumber = shipCustomerNumber;
		this.totalPalletQty = totalPalletQty;
		this.totalWeight = totalWeight;
		this.createQueueMsgId = createQueueMsgId;
		this.station = "BASE";
		this.seal = "";
		this.freightPaymentTermsType = 3;
		this.shipAddress3 = "";
		this.shipzip = "";
		this.shipPhone = "";
		this.totalCartonQty = 0;
		this.createDate = new Date();
		this.createUser = "system";
		this.modCounter = 0;
	}


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

	public String getBol() {
		return bol;
	}

	public void setBol(String bol) {
		this.bol = bol;
	}

	public String getShipment() {
		return shipment;
	}

	public void setShipment(String shipment) {
		this.shipment = shipment;
	}

	public String getProbill() {
		return probill;
	}

	public void setProbill(String probill) {
		this.probill = probill;
	}

	public String getCarrierCode() {
		return carrierCode;
	}

	public void setCarrierCode(String carrierCode) {
		this.carrierCode = carrierCode;
	}

	public String getCarrierService() {
		return carrierService;
	}

	public void setCarrierService(String carrierService) {
		this.carrierService = carrierService;
	}

	public String getTrailer() {
		return trailer;
	}

	public void setTrailer(String trailer) {
		this.trailer = trailer;
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

	public String getShipCountry() {
		return shipCountry;
	}

	public void setShipCountry(String shipCountry) {
		this.shipCountry = shipCountry;
	}

	public String getShipCustomerNumber() {
		return shipCustomerNumber;
	}

	public void setShipCustomerNumber(String shipCustomerNumber) {
		this.shipCustomerNumber = shipCustomerNumber;
	}

	public int getTotalPalletQty() {
		return totalPalletQty;
	}

	public void setTotalPalletQty(int totalPalletQty) {
		this.totalPalletQty = totalPalletQty;
	}

	public double getTotalWeight() {
		return totalWeight;
	}

	public void setTotalWeight(double totalWeight) {
		this.totalWeight = totalWeight;
	}

	public Long getCreateQueueMsgId() {
		return createQueueMsgId;
	}

	public void setCreateQueueMsgId(Long createQueueMsgId) {
		this.createQueueMsgId = createQueueMsgId;
	}
	
	public String getStation() {
		return station;
	}

	public void setStation(String station) {
		this.station = station;
	}
	
	public String getSeal() {
		return seal;
	}

	public void setSeal(String seal) {
		this.seal = seal;
	}

	public String getShipAddress3() {
		return shipAddress3;
	}

	public void setShipAddress3(String shipAddress3) {
		this.shipAddress3 = shipAddress3;
	}


	public String getShipzip() {
		return shipzip;
	}

	public void setShipzip(String shipzip) {
		this.shipzip = shipzip;
	}

	public String getShipPhone() {
		return shipPhone;
	}

	public void setShipPhone(String shipPhone) {
		this.shipPhone = shipPhone;
	}

	public int getTotalCartonQty() {
		return totalCartonQty;
	}

	public void setTotalCartonQty(int totalCartonQty) {
		this.totalCartonQty = totalCartonQty;
	}

	public int getFreightPaymentTermsType() {
		return freightPaymentTermsType;
	}

	public void setFreightPaymentTermsType(int freightPaymentTermsType) {
		this.freightPaymentTermsType = freightPaymentTermsType;
	}

	@Override
	public String toString() {
		return "Bol [id=" + id + ", warehouse=" + warehouse + ", bol=" + bol + ", shipment=" + shipment
				+ ", probill=" + probill + ", carrierCode=" + carrierCode + ", carrierService=" + carrierService
				+ ", trailer=" + trailer + ", shipName=" + shipName + ", shipAddress1=" + shipAddress1
				+ ", shipAddress2=" + shipAddress2 + ", shipCity=" + shipCity + ", shipState=" + shipState
				+ ", shipCountry=" + shipCountry + ", shipCustomerNumber=" + shipCustomerNumber + ", totalPalletQty="
				+ totalPalletQty + ", totalWeight=" + totalWeight + ", createQueueMsgId=" + createQueueMsgId + "]";
	}
	
}
