@echo off
echo ========================================
echo    TIM IP MAY TINH CHO FLUTTER APP
echo ========================================
echo.

echo Dang tim IP cua may tinh...
echo.

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set ip=%%a
    set ip=!ip: =!
    echo IP tim thay: !ip!
    echo.
    echo Hay thay doi trong file: lib/config/constants.dart
    echo Thay dong: _deviceUrl = 'http://192.168.1.100:5095/api'
    echo Thanh:     _deviceUrl = 'http://!ip!:5095/api'
    echo.
    pause
    goto :end
)

:end
echo.
echo ========================================
echo    HUONG DAN TIEP THEO
echo ========================================
echo 1. Thay IP trong constants.dart
echo 2. Kiem tra backend co chay khong: netstat -an ^| findstr :5095
echo 3. Chay app: flutter run
echo.
pause



