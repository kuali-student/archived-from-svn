@echo off
echo course loader
pause
java -jar ks-loader.jar courseDeleter "Courses for BSCI program.xls" "http://localhost:9393/ks-embedded-dev"
pause
