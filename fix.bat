@echo off
echo turn off quick edit mode for cmd.exe
reg add HKCU\Console /v QuickEdit /t REG_DWORD /d 0 /f

echo install handwriting
setlocal
for %%A in ("%~dp0\*.cab") do (
    dism /Online /Add-Package /PackagePath:"%%A"
)
endlocal

echo modify non-unicode language
Intl.cpl
