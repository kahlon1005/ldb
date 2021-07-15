package com.bcldb.model;

import java.io.Serializable;

public class MpackOrderId implements Serializable{
	
	private static final long serialVersionUID = -6537687626996800674L;
	
	private long mpackId;	
	private long mpackOrderSeq;
	
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
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (mpackId ^ (mpackId >>> 32));
		result = prime * result + (int) (mpackOrderSeq ^ (mpackOrderSeq >>> 32));
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
		MpackOrderId other = (MpackOrderId) obj;
		if (mpackId != other.mpackId)
			return false;
		if (mpackOrderSeq != other.mpackOrderSeq)
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "MpackOrderId [mpackId=" + mpackId + ", mpackOrderSeq=" + mpackOrderSeq + "]";
	}
	
	

}
