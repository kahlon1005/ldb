package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "shipunit_f")
@NamedQueries({
	@NamedQuery(name = "ShippingActivityEntity.findByContainer", query = "select s from ShippingActivityEntity s where s.container = :container")
})
public class ShippingActivityEntity implements Serializable{

	private static final long serialVersionUID = 5684860581241032224L;
	
	public static final String FIND_BY_CONTAINER = "ShippingActivityEntity.findByContainer";

	@Id
	@Column(name = "shipunit_rid")
	private int id;
	
	@Column(name = "cont")
	private String container;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getContainer() {
		return container;
	}

	public void setContainer(String container) {
		this.container = container;
	}
	

	@Override
	public String toString() {
		return "ShippingActivityEntity [id=" + id + ", container=" + container + "]";
	}
	
	
}
