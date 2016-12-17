@echo off

:: pacapt script directory
set dir=%~dp0

:: pacapt (batch-pacapt) version
set version=0.0.1

:: look for chocolatey
set chocolateyFound=true
where /q choco.exe
if ERRORLEVEL 1 ( set chocolateyFound=false )

:: set available operations
set availableOperations=
if %chocolateyFound%==true ( set availableOperations= )

:: parse parameters
if [%1]==[] (
  goto :handle_no_parameter
) else (
  goto :handle_parameters
)

:handle_no_parameter
call :display_usage
exit /B 1

:handle_parameters
set parameter=%1

if "%parameter%"=="-V" ( goto :display_version )
if "%parameter%"=="-h" ( goto :display_help )
if "%parameter%"=="--help" ( goto :display_help )
if "%parameter%"=="-P" ( goto :display_available_operations )

goto :display_usage
exit /B 1

:display_version
@echo pacapt (batch-pacapt) version: '%version%'
goto :eof

:display_usage
@echo Usage: pacapt ^<options^>   # -h for help, -P list supported functions
goto :eof

:display_help
type %dir%\help.txt
goto :eof

:display_available_operations
@echo pacapt: available operations: %availableOperations%
goto :eof
