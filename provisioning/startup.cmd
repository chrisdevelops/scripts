@echo off

cd %USERPROFILE%\workspace\servers\ubuntu

for /f "tokens=2* delims= " %%F in ('vagrant status ^| find /I "default"') do (
  set "vmstate=%%F"
)

echo VM State: "%vmstate%"

if "%vmstate%" == "saved" (
  echo Resuming VM
  vagrant resume
)

if "%vmstate%" == "poweroff" (
  echo Booting VM
  vagrant up
)

if "%vmstate%" == "running" (
  echo No action required.
)

if "%vmstate%" == "aborted" (
  msg "%username%" VM is in an aborted state. Manual override required.
)

cmd /k
