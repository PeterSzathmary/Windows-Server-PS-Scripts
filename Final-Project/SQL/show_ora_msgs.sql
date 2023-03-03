alter session set container = orclpdb;
set pagesize 0;
set term off;
set feedback off;
spool "&1" append;
select distinct dbms_lob.substr(MESSAGE,32767) from &2;
spool off;
exit;