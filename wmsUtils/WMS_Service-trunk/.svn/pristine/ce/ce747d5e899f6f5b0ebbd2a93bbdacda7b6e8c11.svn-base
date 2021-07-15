package com.bcldb.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "wmsutil_log")
public class WmsUtilLog implements Serializable{

	private static final long serialVersionUID = 5350145303143824004L;

	@Id
	@Column(name = "util_rid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;
	
	@Column(name = "incident_num")
	private String incidentNumber;
	
	@Column(name = "transact_type")
	private String transactionType;
	
	@Column(name = "transact_num")
	private String transationNumber;
	
	@Column(name = "error_msg")
	private String errorMessage;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "create_user")
	private String createUser;
	
	@Column(name = "create_stamp")
	@Temporal(TemporalType.TIMESTAMP)
	private Date createStamp = new Date();
	
	
	public WmsUtilLog() {
		super();
	}

	public WmsUtilLog(String incidentNumber, String transactionType, String transationNumber, String errorMessage,
			String warehouse, String createUser) {
		super();
		this.incidentNumber = incidentNumber;
		this.transactionType = transactionType;
		this.transationNumber = transationNumber;
		this.errorMessage = errorMessage;
		this.warehouse = warehouse;
		this.createUser = createUser;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getIncidentNumber() {
		return incidentNumber;
	}

	public void setIncidentNumber(String incidentNumber) {
		this.incidentNumber = incidentNumber;
	}

	public String getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(String transactionType) {
		this.transactionType = transactionType;
	}

	public String getTransationNumber() {
		return transationNumber;
	}

	public void setTransationNumber(String transationNumber) {
		this.transationNumber = transationNumber;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getCreateStamp() {
		return createStamp;
	}

	public void setCreateStamp(Date createStamp) {
		this.createStamp = createStamp;
	}

	@Override
	public String toString() {
		return "WmsUtilLog [id=" + id + ", incidentNumber=" + incidentNumber + ", transactionType=" + transactionType
				+ ", transationNumber=" + transationNumber + ", errorMessage=" + errorMessage + ", warehouse="
				+ warehouse + ", createUser=" + createUser + ", createStamp=" + createStamp + "]";
	}
	
	
}
