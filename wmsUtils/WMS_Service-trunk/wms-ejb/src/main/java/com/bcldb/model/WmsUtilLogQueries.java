package com.bcldb.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "wmsutil_log_sql")
public class WmsUtilLogQueries {
	
	@Id
	@Column(name = "sql_rid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;
	
	@Column(name ="util_rid")
	private long logId;
	
	@Column(name= "executed_query")
	private String query;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "create_stamp")
	private Date createStamp = new Date();

	public WmsUtilLogQueries() {
		super();
	}

	public WmsUtilLogQueries(long logId, String query) {
		super();
		this.logId = logId;
		this.query = query;
	}
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getLogId() {
		return logId;
	}

	public void setLogId(long logId) {
		this.logId = logId;
	}

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public Date getCreateStamp() {
		return createStamp;
	}

	public void setCreateStamp(Date createStamp) {
		this.createStamp = createStamp;
	}

	@Override
	public String toString() {
		return "WmsUtilLogDetails [id=" + id + ", logId=" + logId + ", query=" + query + ", createStamp=" + createStamp + "]";
	}
	
	
}
