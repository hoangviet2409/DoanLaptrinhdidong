@echo off
echo ========================================
echo    SETUP CHAY APP TREN MAY THAT
echo ========================================
echo.

echo Buoc 1: Tim IP may tinh...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set ip=%%a
    set ip=!ip: =!
    echo IP tim thay: !ip!
    echo.
    echo Dang cap nhat IP trong code...
    powershell -Command "(Get-Content 'lib\config\constants.dart') -replace 'http://192\.168\.\d+\.\d+:5095/api', 'http://!ip!:5095/api' | Set-Content 'lib\config\constants.dart'"
    echo ✅ Da cap nhat IP thanh: !ip!
    echo.
    goto :next
)

:next
echo Buoc 2: Kiem tra backend...
netstat -an | findstr :5095 >nul
if %errorlevel% == 0 (
    echo ✅ Backend dang chay
) else (
    echo ❌ Backend chua chay
    echo Hay chay: cd UngDungDiemDanhNhanVien && dotnet run
)

echo.
echo Buoc 3: Mo firewall...
netsh advfirewall firewall add rule name="Flutter API" dir=in action=allow protocol=TCP localport=5095 >nul 2>&1
echo ✅ Da mo port 5095

echo.
echo Buoc 4: Kiem tra ket noi...
echo Dang kiem tra ket noi den backend...
curl -s http://localhost:5095/api >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Backend phan hoi OK
) else (
    echo ❌ Backend khong phan hoi
)

echo.
echo ========================================
echo    SAN SANG CHAY APP
echo ========================================
echo.
echo Hay chay: flutter run
echo.
pause
