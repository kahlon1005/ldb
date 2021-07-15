package com.bcldb.helper;

import java.util.ArrayList;
import java.util.List;

import com.bcldb.dto.TransactionDto;
import com.bcldb.model.InventoryEntity;
import com.bcldb.model.WaveEntity;

public class DTOConverter {
	
	private static final String MSG_INVENTORY_STUCK_IN_TRUCK_LOCATION = "Inventory Stuck in TRUCK location";

	public List<TransactionDto> convertInventoryEntityToTransactionDto(List<InventoryEntity> entities) {
		List<TransactionDto> dtos =  new ArrayList<TransactionDto>();
		for(InventoryEntity entity:entities) {
			TransactionDto dto = new TransactionDto();
			dto.setWarehouse(entity.getWarehouse());
			dto.setName(entity.getOrder());
			dto.setType(TransactionDto.ORDER_TRANSACTION_TYPE);
			dto.setMessage(MSG_INVENTORY_STUCK_IN_TRUCK_LOCATION);
			dtos.add(dto);
		}
		return dtos;
	}

	public TransactionDto convertWaveEntityToTransactionDto(WaveEntity wave, String message) {
		TransactionDto dto = new TransactionDto();
		dto.setName(wave.getWave());
		dto.setType(TransactionDto.WAVE_TRANSACTION_TYPE);
		dto.setMessage(message);
		dto.setWarehouse(wave.getWarehouse());
		return dto;
	}
	
	

}
