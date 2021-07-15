Deployment instructions:

Login into TSWMS database and execute following:

1. .\required_objects\Queue.sql
2. .\required_objects\Queuedatabase.sql
3. .\required_objects\IndexOptimize.sql
4. .\dba_weekly_index_rebuild_and_stats.sql
5. Verify that reindexing job was created and that it is enabled.

