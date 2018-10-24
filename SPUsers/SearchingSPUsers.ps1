# Search SPUsers and filter it using a property
$users = Get-SPUSer -Web <"web url"> -Limit All | Where-Object { $_.LoginName -like "*stringµ" -or $_.LoginName -like "*string2" }
$users | export-csv <"patch/file.csv">
