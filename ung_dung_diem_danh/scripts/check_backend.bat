@echo off
echo ========================================
echo    KIEM TRA BACKEND CO CHAY KHONG
echo ========================================
echo.

echo Dang kiem tra port 5095...
netstat -an | findstr :5095

if %errorlevel% == 0 (
    echo.
    echo ✅ BACKEND DANG CHAY TREN PORT 5095
    echo.
) else (
    echo.
    echo ❌ BACKEND CHUA CHAY
    echo.
    echo Hay chay backend truoc:
    echo cd UngDungDiemDanhNhanVien
    echo dotnet run
    echo.
)

echo ========================================
echo    KIEM TRA FIREWALL
echo ========================================
echo.

echo Dang kiem tra firewall...
netsh advfirewall firewall show rule name="Flutter API" >nul 2>&1

if %errorlevel% == 0 (
    echo ✅ FIREWALL DA MO PORT 5095
) else (
    echo ❌ FIREWALL CHUA MO PORT 5095
    echo.
    echo Hay mo port:
    echo netsh advfirewall firewall add rule name="Flutter API" dir=in action=allow protocol=TCP localport=5095
    echo.
)

echo.
pause



