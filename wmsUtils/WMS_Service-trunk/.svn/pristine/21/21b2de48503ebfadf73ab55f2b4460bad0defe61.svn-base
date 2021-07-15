package com.bcldb.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "sh_f")
@NamedQueries({
	@NamedQuery(name = "ShipmentEntity.shipmentStuckInTruckLocation", query = "select s from ShipmentEntity s where s.order in (select i.order from InventoryEntity i where i.location = 'TRUCK' and i.order = s.order)")
})
public class ShipmentEntity implements Serializable {
	
	private static final long serialVersionUID = -1356321616304091860L;
	
	public static final String SHIPMENT_STUCK_IN_TRUCK_LOCATION = "ShipmentEntity.shipmentStuckInTruckLocation";

	@Id
	@Column(name = "sh_rid")
	private int id;
	
	@Column(name = "ob_oid")
	private String order;
	
	@Column(name = "ob_type")
	private String orderType;
	
	@Column(name = "task_code")
	private String taskCode;
	
	@Column(name = "ship_cmp_stt")
	private String status;
	
	@Column(name = "create_stamp")
	private Date createDateTime;

	
	public ShipmentEntity() {
		super();
	}
	
	public ShipmentEntity(int id, String order) {
		super();
		this.id = id;
		this.order = order;
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
	public String getOrderType() {
		return orderType;
	}
	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}
	public String getTaskCode() {
		return taskCode;
	}
	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getCreateDateTime() {
		return createDateTime;
	}
	public void setCreateDateTime(Date createDateTime) {
		this.createDateTime = createDateTime;
	}
	@Override
	public String toString() {
		return "ShipCompletion [id=" + id + ", order=" + order + ", orderType=" + orderType + ", taskCode=" + taskCode
				+ ", status=" + status + "]";
	}
	
}
