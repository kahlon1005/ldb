package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@IdClass(BolLineId.class)
@Table(name = "bol_l")
public class BolLine implements Serializable {
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name ="bol_id")
	private long bolId;
	
	@Id
	@Column(name="bol_l_seq")
	private long bolLineSeq;
	
	@Column(name = "pallet_qty")
	private int palletQuantity;
	
	@Column(name = "carton_qty")
	private int cartonQuantity;
	
	@Column(name = "weight")
	private double weight;
	
	@Column(name = "freight_class")
	private String frightClass;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	

	public BolLine() {
		super();
	}

	public BolLine(long bolId, int palletQuantity, int cartonQuantity, double weight,
			String frightClass, String warehouse) {
		this.bolId = bolId;
		this.bolLineSeq = 1;
		this.palletQuantity = palletQuantity;
		this.cartonQuantity = cartonQuantity;
		this.weight = weight;
		this.frightClass = frightClass;
		this.warehouse = warehouse;
	}

	public long getBolId() {
		return bolId;
	}

	public void setBolId(long bolId) {
		this.bolId = bolId;
	}

	

	public int getPalletQuantity() {
		return palletQuantity;
	}

	public void setPalletQuantity(int palletQuantity) {
		this.palletQuantity = palletQuantity;
	}

	public int getCartonQuantity() {
		return cartonQuantity;
	}

	public void setCartonQuantity(int cartonQuantity) {
		this.cartonQuantity = cartonQuantity;
	}

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public String getFrightClass() {
		return frightClass;
	}

	public void setFrightClass(String frightClass) {
		this.frightClass = frightClass;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	@Override
	public String toString() {
		return "BolLine [bolId=" + bolId + ", bolLineSeq=" + bolLineSeq + ", palletQuantity=" + palletQuantity
				+ ", cartonQuantity=" + cartonQuantity + ", weight=" + weight + ", frightClass=" + frightClass
				+ ", warehouse=" + warehouse + "]";
	}

	
}
