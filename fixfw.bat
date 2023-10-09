@echo off
@REM 检查管理员权限
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    REM 已具有管理员权限
    goto :continue
) ELSE (
    REM 没有管理员权限，提示用户以管理员身份重新运行该文件
    echo please run this file as administrator!
    echo press any key to exit...
    pause >nul
    exit
)

:continue

call :AddFirewallRule "xw_RDPA" "TCP" 3389
call :AddFirewallRule "xw_TwinCAT_TCP" "TCP" 48898
call :AddFirewallRule "xw_TwinCAT_UDP" "UDP" 48898
call :AddFirewallRule "xw_AdsWebApi" "TCP" 5240
call :AddFirewallRule "xw_xcopy" "TCP" 445
call :AddFirewallRule "xw_psexec_rpc" "TCP" 135
call :AddFirewallRule "xw_psexec_system" "TCP" 445
call :AddFirewallRule "xw_psexec_services" "TCP" 49668
call :AddFirewallRule "xw_ping" "icmpv4"

@REM 防止F1弹出帮助窗口
reg add HKCU\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win32 /ve /t REG_SZ /d "" /f
reg add HKCU\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64 /ve /t REG_SZ /d "" /f

@REM Make sure that the default admin$ share is enabled" error in PsExec
@REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareServer /t REG_DWORD /d 1 /f

echo press any key to exit...
pause >nul
exit /b

:AddFirewallRule
set ruleName=%1
set protocol=%2
set localPort=%3

REM 允许指定的端口通过防火墙
netsh advfirewall firewall show rule name="%ruleName%" | findstr "%ruleName%" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="%ruleName%" new enable=yes
) ELSE (
    if "%localPort%"=="" (
        netsh advfirewall firewall add rule name="%ruleName%" dir=in action=allow protocol=%protocol%
    ) else (
        netsh advfirewall firewall add rule name="%ruleName%" dir=in action=allow protocol=%protocol% localport=%localPort%
    )
)
netsh advfirewall firewall show rule name="%ruleName%"
echo add %ruleName% firewall rule success!
exit /b
