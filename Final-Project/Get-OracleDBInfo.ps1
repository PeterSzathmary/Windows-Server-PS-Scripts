$ScriptPath = "output.sql"
$Container = "CDB`$ROOT"
$TXTPath = "test.txt"
$SQLInfoPath = "tablespaces_info.sql"

sqlplus.exe / as sysdba "@$ScriptPath" $Container $TXTPath $SQLInfoPath