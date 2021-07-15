package com.bcldb.model;

import java.io.Serializable;

public class BolLineId implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long bolId;
	private long bolLineSeq;
	
	public BolLineId() {
		super();
	}
	public BolLineId(long bolId, long bolLineSeq) {
		super();
		this.bolId = bolId;
		this.bolLineSeq = bolLineSeq;
	}
	public long getBolId() {
		return bolId;
	}
	public void setBolId(long bolId) {
		this.bolId = bolId;
	}
	public long getBolLineSeq() {
		return bolLineSeq;
	}
	public void setBolLineSeq(long bolLineSeq) {
		this.bolLineSeq = bolLineSeq;
	}
	
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (bolId ^ (bolId >>> 32));
		result = prime * result + (int) (bolLineSeq ^ (bolLineSeq >>> 32));
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
		BolLineId other = (BolLineId) obj;
		if (bolId != other.bolId)
			return false;
		if (bolLineSeq != other.bolLineSeq)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "BolLineId [bolId=" + bolId + ", bolLineSeq=" + bolLineSeq + "]";
	}
	
}
