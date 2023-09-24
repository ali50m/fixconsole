@echo off

NET SESSION >NUL 2>NUL
if %errorlevel% neq 0 (
    echo please run as administrator
    pause
    exit /b
)

echo turn off quick edit mode for cmd.exe ...
reg add HKCU\Console /v QuickEdit /t REG_DWORD /d 0 /f

echo install handwriting ...
setlocal
for %%A in ("%~dp0\package\*.cab") do (
    dism /Online /Add-Package /PackagePath:"%%A"
)
endlocal

echo modify non-unicode language ...
Intl.cpl
