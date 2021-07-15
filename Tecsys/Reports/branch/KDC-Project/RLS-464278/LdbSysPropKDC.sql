INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01, custom_char_02, custom_char_03, custom_char_04) 
SELECT 'KDC', property_name, custom_char_01, custom_char_02, custom_char_03, custom_char_04 FROM wms_system_properties_ldb where whse_code = 'VDC' and property_name not in ('BOTTLE_PICK_AREA','BOTTLE_PICK_AREA_LVL1','BOTTLE_PICK_AREA_LVL2', 'BOTTLE_PICK_AREA_LVL3','BOTTLE_PICK_CONTAINER','AREA_NO_CATEGORY') and custom_char_01 not in ('ACAG');