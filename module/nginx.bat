@echo off

::设置内部变量
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set xroot=%~dp0
set xroot=%xroot:~0,-7%
set xnssm=%xroot%\runtime\nssm.exe

set mroot=%xroot%\module\%~n0
set mconf=%xroot%\deploy\%~n0\nginx.conf

call :app_runtime


::外部调用模式
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" (
  call :app_%1
  goto :EOF
  exit
)


::独立控制台模式
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

title %scName% 服务控制台

echo.
echo 暂不支持独立控制台模式...
pause >nul && exit


::模块管理标准接口
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=WeBox-Nginx
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo 错误: Nginx配置文件不存在...
    goto :EOF
  )
  echo. && echo 正在安装Nginx服务...
  %xnssm% install %scName% %mroot%\nginx.exe
  %xnssm% set %scName% DisplayName "WeBox Nginx Server" >nul
  %xnssm% set %scName% AppParameters -p %mroot% -c %mconf% >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo 正在卸载Nginx服务...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo 正在启动Nginx服务...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo 正在停止Nginx服务...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo 正在重启Nginx服务...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo 正在检查Nginx进程...
  ping 127.0.0.1 -n 5 >nul
  tasklist | findstr nginx.exe >nul
  if %errorlevel% neq 0 (
    echo 错误: Nginx启动失败
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  call %mroot%\nginx.exe -p %mroot% -c %mconf% -t
  goto :EOF
