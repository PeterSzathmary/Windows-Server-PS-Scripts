set term off
set feed off
-- &1 -> which container ?
-- &2 -> output file path
-- &3 -> path to sql file to execute (should be some info script)
ALTER SESSION SET CONTAINER = &1;
spool c:\DB\&2
@c:\DB\&3
spool off
exit