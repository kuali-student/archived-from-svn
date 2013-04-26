@echo off
echo organization loader
pause
java -jar ks-loader.jar organization "Organizations for BSCI program.xls" "http://localhost:9393/ks-embedded-dev"
pause
