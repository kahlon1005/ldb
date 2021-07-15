package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "gn_f")
@NamedQueries({
	@NamedQuery(name= "GeneratedNumberEntity.findLastGeneratedIdByType", query = "select g\tFROM GeneratedNumberEntity g WHERE g.warehouse = :warehouse AND g.documentType = :documentType")
})
public class GeneratedNumberEntity implements Serializable{
	
	private static final long serialVersionUID = -5421807575236037751L;

	public static final String FIND_LAST_GENERATED_ID_BY_TYPE = "GeneratedNumberEntity.findLastGeneratedIdByType";

	@Id 
	@Column(name = "gn_rid")
	private long id;

	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "gn_type")
	private String documentType;
	
	@Column(name = "prefix")
	private String prefix;
	
	@Column(name = "last_num")
	private int lastNumber;

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

	public String getDocumentType() {
		return documentType;
	}

	public void setDocumentType(String documentType) {
		this.documentType = documentType;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public int getLastNumber() {
		return lastNumber;
	}

	public void setLastNumber(int lastNumber) {
		this.lastNumber = lastNumber;
	}	
	
	public String getFullLastNumber() {
		return prefix.concat(Integer.toString(lastNumber));
	}

	@Override
	public String toString() {
		return "GeneratedNumberEntity [id=" + id + ", warehouse=" + warehouse + ", documentType=" + documentType
				+ ", prefix=" + prefix + ", lastNumber=" + lastNumber + "]";
	}
	
	
	
}
