DELETE FROM so_f_es WHERE whse_code = 'KDC';

INSERT INTO so_f_es(whse_code, wgt_tolerance_level, btl_pick_qa_loc_es, percent_tolerance_level, gram_tolerance_level, pallet_qa_loc) 
SELECT 'KDC', wgt_tolerance_level, NULL, percent_tolerance_level, gram_tolerance_level, pallet_qa_loc  FROM so_f_es where whse_code = 'VDC';
