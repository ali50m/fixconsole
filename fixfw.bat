@echo off
REM 检查管理员权限
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

REM 允许Remote Desktop相关端口通过防火墙
netsh advfirewall firewall show rule name="xw_RDP" | findstr "xw_RDP" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_RDP" new enable=yes
) ELSE (
    netsh advfirewall firewall add rule name="xw_RDP" dir=in action=allow protocol=TCP localport=3389
)
netsh advfirewall firewall show rule name="xw_RDP"
echo add xw_xcopy firewall rule success!

REM 允许TwinCAT相关端口通过防火墙
netsh advfirewall firewall show rule name="xw_TwinCAT_TCP" | findstr "xw_TwinCAT_TCP" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_TwinCAT_TCP" new enable=yes
) ELSE (
    netsh advfirewall firewall add rule name="xw_TwinCAT_TCP" dir=in action=allow protocol=TCP localport=48898
)
netsh advfirewall firewall show rule name="xw_TwinCAT_TCP"
echo add xw_TwinCAT_TCP firewall rule success!

REM 允许TwinCAT相关端口通过防火墙
netsh advfirewall firewall show rule name="xw_TwinCAT_UDP" | findstr "xw_TwinCAT_UDP" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_TwinCAT_UDP" new enable=yes
) ELSE (
    netsh advfirewall firewall add rule name="xw_TwinCAT_UDP" dir=in action=allow protocol=UDP localport=48899
)
netsh advfirewall firewall show rule name="xw_TwinCAT_UDP"
echo add xw_TwinCAT_UDP firewall rule success!

REM 允许AdsWebApi相关端口通过防火墙
netsh advfirewall firewall show rule name="xw_AdsWebApi" | findstr "xw_AdsWebApi" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_AdsWebApi" new enable=yes
) ELSE (
    @REM netsh advfirewall firewall add rule name="xw_AdsWebApi" dir=in action=allow program="C:\Users\Administrator\Desktop\AdsWebApi\AdsWebApi.exe"
    netsh advfirewall firewall add rule name="xw_AdsWebApi" dir=in action=allow protocol=TCP localport=5240

)
netsh advfirewall firewall show rule name="xw_AdsWebApi"
echo add xw_AdsWebApi firewall rule success!

REM 允许xcopy相关端口通过防火墙
netsh advfirewall firewall show rule name="xw_xcopy" | findstr "xw_xcopy" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_xcopy" new enable=yes
) ELSE (
    netsh advfirewall firewall add rule name="xw_xcopy" dir=in action=allow protocol=TCP localport=445
)
netsh advfirewall firewall show rule name="xw_xcopy"
echo add xw_xcopy firewall rule success!

REM 允许ICMP Echo Request通过防火墙
netsh advfirewall firewall show rule name="xw_ping" | findstr "xw_ping" >nul
IF %ERRORLEVEL% EQU 0 (
    netsh advfirewall firewall set rule name="xw_ping" new enable=yes
) ELSE (
    netsh advfirewall firewall add rule name="xw_ping" dir=in action=allow protocol=icmpv4
)
netsh advfirewall firewall show rule name="xw_ping"
echo add xw_ping firewall rule success!

echo press any key to exit...
pause >nul
exit
