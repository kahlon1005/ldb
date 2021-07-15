package com.bcldb.model;

import java.io.Serializable;


public class CpackOrderId implements Serializable{

	private static final long serialVersionUID = -2203275285391135343L;
	
	private long cpackId;
	private long cpackOrderSeq;
	
	
	public CpackOrderId() {
		super();
	}

	public CpackOrderId(long cpackId, long cpackOrderSeq) {
		super();
		this.cpackId = cpackId;
		this.cpackOrderSeq = cpackOrderSeq;
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (cpackId ^ (cpackId >>> 32));
		result = prime * result + (int) (cpackOrderSeq ^ (cpackOrderSeq >>> 32));
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
		CpackOrderId other = (CpackOrderId) obj;
		if (cpackId != other.cpackId)
			return false;
		if (cpackOrderSeq != other.cpackOrderSeq)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "CpackOrderId [cpackId=" + cpackId + ", cpackOrderSeq=" + cpackOrderSeq + "]";
	}

}
