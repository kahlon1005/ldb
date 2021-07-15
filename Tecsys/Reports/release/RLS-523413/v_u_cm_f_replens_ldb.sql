CREATE VIEW [dbo].[v_u_cm_f_replens_ldb] AS
SELECT TOP 1000 cm_rid, whse_code, area, wave, cmd_seq, dest, sku, rep_code, repl_cmd_stt, order_task, wave_modified, status,
	IIF(qty_required < 0, 0, 1) as qty_sort, IIF(wave_modified IS NULL, 1, 0) wave_date_sort, row_number() OVER (ORDER BY IIF(qty_required < 0, 0, 1), IIF(wave_modified IS NULL, 1, 0), wave_modified) priority
FROM (
    SELECT DISTINCT repl.cm_rid, repl.whse_code, repl.area, repl.wave, repl.cmd_seq, repl.dest, repl.sku, repl.task_code rep_code, repl.cmd_stt repl_cmd_stt, ord.task_code order_task, wv_f.mod_stamp wave_modified,
        sum(iv_f.qty - iv_f.alloc_qty) qty_required, iif(sum(iv_f.qty - iv_f.alloc_qty) < 0, 'REQUIRED','OTHER') 'status'
    FROM cm_f repl
    LEFT JOIN cm_f ord ON repl.whse_code = ord.whse_code
        AND repl.dest = ord.loc
        AND ord.task_code = 'PICK'
    LEFT JOIN wv_f ON repl.whse_code = wv_f.whse_code
        AND repl.wave = wv_f.wave
    LEFT JOIN iv_f ON repl.whse_code = iv_f.whse_code
        AND iv_f.sku = repl.sku
        AND iv_f.loc = repl.dest
    WHERE repl.task_code = 'REPL'
        AND repl.cmd_stt = 'RDYR'
    GROUP BY repl.cm_rid, repl.whse_code, repl.area, repl.wave, repl.cmd_seq, repl.dest, repl.sku, repl.task_code, repl.cmd_stt, ord.task_code, wv_f.mod_stamp
) AS repl_priority

GO

