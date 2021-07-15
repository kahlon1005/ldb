package com.bcldb.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

@Entity
@Table(name = "iv_f")
@NamedQueries({
	@NamedQuery(name = "InventoryEntity.InventoryStuckInTruckLocation", query = "select i from InventoryEntity i where i.warehouse = :warehouse and i.order = :orderNumber and i.location = 'TRUCK' and size(i.tasks) > 0"),
	@NamedQuery(name = "InventoryEntity.findAllInventoryStuckInTruckLocation", query = "select i from InventoryEntity i where i.location = 'TRUCK' and size(i.tasks) > 0" )
})
public class InventoryEntity implements Serializable {
	
	private static final long serialVersionUID = 1988297706887312323L;
	
	public final static String INVENTORY_STUCK_IN_TRUCK_LOCATION = "InventoryEntity.InventoryStuckInTruckLocation";  
	public final static String FIND_ALL_INVENTORY_STUCK_IN_TRUCK_LOCATION = "InventoryEntity.findAllInventoryStuckInTruckLocation"; 

	@Id
	@Column(name = "iv_rid")
	private int id;
	
	@Column(name = "ob_oid")
	private String order;
	
	@Column(name="loc")
	private String location;
	
	@Column(name="sku")
	private String sku;
	
	@Column(name="qty")
	private int qty;
	
	@Column(name="whse_code")
	private String warehouse;
	
	@Where(clause = "task_code = 'PICK'")
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "inventory")
	private List<TaskCompletionEntity> tasks;

	
	public InventoryEntity() {
		super();	
	}

	public InventoryEntity(int id, String order, String location, String sku, String warehouse) {
		super();
		this.id = id;
		this.order = order;
		this.location = location;
		this.sku = sku;
		this.warehouse = warehouse;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
	
	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}
	
	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public List<TaskCompletionEntity> getTasks() {
		return tasks;
	}

	public void setTasks(List<TaskCompletionEntity> tasks) {
		this.tasks = tasks;
	}
	
	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	@Override
	public String toString() {
		return "InventoryEntity [id=" + id + ", order=" + order + ", location=" + location + ", sku=" + sku + ", qty="
				+ qty + ", warehouse=" + warehouse + ", tasks=" + tasks + "]";
	}
	
}
