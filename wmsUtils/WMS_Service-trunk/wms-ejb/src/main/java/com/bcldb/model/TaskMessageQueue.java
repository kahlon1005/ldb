package com.bcldb.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name="mq_warehouse_task")
@NamedQueries({
	@NamedQuery(name = "TaskMessageQueue.FindALL", query = "select q from TaskMessageQueue q where q.queueName = 'wms_wave_releasing'"),
	@NamedQuery(name = "TaskMessageQueue.FindByRecordId", query = "select q from TaskMessageQueue q where q.queueName = :queueName  and q.body like :recordId")
})

public class TaskMessageQueue implements Serializable{

	private static final long serialVersionUID = 1518013807277435804L;
	
	public final static String FIND_ALL = "TaskMessageQueue.FindALL";
	public final static String FIND_BY_RECORD_ID = "TaskMessageQueue.FindByRecordId";
	
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name = "queue_msg_id")
	private long id;
	
	@Column(name = "msg_group")
	private String warehouse;
	
	@Column(name = "queue_name")
	private String queueName;
	
	@Column(name = "is_error")
	private boolean error;
	
	
	@Column(name = "instance_name")
	private String instanceName;
	
	@Column(name = "run_as_user_name")
	private String runUserName;
	
	@Column(name = "msg_header")
	private String header;
	
	@Column(name= "msg_body")
	private String body;
	
	@Column(name="create_user")
	private String createdBy;
	
	
	@Column(name="mod_user")
	private String modifiedBy;
	
	@Column(name="mod_counter")
	private int modifiedConter;
	
	@Column(name = "create_stamp")
	private Date createdDate;
	
	@Column(name = "mod_stamp")
	private Date modifiedDate;
	
	public TaskMessageQueue() {
		super();
	}

	public TaskMessageQueue(String warehouse, String queueName, String instanceName, String header, String body) {
		super();
		this.warehouse = warehouse;
		this.queueName = queueName;
		this.instanceName = instanceName;
		this.header = header;
		this.body = body;
		this.error = Boolean.FALSE;
		this.runUserName = "system";
		this.createdBy = "system";
		this.modifiedBy = "system";
		this.modifiedConter = 0;
		this.createdDate = new Date();
		this.modifiedDate = new Date();
		
	}
	
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

	public String getQueueName() {
		return queueName;
	}

	public void setQueueName(String queueName) {
		this.queueName = queueName;
	}

	public boolean isError() {
		return error;
	}

	public void setError(boolean error) {
		this.error = error;
	}

	public String getBody() {
		return body;		
	}

	public void setBody(String body) {
		this.body = body;
	}
	
	
	public String getInstanceName() {
		return instanceName;
	}

	public void setInstanceName(String instanceName) {
		this.instanceName = instanceName;
	}
	
	public String getRunUserName() {
		return runUserName;
	}

	public void setRunUserName(String runUserName) {
		this.runUserName = runUserName;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public String getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public int getModifiedConter() {
		return modifiedConter;
	}

	public void setModifiedConter(int modifiedConter) {
		this.modifiedConter = modifiedConter;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Date getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	@Override
	public String toString() {
		return "TaskMessageQueue [id=" + id + ", warehouse=" + warehouse + ", queueName=" + queueName + ", error="
				+ error + ", body=" + body + "]";
	}
	

}
