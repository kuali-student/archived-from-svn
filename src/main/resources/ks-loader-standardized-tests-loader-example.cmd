@echo off
echo standardized tests loader
pause
java -jar ks-loader.jar test "StandardizedTests.xls" "http://localhost:9393/ks-embedded-dev"
pause
