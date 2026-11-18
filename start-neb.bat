@echo off
setlocal
cd /d "%~dp0"

REM Replace the wallet below with your own NEB mainnet address (starts with neb1).
set "WALLET=YOUR_NEB_WALLET_ADDRESS"
set "WORKER=%COMPUTERNAME%"
set "POOL=stratum+tcp://neb.suprnova.cc:7804"

if /I "%WALLET%"=="YOUR_NEB_WALLET_ADDRESS" (
    echo Edit WALLET near the top of start-neb.bat, save it, then run it again.
    echo Use your own NEB mainnet wallet address, starting with neb1.
    pause
    exit /b 64
)
if not exist "%~dp0suprminer-neptune.exe" (
    echo Extract the whole Windows miner ZIP before starting this file.
    echo Keep start-neb.bat next to suprminer-neptune.exe and its DLLs.
    pause
    exit /b 66
)

"%~dp0suprminer-neptune.exe" -a neb -o "%POOL%" -u "%WALLET%.%WORKER%" -p x
set "MINER_EXIT=%ERRORLEVEL%"
echo.
echo Miner stopped. See NEB.md for setup and troubleshooting.
pause
exit /b %MINER_EXIT%
