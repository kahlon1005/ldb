package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "wms_system_properties_ldb")
@NamedQueries({
	@NamedQuery(name = "SystemPropertiesEntity.findDefaultInstance", query = "select p from SystemPropertiesEntity p where p.warehouse = :warehouse and  p.propertyName = 'INSTANCE_NAME'")
})
public class SystemPropertiesEntity implements Serializable {
		
	private static final long serialVersionUID = 2606373374117660618L;

	public static final String FIND_DEFAULT_INSTANCE = "SystemPropertiesEntity.findDefaultInstance";
	
	@Id
	@Column(name = "rid")
	private long id;
	

	@Column(name = "whse_code")
	private String warehouse;
	
	
	@Column(name = "property_name")
	private String propertyName;
	
	@Column(name = "custom_char_01")
	private String propertyValue;

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

	public String getPropertyName() {
		return propertyName;
	}

	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}

	public String getPropertyValue() {
		return propertyValue;
	}

	public void setPropertyValue(String propertyValue) {
		this.propertyValue = propertyValue;
	}
	
	
	
}
