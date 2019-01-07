#!/bin/bash

ls -v1 *.sql > myScripts.txt

scripts=$(cat myScripts.txt | wc -l)
dbID=$(sqlite3 database.db "select v_ID from versionID")

while IFS= read -r cmd; do
versionID="${cmd//[!0-9]/}"
#echo "Scripts: "$scripts
#echo "VersionID: "$versionID
#echo "Database v_ID: "$dbID
if [ $versionID -gt $dbID ]; then
while IFS= read -r cmd; do
	eval sqlite3 database.db $cmd
	eval sqlite3 database.db \'update versionID set v_ID = $versionID\'
	echo "Running script: "$versionID
done < $cmd
fi
done < myScripts.txt
echo "Database is up to date with version: "$versionID
