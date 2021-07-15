package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "om_f")
public class OutboundOrderEntity implements Serializable {

	private static final long serialVersionUID = 7828069651034153744L;
	
	@Id
	@Column(name = "om_rid")
	private long id;
	
	
	@Column(name = "ob_oid")
	private String orderNumber;
	
	@Column(name = "wave")
	private String wave;
	
	@Column(name = "lock_id")
	private long lockId;

	@Column(name = "whse_code")
	private String warehouse;
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}
	
	public String getWave() {
		return wave;
	}

	public void setWave(String wave) {
		this.wave = wave;
	}

	public long getLockId() {
		return lockId;
	}

	public void setLockId(long lockId) {
		this.lockId = lockId;
	}
	
	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	@Override
	public String toString() {
		return "OutboundOrderEntity [id=" + id + ", orderNumber=" + orderNumber + ", lockId=" + lockId + "]";
	}
	
	
	
}
