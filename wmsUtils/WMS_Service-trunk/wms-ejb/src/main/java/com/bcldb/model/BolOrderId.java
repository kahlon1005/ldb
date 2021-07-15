package com.bcldb.model;

import java.io.Serializable;

public class BolOrderId implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private long bolId; 
	private long bolOrderSeq;
	
	public BolOrderId() {
		super();
	}

	public BolOrderId(long bolId, long bolOrderSeq) {
		super();
		this.bolId = bolId;
		this.bolOrderSeq = bolOrderSeq;
	}
	
	public long getBolId() {
		return bolId;
	}
	public void setBolId(long bolId) {
		this.bolId = bolId;
	}
	public long getBolOrderSeq() {
		return bolOrderSeq;
	}
	public void setBolOrderSeq(long bolOrderSeq) {
		this.bolOrderSeq = bolOrderSeq;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (bolId ^ (bolId >>> 32));
		result = prime * result + (int) (bolOrderSeq ^ (bolOrderSeq >>> 32));
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BolOrderId other = (BolOrderId) obj;
		if (bolId != other.bolId)
			return false;
		if (bolOrderSeq != other.bolOrderSeq)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "BolOrderId [bolId=" + bolId + ", bolOrderSeq=" + bolOrderSeq + "]";
	}
	
}
