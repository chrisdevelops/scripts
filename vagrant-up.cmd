@echo off

cd /d %~dp0

for /f "tokens=2* delims= " %%F in ('vagrant status ^| find /I "default"') do (
  set "vmstate=%%F"
)

if "%vmstate%" == "saved" (
  vagrant resume
)

if "%vmstate%" == "poweroff" (
  vagrant up
)

if "%vmstate%" == "aborted" (
  msg "%username%" VM is in an aborted state. Manual override required.
)
