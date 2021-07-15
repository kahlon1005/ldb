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
@Table(name = "mpack")
@NamedQueries({
	@NamedQuery(name = "MpackEntity.findByName", query = "select m from MpackEntity m where m.warehouse = :warehouse and m.masterPackingList = :packList")
})
public class MpackEntity implements Serializable{

	private static final long serialVersionUID = 7163317535193801091L;
	public static final String FIND_BY_NAME = "MpackEntity.findByName";


	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "mpack_id")
	private long id;
	
	
	@Column(name = "master_packing_list")
	private String masterPackingList;
	
	@Column(name = "whse_code")
	private String warehouse;
	
	@Column(name = "creation_queue_msg_id")
	private Long creationQueueMsgId;
	
	@Column(name = "station")
	private String station;
	
	@Column(name= "tot_weight")
	private int totWeight;
	
	@Column(name = "total_pcs")
	private int totalPieces;
	
	@Column(name = "create_stamp")
	private Date createDate;
	
	@Column(name = "create_user")
	private String createdBy;
	
	@Column(name = "mod_counter")
	private int modifiedCounter;
	
	@Column(name = "memo")
	private String memo;
	
	@Column(name = "trailer")
	private String trailer;
	
	
	public MpackEntity() {
		super();
	}


	public MpackEntity(String masterPackingList, String warehouse, String station) {
		super();
		this.masterPackingList = masterPackingList;
		this.warehouse = warehouse;
		this.creationQueueMsgId = null;
		this.station = station;
		
		this.totWeight = 0;
		this.totalPieces = 0;
		this.createDate = new Date();
		this.createdBy = "system";
		this.modifiedCounter = 0;
		this.memo = "";
		this.trailer = "";
	}
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getMasterPackingList() {
		return masterPackingList;
	}

	public void setMasterPackingList(String masterPackingList) {
		this.masterPackingList = masterPackingList;
	}

	public String getWarehouse() {
		return warehouse;
	}

	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}
	
	public Long getCreationQueueMsgId() {
		return creationQueueMsgId;
	}

	public void setCreationQueueMsgId(Long creationQueueMsgId) {
		this.creationQueueMsgId = creationQueueMsgId;
	}
	
	

	public String getStation() {
		return station;
	}

	public void setStation(String station) {
		this.station = station;
	}

	public int getTotWeight() {
		return totWeight;
	}

	public void setTotWeight(int totWeight) {
		this.totWeight = totWeight;
	}

	public int getTotalPieces() {
		return totalPieces;
	}

	public void setTotalPieces(int totalPieces) {
		this.totalPieces = totalPieces;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public int getModifiedCounter() {
		return modifiedCounter;
	}

	public void setModifiedCounter(int modifiedCounter) {
		this.modifiedCounter = modifiedCounter;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getTrailer() {
		return trailer;
	}

	public void setTrailer(String trailer) {
		this.trailer = trailer;
	}

	@Override
	public String toString() {
		return "MpackEntity [id=" + id + ", masterPackingList=" + masterPackingList + ", warehouse=" + warehouse + "]";
	}
	
	
	
}
