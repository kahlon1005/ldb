package com.bcldb.ejb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.jboss.ejb3.annotation.Clustered;
import org.jboss.logging.Logger;

import com.bcldb.dto.TransactionDto;
import com.bcldb.dto.TransactionReturnType;
import com.bcldb.helper.DTOConverter;
import com.bcldb.model.Bol;
import com.bcldb.model.BolLine;
import com.bcldb.model.BolOrder;
import com.bcldb.model.Carrier;
import com.bcldb.model.CpackEntity;
import com.bcldb.model.CpackOrderEntity;
import com.bcldb.model.GeneratedNumberEntity;
import com.bcldb.model.InventoryEntity;
import com.bcldb.model.MpackEntity;
import com.bcldb.model.MpackOrderEntity;
import com.bcldb.model.OutboundOrderCurrentHistory;
import com.bcldb.model.QueueCommands;
import com.bcldb.model.ShippableUnitHistory;
import com.bcldb.model.ShippingActivityEntity;
import com.bcldb.model.SystemPropertiesEntity;
import com.bcldb.model.TaskCompletionEntity;
import com.bcldb.model.TaskMessageQueue;
import com.bcldb.model.WaveEntity;
import com.bcldb.model.WmsUtilLog;
import com.bcldb.model.WmsUtilLogQueries;
import com.bcldb.util.WMSUtilServiceException;


@Stateless
@Clustered
public class WmsServiceBean {

	private static final Logger log = Logger.getLogger(WmsServiceBean.class);

	private static final String INVENTORY_RECORD_NOT_FOUND = "Inventory Stuck in Truck location not found for order : ";
	private static final String MSG_EXISTS_WAVE_PENDING_PICK_COMMANDS = "Please perform container pick complete before applying fix.";

	private static final String TRANSACTION_TYPE_ORDER = "ORDER";
	private static final String TRANSACTION_TYPE_WAVE = "WAVE";
	private static final String TRANSACTION_TYPE_DOC = "DOC";

	private static final String MSG_DATA_FIX_SOLUTION_NOT_IMPLEMENTED = "Solution for this senario is not implemented, please contact support for manual fix.";

	private static final String MSG_TASK_MESSAGE_NOT_EXISTS = "Wave release queue message not found.";

	private static final String MSG_TASK_QUEUE_IN_ERROR = "Wave release queue message is in error.";

	private static final String WAREHOUSE_INSTANCE_PROPERTY_NOT_FOUND = "Warehouse instance name not setup in System Properties";

	private static final String STATION_BASE = "BASE";

	private static final String DOCUMENT_GENERATION_TYPE_CPCK = "CPCK";

	private static final String DOCUMENT_GENERATION_TYPE_PACK = "PACK";

	private static final String DOCUMENT_GENERATION_TYPE_BOL = "BOL";

	private static final String TRANSACTION_UPDATED_SUCCESSFULLY = "Transaction updated successfully";
	
	@PersistenceContext
	private EntityManager em;

	DTOConverter converter = new DTOConverter();

	public TransactionReturnType getStuckShipments() { 

		TransactionReturnType ret = new TransactionReturnType();
		
		// 1. Inventory Stuck in truck location
		List<TransactionDto> taskCompletionEntities = getInventoryStuckInTruckLocation();
		ret.getTransactionType().addAll(taskCompletionEntities);
		
		//2. Stuck Waves
		List<TransactionDto>  stuckWaves = getStuckWave();
		ret.getTransactionType().addAll(stuckWaves);
		
		return ret;
	}
	
	public Map<String, String> updateStuckShipment(String transactionNumber, String transactionType, String incidentNumber, String username, String errorMessage, String warehouse) throws WMSUtilServiceException {
		
		Map<String, String> result = new HashMap<String, String>();
		Boolean success = Boolean.FALSE;
		String message = null;
		
		long logId = 0;
		try {
			
			logId = addWmsUtilLogHeader(incidentNumber, transactionType, transactionNumber,errorMessage, warehouse, username);
			if(transactionType.equalsIgnoreCase(TRANSACTION_TYPE_ORDER)) {
				List<InventoryEntity> inventories = getInventoryStuckInTruckLocation(logId, transactionNumber, warehouse);
				if (inventories == null || inventories.isEmpty()) {
					throw new WMSUtilServiceException(INVENTORY_RECORD_NOT_FOUND + transactionNumber);
				}
				for (InventoryEntity inventory : inventories) {
					List<TaskCompletionEntity> tasks = inventory.getTasks();
					for(TaskCompletionEntity task : tasks) {
						ShippingActivityEntity shippingActivity = getShippingActivity(task.getContainer());
						if (shippingActivity == null || shippingActivity.getId() == 0) {							
							deleteInventory(logId, inventory.getId());
							revertOrderDetails(logId, task.getOrderDetailId(), task.getQuantity());
							message = "Pick reverted for order :" + task.getOrder() + " and sku :"+ task.getSku() + " for quantity :" + task.getQuantity() + ".\n Please perform basic receiving to adjust the inventory with reason code 30 and rewave or cancel order.";
						}else {						
							updateInventory(logId, task.getContainer(), shippingActivity.getId(), inventory.getId());							
							updateOrderDetails(logId, task.getOrderDetailId(), task.getQuantity());
							updateWarehouseTask(logId);	
							message = "Order number: " + transactionNumber + " update successfully.";
						}
					}					
				}
			} else if(transactionType.equalsIgnoreCase(TRANSACTION_TYPE_WAVE)) {
				WaveEntity waveEntity = getWave(transactionNumber);
				int count = getPendingWavePicks(transactionNumber, waveEntity.getWarehouse());
				
				if(count > 0) {
					throw new WMSUtilServiceException(MSG_EXISTS_WAVE_PENDING_PICK_COMMANDS);				
				}else {
					int taskId = getTaskMessageQueue(waveEntity.getId(), "wms_wave_releasing");
					switch (taskId) {
					case 0:
						insertTaskMessageQueue(logId, "wms_wave_releasing", waveEntity.getId(), waveEntity.getWarehouse(), null);	
						break;
					case 1:
						resetTaskMessageQueue(logId, waveEntity.getWarehouse());	
						break;
					default:
						break;
					}					
				}
				message = "Wave number :" + transactionNumber + " update successfully.";
				
			} else if(transactionType.equalsIgnoreCase(TRANSACTION_TYPE_DOC)){
				
				List<ShippableUnitHistory> containers = getShipmentContainers(warehouse, transactionNumber);
				if(containers == null || containers.isEmpty()) {
					throw new WMSUtilServiceException("Shippable Unit History (shipunit_h) not found for shipment : " + transactionNumber);
				}
				
				createContainerPackingList(logId, containers);
				createMasterPackingList(logId, warehouse, transactionNumber);
				
				String bol = getShipmentBol(containers);
				log.info("bol number is : " + bol);
				createBol(logId, warehouse, transactionNumber, bol);		
				message = "Shipping documents are created sucessfully, please use reprint option in Tecsys for printing.";
			
			}else {
				throw new WMSUtilServiceException(MSG_DATA_FIX_SOLUTION_NOT_IMPLEMENTED);
			}
			success  = Boolean.TRUE;
		} catch (WMSUtilServiceException e) {			
			throw new WMSUtilServiceException(e.getMessage());
		}catch (Exception e) {
			log.error(e.getMessage());
			throw new WMSUtilServiceException(e);
		}
		
		if(null == message) {
			message = TRANSACTION_UPDATED_SUCCESSFULLY;
		}
		
		result.put("success", success.toString());
		result.put("message", message);
		return result;
		
	}
	

	//find first bol
	private String getShipmentBol(List<ShippableUnitHistory> units) {

		for(ShippableUnitHistory unit : units ) {
			if(null != unit.getBol() && !unit.getBol().trim().isEmpty()) {
				return unit.getBol();
			}
		}		
		return null;		
	}

	//create bol 
	private void createBol(long logId, String warehouse, String shipment, String bolNumber) {
		
		OutboundOrderCurrentHistory order = getShipmentOrderDetails(warehouse, shipment);
		Carrier carrier = getCarrier(warehouse, order.getCarrierService());
		String trailer = getShipmentTrailer(warehouse, shipment);
		int palletCount = getPalletCount(warehouse, shipment);
		double shipmentWeight = getShipmentWeight(warehouse, shipment);
		
		if (null == bolNumber) {
			log.info("create new bol ...");
			bolNumber = getLastGeneratedNumber(warehouse, DOCUMENT_GENERATION_TYPE_BOL);
		}else {						
			deleteBol(logId, warehouse, bolNumber);
		}

		Bol bol = new Bol(warehouse, bolNumber, shipment, carrier.getCarrierCode(), order.getCarrierService(), trailer,
				order.getShipName(), order.getShipAddress1(), order.getShipAddress2(), order.getShipCity(),
				order.getShipState(), order.getShipCounty(), order.getShipCustomerNumber(), palletCount, shipmentWeight,
				null);

		em.persist(bol);
		addLogDetails(logId, "Insert into bol --> bol_id = " + bol.getId());

		BolOrder bolOrder = new BolOrder(bol.getId(), order.getOrder(), warehouse);
		em.persist(bolOrder);

		addLogDetails(logId, "Insert into bol_po --> bol_id = " + bol.getId());

		BolLine bolLine = new BolLine(bol.getId(), palletCount, 0, shipmentWeight, "", warehouse);
		em.persist(bolLine);

		addLogDetails(logId, "Insert into bol_line --> bol_id = " + bol.getId());

		updateShipmentBol(logId, warehouse, shipment, bol.getBol());
		
	}
	
	private void deleteBol(long logId, String warehouse, String bolNumber) {
		long bolId = findBolByBolNumber(warehouse, bolNumber);
		log.info("delete bol "  + bolId);
		deleteBolLine(logId, bolId);
		deleteBolOrder(logId, bolId);
		
		String sql = "delete bol where bol_id = " + bolId;		
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
		
	}

	private void deleteBolLine(long logId, long bolId) {
		String sql = "delete bol_l where bol_id = " + bolId;		
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}
	
	private void deleteBolOrder (long logId, long bolId) {
		String sql = "delete bol_po where bol_id = " + bolId;		
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}
	

	@SuppressWarnings("unchecked")
	private long findBolByBolNumber(String warehouse, String bol) {
		Query query = em.createNamedQuery(Bol.FIND_BOL_BY_BOLNUMBER);
		query.setParameter("warehouse", warehouse);
		query.setParameter("bol", bol);
		List<Bol> entity = query.getResultList();
		if(!entity.isEmpty()) {
			return entity.get(0).getId();
		}
		return -1;
	}

	//update shipment with bol
	private int updateShipmentBol(long logId, String warehouse, String shipment, String bol) {
		
		String sql = "update shipunit_h set bol = '"	+ bol + "' where whse_code = '" + warehouse + "' and shipment = '" + shipment + "'";
		Query query = em.createNativeQuery(sql);
		int count = query.executeUpdate();
		addLogDetails(logId, sql);
		return count;	
		
	}

	
	private long addWmsUtilLogHeader(String incidentNumber, String transactionType, String transactionNumber, String errorMessage, String warehouse, String username) {
		WmsUtilLog wmsUtilLogheader = new WmsUtilLog(incidentNumber, transactionType, transactionNumber, errorMessage, warehouse, username);
		em.persist(wmsUtilLogheader);
		return wmsUtilLogheader.getId();
	}
	
	private void addLogDetails(long logId, String sql) {	
		
		WmsUtilLogQueries wmsUtilLogQueries = new WmsUtilLogQueries(logId, sql);
		em.persist(wmsUtilLogQueries);
	}
	
	
	private void createMasterPackingList(long logId, String warehouse, String shipment) {
		String packList = getLastGeneratedNumber(warehouse, DOCUMENT_GENERATION_TYPE_PACK);
		MpackEntity mpack = insertPackingList(logId, warehouse, packList, STATION_BASE);
		updateShipmentMasterPackingList(logId, warehouse, shipment, packList);
		
		OutboundOrderCurrentHistory order = getShipmentOrderDetails(warehouse, shipment);		
		MpackOrderEntity mpackOrder = new MpackOrderEntity(mpack.getId(), order.getId(), order.getCarrierService(), order.getShipment(), order.getWarehouse()); 
		
		em.persist(mpackOrder);
		
		addLogDetails(logId, "insert into mpack_order --> mpack_id = " + mpackOrder.getMpackId() + ", mpack_order_seq = " + mpackOrder.getMpackOrderSeq());

	}
	
	private void createContainerPackingList(long logId, List<ShippableUnitHistory> containers){
		
		for(ShippableUnitHistory cont : containers) {
			String cont_packing_list = getLastGeneratedNumber(cont.getWarehouse(), DOCUMENT_GENERATION_TYPE_CPCK);
			insertCpack(logId, cont.getWarehouse(), cont_packing_list, STATION_BASE, cont.getCont(), cont.getShipment());	
			updateShipmentContainerPackingList(logId, cont.getWarehouse(), cont.getCont(), cont_packing_list);			
		}
		
	}
	
	@SuppressWarnings("unchecked")
	private List<ShippableUnitHistory> getShipmentContainers(String warehouse, String shipment) {
		Query query = em.createNamedQuery(ShippableUnitHistory.FIND_ALL_SHIPMENT_CONTAINER);
		query.setParameter("shipment", shipment);
		query.setParameter("warehouse", warehouse);
		List<ShippableUnitHistory> entity = query.getResultList();
		return entity;
	}
	
	private String getShipmentTrailer(String warehouse, String shipment) {
		Query query = em.createNamedQuery(ShippableUnitHistory.FIND_ALL_SHIPMENT_CONTAINER);
		query.setParameter("shipment", shipment);
		query.setParameter("warehouse", warehouse);
		query.setMaxResults(1);
		ShippableUnitHistory shippableUnit = (ShippableUnitHistory) query.getSingleResult();
		return shippableUnit.getTrailer();
	}
	
	
	private MpackEntity insertPackingList(long logId, String warehouse, String master_packing_list, String station ) {
		
		MpackEntity mpack = new MpackEntity(master_packing_list, warehouse, STATION_BASE);		
		em.persist(mpack);		
		addLogDetails(logId, "Insert into mpack --> mpack_id = " + mpack.getId());
		return mpack;
	}
	
	
		
	private int getPalletCount(String warehouse, String shipment) {	
		Query query = em.createNamedQuery(ShippableUnitHistory.PALLET_COUNT);
		query.setParameter("warehouse", warehouse);
		query.setParameter("shipment", shipment);
		Long totalPallet = (Long) query.getSingleResult();
		return totalPallet.intValue();
	}

	private double getShipmentWeight(String warehouse, String shipment) {	
		Query query = em.createNamedQuery(ShippableUnitHistory.TOTAL_WEIGHT);
		query.setParameter("warehouse", warehouse);
		query.setParameter("shipment", shipment);
		Double totalWeight = (Double) query.getSingleResult();
		return totalWeight.doubleValue();
	}
	
	private Carrier getCarrier(String warehouse, String carrierService) {
		Query query = em.createNamedQuery(Carrier.FIND_BY_CARRIER_SERVICE);
		query.setParameter("warehouse", warehouse);
		query.setParameter("carrierService", carrierService);
		Carrier carrier = (Carrier) query.getSingleResult();
		return carrier;
	}

	@SuppressWarnings("unchecked")
	private OutboundOrderCurrentHistory getShipmentOrderDetails(String warehouse, String shipment) {
		
		Query query = em.createNamedQuery(OutboundOrderCurrentHistory.FIND_ORDER_DETAILS);
		query.setParameter("shipment", shipment);
		query.setParameter("warehouse", warehouse);
		query.setMaxResults(1);
		List<OutboundOrderCurrentHistory> entity = query.getResultList();
		if(entity == null || entity.isEmpty()) {
			throw new WMSUtilServiceException("Order Details not found for shipment : " + shipment + " warehouse : " + warehouse);
		}
		
		return entity.get(0);
		
	}
	
	
	private void insertCpack(long logId, String warehouse, String cont_packing_list, String station, String cont, String shipment) {
		
		CpackEntity cpack = new CpackEntity(warehouse, cont_packing_list, station, cont);
		em.persist(cpack);
		addLogDetails(logId, "insert into cpack --> cpack_id = " + cpack.getId());
		OutboundOrderCurrentHistory order = getShipmentOrderDetails(warehouse, shipment);
		
		CpackOrderEntity cpackOrderEntity = new CpackOrderEntity(cpack.getId(), order.getId(), order.getCarrierService(), shipment, warehouse);
		em.persist(cpackOrderEntity);
		
		addLogDetails(logId, "insert into cpack_order --> cpack_id = " + cpack.getId() + ", cpack_ord_seq = " + cpackOrderEntity.getCpackOrderSeq());

	}
	
	private void updateShipmentContainerPackingList(long logId, String warehouse, String cont, String cont_packing_list) {
		
		String sql = "update shipunit_h set cont_packlist = '" + cont_packing_list + "' where whse_code = '" + warehouse 	+ "' and cont = '" + cont + "'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}
	
	private void updateShipmentMasterPackingList(long logId, String warehouse, String shipment, String packList) {
		
		String sql = "update shipunit_h set packlist = '" + packList	+ "' where whse_code = '"	+ warehouse	+ "' and shipment = '" + shipment + "'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();	
		addLogDetails(logId, sql);

	}
	
	private String getLastGeneratedNumber(String warehouse, String documentType) {
		
		GeneratedNumberEntity entity = getGeneratedEntity(warehouse, documentType);
		entity.setLastNumber(entity.getLastNumber() + 1);
		entity = em.merge(entity);
		
		return entity.getFullLastNumber();
	}


	private GeneratedNumberEntity getGeneratedEntity(String warehouse, String documentType) {
		Query query2 = em.createNamedQuery(GeneratedNumberEntity.FIND_LAST_GENERATED_ID_BY_TYPE);
		query2.setParameter("warehouse", warehouse);
		query2.setParameter("documentType", documentType);	

		GeneratedNumberEntity entity = (GeneratedNumberEntity) query2.getSingleResult();
		return entity;
	}

	private WaveEntity getWave(String wave) {
		Query query = em.createNamedQuery(WaveEntity.FIND_WAVE_BY_NAME);
		query.setParameter("wave", wave);
		WaveEntity waveEntity = (WaveEntity) query.getSingleResult();
		return waveEntity;
	}

	private ShippingActivityEntity getShippingActivity(String container) {
		ShippingActivityEntity entity = null;
		try {
			Query query = em.createNamedQuery(ShippingActivityEntity.FIND_BY_CONTAINER);
			query.setParameter("container", container);
			entity = (ShippingActivityEntity) query.getSingleResult();
		} catch (Exception e) {
			return null;
		}
		return entity;
	}

	// get stuck inventory in truck location
	@SuppressWarnings("unchecked")
	private List<InventoryEntity> getInventoryStuckInTruckLocation(long logId, String orderNumber, String warehouse) {
		Query query = em.createNamedQuery(InventoryEntity.INVENTORY_STUCK_IN_TRUCK_LOCATION);
		query.setParameter("orderNumber", orderNumber);
		query.setParameter("warehouse", warehouse);
		return query.getResultList();
	}

	//remove inventory when item stuck in TRUCK location and shipment is shipped	
	private void deleteInventory(long logId, int inventoryId){
		String sql = "delete iv_f where iv_rid = " + inventoryId + " and loc = 'TRUCK'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}
	
	private void updateInventory(long logId, String container, int shipunitId, int inventoryId) {
		String sql = "update iv_f set alloc_qty = alloc_qty - qty, loc = '', cont = '" + container + "', shipunit_rid =  "+ shipunitId + " where iv_rid = "+ inventoryId +" and loc = 'TRUCK'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}

	private void updateOrderDetails(long logId, int orderDetailId, int quantity) {
		String sql = "update od_f set cmp_qty = cmp_qty + " + quantity + ", sched_qty = sched_qty - " + quantity + " where od_rid = " + orderDetailId;
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}

	private void revertOrderDetails(long logId, int orderDetailId, int quantity) {
		String sql = "update od_f set sched_qty = sched_qty - " + quantity + " where od_rid = " + orderDetailId;
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}

	private void updateWarehouseTask(long logId) {
		String sql = "update mq_warehouse_task set is_error = 0 where queue_name = 'wms_shipment_completion'";
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
	}
	
	
	/**
	 * get stuck waves
	 *  
	 * @return list
	 */
	@SuppressWarnings("unchecked")
	private List<TransactionDto> getStuckWave() {		
		Query query = em.createNamedQuery(WaveEntity.FIND_STUCK_WAVE_RELEASE_MSG);
		List<WaveEntity> waves =  query.getResultList();
		List<TransactionDto> dtos = new ArrayList<TransactionDto>();
		for (WaveEntity wave : waves) {	
			int count = getPendingWavePicks(wave.getWave(), wave.getWarehouse());
			String message = null;
			if(count > 0) {
				message = MSG_EXISTS_WAVE_PENDING_PICK_COMMANDS;				
			} else {
				int value = getTaskMessageQueue(wave.getId(), "wms_wave_releasing");
				switch (value) {
				case 0:
					message = MSG_TASK_MESSAGE_NOT_EXISTS;
					break;
				case 1:
					message = MSG_TASK_QUEUE_IN_ERROR;
					break;
				default:
					break;
				}				
			}
			
			if(message != null) {
				TransactionDto dto = converter.convertWaveEntityToTransactionDto(wave,  message);
				dtos.add(dto);
			}
		}		
		return dtos;
	}
	
	
	
	private void resetTaskMessageQueue(long logId, String warehouse) {
		String sql = "update mq_warehouse_task set is_error = 0 where is_error = 1 and msg_group = '" + warehouse + "'";		
		Query query = em.createNativeQuery(sql);
		query.executeUpdate();
		addLogDetails(logId, sql);
		
	}

	private TaskMessageQueue insertTaskMessageQueue(long logId, String queueName, long recordId, String warehouse, String documentType) {
			
			String header = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> <MsgQueueHeader>     <routes>         <queueName>"+queueName+"</queueName>         <status></status>     </routes>     <stopQueueOnErrors>false</stopQueueOnErrors> </MsgQueueHeader>";
			String body = null;
			if(queueName.equals("wms_wave_releasing"))
				body = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> <WmsWaveReleasing>     <recordId>" + Long.toString(recordId) + "</recordId>     <warehouse>"+ warehouse +"</warehouse> </WmsWaveReleasing> ";
			if(queueName.equals("wms_report_creation"))
				body = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> <WmsReportCreation>    <documentTypeName>" + documentType + "</documentTypeName>  <recordIds>" + Long.toString(recordId) + "</recordIds>     <warehouse>"+ warehouse +"</warehouse> </WmsReportCreation> ";
			
			TaskMessageQueue entity = new TaskMessageQueue(warehouse, queueName, getInstanceName(warehouse), header, body);
			em.persist(entity);
			addLogDetails(logId, "insert into mq_warehouse_task --> queue_msg_id = " + entity.getId());
			return entity;
	}	
	
	private String getInstanceName(String warehouse) {
		try {
			Query query = em.createNamedQuery(SystemPropertiesEntity.FIND_DEFAULT_INSTANCE);
			query.setParameter("warehouse", warehouse);
			
			SystemPropertiesEntity property  = (SystemPropertiesEntity) query.getSingleResult();
			
			return property.getPropertyValue();			
		}catch (NoResultException e) {
			throw new WMSUtilServiceException(WAREHOUSE_INSTANCE_PROPERTY_NOT_FOUND);
		}catch (Exception e) {
			throw new WMSUtilServiceException(e.getMessage());
		}
	}

	@SuppressWarnings("unchecked")
	private int getPendingWavePicks(String wave, String warehouse) {
		Query query = em.createNamedQuery(QueueCommands.FIND_PENDING_WAVE_PICKS);
		query.setParameter("warehouse", warehouse);
		query.setParameter("wave", wave);
		List<QueueCommands> commands = query.getResultList();		
		return commands.size();
	}
	
	/**
	 * 
	 * get Wave task queue message 
	 * 
	 * @param waveId
	 * @return long value 
	 * 		0 - message not found and wms util shall create the message
	 * 		1 - message exists and is in error and shall be flip to re-process		
	 * 	   -1 - message exists and waiting for processing
	 */
	private int getTaskMessageQueue(long recordId, String queueName) {
		TaskMessageQueue task = getTaskMessageQueueRecord(recordId, queueName);	
		if(task == null) {
			return 0;
		}else if(!task.isError()) {
			return -1;
		}			
		return 1; 		
	}
	
	private TaskMessageQueue getTaskMessageQueueRecord(long recordId, String queueName) {
		try {
			Query q1 = em.createNamedQuery(TaskMessageQueue.FIND_BY_RECORD_ID);
			q1.setParameter("recordId", "%<recordId>"+Long.toString(recordId)+"</recordId>%");
			q1.setParameter("queueName", queueName);
			return (TaskMessageQueue) q1.getSingleResult();
			
		}catch (NoResultException e) {
			return null;
		}catch (Exception e) {
			throw new WMSUtilServiceException(e.getMessage());
		}		
	}

	@SuppressWarnings("unchecked")
	private List<TransactionDto> getInventoryStuckInTruckLocation() {
		Query query = em.createNamedQuery(InventoryEntity.FIND_ALL_INVENTORY_STUCK_IN_TRUCK_LOCATION);
		List<InventoryEntity> entities = query.getResultList();
		return converter.convertInventoryEntityToTransactionDto(entities);
	}


}
