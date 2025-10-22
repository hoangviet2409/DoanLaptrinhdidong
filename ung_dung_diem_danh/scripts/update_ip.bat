@echo off
echo ========================================
echo    CAP NHAT IP TRONG CODE
echo ========================================
echo.

echo Dang tim IP cua may tinh...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set ip=%%a
    set ip=!ip: =!
    echo IP tim thay: !ip!
    echo.
    
    echo Dang cap nhat file constants.dart...
    powershell -Command "(Get-Content 'lib\config\constants.dart') -replace 'http://192\.168\.\d+\.\d+:5095/api', 'http://!ip!:5095/api' | Set-Content 'lib\config\constants.dart'"
    
    echo ✅ Da cap nhat IP thanh: !ip!
    echo.
    echo File da duoc cap nhat: lib\config\constants.dart
    echo.
    goto :end
)

echo ❌ Khong tim thay IP
echo Hay kiem tra ket noi mang

:end
echo.
echo ========================================
echo    HUONG DAN TIEP THEO
echo ========================================
echo 1. Kiem tra backend: scripts\check_backend.bat
echo 2. Chay app: flutter run
echo.
pause



