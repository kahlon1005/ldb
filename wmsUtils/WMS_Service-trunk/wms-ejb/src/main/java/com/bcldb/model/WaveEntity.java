package com.bcldb.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "wv_f")
@NamedQueries({
		@NamedQuery(name = "WaveEntity.findWaveWithunplannedCommands", 
				query = "select w from WaveEntity w where w.waveType = 'PICK' and w.status = 'SRLS' and "
						+ "exists(select 1 from QueueCommands q where q.warehouse = w.warehouse and q.wave = w.wave and q.taskCode = 'PICK' and (q.status <> 'PLN' or q.status <> 'PLNP'))"),
		@NamedQuery(name = "WaveEntity.findStuckWaveReleaseMsg", 
				query = "select w from WaveEntity w where w.waveType = 'PICK' and w.status = 'SRLS' and not exists (select 1 from OutboundOrderEntity o where o.warehouse = w.warehouse and o.wave = w.wave and o.lockId is not null)"),
		@NamedQuery(name = "WaveEntity.findWaveByName", query = "select w from WaveEntity w where w.wave = :wave")

})
public class WaveEntity implements Serializable {

	private static final long serialVersionUID = 2346508759605961691L;

	public final static String FIND_STUCK_WAVE_WITH_UNPLANNED_COMMANDS = "WaveEntity.findWaveWithunplannedCommands";
	public final static String FIND_STUCK_WAVE_RELEASE_MSG = "WaveEntity.findStuckWaveReleaseMsg";
	public final static String FIND_WAVE_BY_NAME = "WaveEntity.findWaveByName";
	

	@Id
	@Column(name = "wv_rid")
	private long id;

	@Column(name = "wave")
	private String wave;

	@Column(name = "wave_type")
	private String waveType;

	@Column(name = "wave_stt")
	private String status;

	@Column(name = "whse_code")
	private String warehouse;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getWave() {
		return wave;
	}

	public void setWave(String wave) {
		this.wave = wave;
	}

	public String getWaveType() {
		return waveType;
	}

	public void setWaveType(String waveType) {
		this.waveType = waveType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}

	

	@Override
	public String toString() {
		return "WaveEntity [id=" + id + ", wave=" + wave + ", waveType=" + waveType + ", status=" + status
				+ ", warehouse=" + warehouse + "]";
	}

}
