BEGIN
  IF NOT EXISTS (SELECT * FROM wms_system_properties_ldb WHERE property_name='CASE_PICK_AREA')
  BEGIN
    INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01) VALUES ('VDC','CASE_PICK_AREA','APCK');
    INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01) VALUES ('VDC','CASE_PICK_AREA','ACAG');
    INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01) VALUES ('VDC','CASE_PICK_AREA','INVM');
  END
END
