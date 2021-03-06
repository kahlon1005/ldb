package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "cp_h")
public class TaskCompletionEntity implements Serializable{

	private static final long serialVersionUID = -1655272342475380623L;

	
	@Id
	@Column(name = "cph_rid")
	private int id;
	
	@Column(name = "ob_oid")
	private String order;
	
	@Column(name = "task_code")
	private String taskCode;
	
	@Column(name = "sku")
	private String sku;
	
	@Column(name = "to_cont")
	private String container;
	
	@Column (name = "od_rid")
	private int orderDetailId;
	
	@Column(name = "qty")
	private int quantity;
	
	@ManyToOne
	@JoinColumn(name = "curr_inv")
	private InventoryEntity inventory;

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

	public String getSku() {
		return sku;
	}

	public void setSku(String sku) {
		this.sku = sku;
	}

	
	public String getContainer() {
		return container;
	}

	public void setContainer(String container) {
		this.container = container;
	}

	public int getOrderDetailId() {
		return orderDetailId;
	}

	public void setOrderDetailId(int orderDetailId) {
		this.orderDetailId = orderDetailId;
	}
	
	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public InventoryEntity getInventory() {
		return inventory;
	}

	public void setInventory(InventoryEntity inventory) {
		this.inventory = inventory;
	}
	
	

	public String getTaskCode() {
		return taskCode;
	}

	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}

	@Override
	public String toString() {
		return "TaskCompletionEntity [id=" + id + ", order=" + order + ", sku=" + sku + ",  orderDetailId=" + orderDetailId + "]";
	}
	
	
}
