package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "cm_f")
@NamedQueries({
	@NamedQuery(name = "QueueCommands.findPendingWavePicks", query = "select q from QueueCommands q where q.wave = :wave and q.warehouse = :warehouse and q.taskCode = 'PICK' and q.status not in ('PLN','PLNP')")
})
public class QueueCommands implements Serializable{

	private static final long serialVersionUID = -7617690154235729148L;

	public static final String FIND_PENDING_WAVE_PICKS = "QueueCommands.findPendingWavePicks";
	
	@Id
	@Column(name = "cm_rid")
	private long id;
	
	@Column(name = "cmd_stt")
	private String status;
	
	@Column(name = "wave")
	private String wave;
	
	@Column(name = "task_code")
	private String taskCode;
	
	@Column(name = "whse_code")
	private String warehouse;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getWave() {
		return wave;
	}

	public void setWave(String wave) {
		this.wave = wave;
	}

	public String getTaskCode() {
		return taskCode;
	}

	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	@Override
	public String toString() {
		return "QueueCommands [id=" + id + ", status=" + status + ", wave=" + wave + ", taskCode=" + taskCode
				+ ", warehouse=" + warehouse + "]";
	}
	
		

}
