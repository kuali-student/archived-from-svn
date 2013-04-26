@echo off
echo atp loader
pause
java -jar ks-loader.jar atp "ATP Calendar.xls" "http://localhost:9393/ks-embedded-dev"
pause
