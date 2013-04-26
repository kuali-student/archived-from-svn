@echo off
echo organization loader
pause
java -jar ks-loader.jar organization "NewReferenceOrganizations.xls" "http://localhost:9393/ks-embedded-dev"
pause
