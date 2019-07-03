@echo off
cd /d %~dp0
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit

title --IP自动设置 --
MODE con: COLS=80 lines=30
color 0a
  
:begin  
@rem cls  
echo 要把IP设置为自动获取 请按 1
echo 要把IP设置为192.168.1.123(内网)请按 2
echo 要把IP设置为10.252.222.222(外网)请按 3
echo 要退出 请按 4
echo.
choice /c 123450 /n /m "                请选择【1-4】："

echo %errorlevel%
if %errorlevel% == 1 goto set_ip1_ip  
if %errorlevel% == 2 goto set_ip2_ip  
if %errorlevel% == 3 goto set_ip3_ip  
if %errorlevel% == 4 goto end  
if %times% == 0 (goto **_connect) else (goto begin)  


:set_ip1_ip  
echo IP自动设置开始....
echo.
echo 自动获取IP地址....
netsh interface ip set address "以太网" dhcp
echo 自动获取DNS服务器....
netsh interface ip set dns "以太网" dhcp
@rem 设置自动获取IP
@set reg=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001
@set MAC=00E07096537F
@reg add "%reg%" /v NetworkAddress /t reg_SZ /d "%MAC%" /f
echo 设置完成

@set INTERFACE=以太网
echo 重启本机网卡...
netsh interface set interface "%INTERFACE%" disable
netsh interface set interface "%INTERFACE%" enable

pause
goto end  


:set_ip2_ip  
echo IP自动设置开始....
echo.
echo 正在设置IP、子网掩码、网关
netsh interface ipv4 set address "以太网" "static" "192.168.1.123" "255.255.255.0" "192.168.1.1"
netsh interface ipv4 set dnsservers name="以太网"  static  114.114.114.114
netsh interface ipv4 add dnsservers name="以太网"   223.5.5.5 index=2
echo 修改网卡Mac...
@set reg=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001
@set MAC=00E07096537F
@reg add "%reg%" /v NetworkAddress /t reg_SZ /d "%MAC%" /f
echo 设置完成

@set INTERFACE=以太网
echo 重启本机网卡...
netsh interface set interface "%INTERFACE%" disable
netsh interface set interface "%INTERFACE%" enable

pause
goto end



:set_ip3_ip  
echo IP自动设置开始....
echo.
echo 正在设置IP、子网掩码、网关
netsh interface ipv4 set address "以太网" "static" "10.252.222.222" "255.255.255.0" "10.252.222.254"
netsh interface ipv4 set dnsservers name="以太网"  static  114.114.114.114
netsh interface ipv4 add dnsservers name="以太网"   223.5.5.5 index=2

echo 修改网卡Mac...
@set reg=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-xxxx-11ce-bfc1-08002be10318}\0001
@set MAC=00E0707F55B0
@reg add "%reg%" /v NetworkAddress /t reg_SZ /d "%MAC%" /f
echo 设置完成

@set INTERFACE=以太网
echo 重启本机网卡...
netsh interface set interface "%INTERFACE%" disable
netsh interface set interface "%INTERFACE%" enable

pause
goto end




:end
exit  
复制代码
