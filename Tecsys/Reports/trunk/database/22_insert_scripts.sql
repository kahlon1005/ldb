DELETE FROM wms_system_properties_ldb WHERE whse_code = 'VDC' AND property_name = 'INSTANCE_NAME';
DELETE FROM wms_system_properties_ldb WHERE whse_code = 'VDC' AND property_name = 'DEFAULT_STATION';
DELETE FROM ca_st_ldb; 


--add instance name 
INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01) values('VDC', 'INSTANCE_NAME', 'tswmsea.dev.bcldb.com_dev_94x')
GO

--add default station
INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01) values('VDC', 'DEFAULT_STATION', 'BASE')
GO

--map carrier service to station
INSERT INTO ca_st_ldb(whse_code, carrier_service, station, create_user, mod_user, mod_counter, create_stamp, mod_stamp) 
SELECT whse_code, carrier_service, 'BASE', 'system', 'system',0, getDate(), getDate()  FROM ca_f;
GO
