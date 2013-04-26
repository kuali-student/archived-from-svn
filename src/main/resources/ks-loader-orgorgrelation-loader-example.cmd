@echo off
echo organization loader
pause
java -jar ks-loader.jar orgorgrelation "Organizations.xls" "http://localhost:9393/ks-embedded-dev"
pause
