INSERT INTO ca_st_ldb(whse_code, carrier_service, station, create_user, mod_user, mod_counter, create_stamp, mod_stamp) 
SELECT whse_code, carrier_service, 'BASE', 'system', 'system', 0, getDate(), getDate()  FROM ca_f where ca_f.whse_code = 'KDC';
