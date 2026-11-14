@echo off
rem 截图打码 · 网页版：在本机开一个静态服务，手机连同一 Wi-Fi 即可访问
setlocal
cd /d "%~dp0"

set "PY="
if exist "%~dp0python.exe" set "PY=%~dp0python.exe"

if not defined PY (
    for /d %%D in ("%USERPROFILE%\.dsh\dsh-runtimes\*") do (
        if exist "%%D\dependencies\python\python.exe" set "PY=%%D\dependencies\python\python.exe"
    )
)
if not defined PY (
    for /d %%D in ("%LOCALAPPDATA%\Programs\Python\Python3*") do (
        if exist "%%D\python.exe" set "PY=%%D\python.exe"
    )
)
if not defined PY (
    where py >nul 2>nul && set "PY=py"
)
if not defined PY (
    where python >nul 2>nul && set "PY=python"
)
if not defined PY (
    echo [错误] 没有找到 Python 运行环境。
    echo 请安装 Python 3.9+，或把 python.exe 放到本目录。
    pause
    exit /b 1
)

set "IP="
"%PY%" -c "import socket;s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);s.connect(('8.8.8.8',80));open(r'%TEMP%\uidblur_ip.txt','w').write(s.getsockname()[0])" >nul 2>nul
if exist "%TEMP%\uidblur_ip.txt" (
    set /p IP=<"%TEMP%\uidblur_ip.txt"
    del "%TEMP%\uidblur_ip.txt" >nul 2>nul
)

echo.
echo   ============================================
echo     截图打码 · 网页版
echo   ============================================
echo.
echo   1. 手机和这台电脑连同一个 Wi-Fi
echo   2. 手机浏览器打开下面的地址：
echo.
if defined IP (
    echo        http://%IP%:8080/
) else (
    echo        http://电脑的局域网IP:8080/    ^(用 ipconfig 查看 IPv4^)
)
echo.
echo   3. 打开后可点浏览器菜单「添加到主屏幕」
echo.
echo   关闭这个窗口即停止服务。
echo   ============================================
echo.

start "" http://127.0.0.1:8080/
"%PY%" -m http.server 8080 --bind 0.0.0.0
pause
