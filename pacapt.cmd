
  ::::::::::::::::::::::::::::::::::
  ::::::::::::::::::::::::::::::::::
  ::::                          ::::
  ::::       batch-pacapt       ::::
  ::::                          ::::
  ::::::::::::::::::::::::::::::::::
  ::::::::::::::::::::::::::::::::::


@echo off
setlocal enabledelayedexpansion

:: pacapt script directory
set dir=%~dp0

:: pacapt (batch-pacapt) version
set version=0.0.1

:: define parameters types
set INVALIDPARAMETER=-1
set NOPARAMETER=0
set OPTIONPARAMETER=1
set OPERATIONPARAMETER=2
set RAWPARAMETER=3

:: define current operation
set operationFound=false
set operation=

:: define options for current operation
:: --noconfirm, -w/--downloadonly
set noConfirm=false
set downloadOnly=false

:: define raw parameters
set rawParameters=

:: look for chocolatey
set chocolateyFound=false
where /q choco.exe
if %ERRORLEVEL%==0 (
  set chocolateyFound=true
)

:parse_parameters
set paramIndex=0
for %%x in (%*) do (
  set /A paramIndex+=1
  set "parameters[!paramIndex!]=%%~x"
)

:tokenize_parameters
if !paramIndex!==0 ( goto :interpret_no_parameter )
for /L %%i in (1,1,%paramIndex%) do (
  set paramToken=!INVALIDPARAMETER!
  call :tokenize_parameter !parameters[%%i]!
  call :interpret_parameter !parameters[%%i]! !paramToken!
  if not !ERRORLEVEL!==0 ( exit /b !ERRORLEVEL! )
)

:: we will consider operations to be:
:: -V, -h/--help, -P
:: -S*, -U*, -Q*, -R*
:handle_current_operation
if %operationFound%==false (
  @echo error: no operation specified
  exit /b 1
)

if "%operation%"=="-V" ( goto :display_version )
if "%operation%"=="-h" ( goto :display_help )
if "%operation%"=="--help" ( goto :display_help )
if "%operation%"=="-P" ( goto :display_available_operations )

if "%operation:~0,2%"=="-S" ( goto :handle_synchronize_operation )
if "%operation:~0,2%"=="-U" ( goto :handle_upgrade_operation )
if "%operation:~0,2%"=="-Q" ( goto :handle_query_operation )
if "%operation:~0,2%"=="-R" ( goto :handle_remove_operation )
goto :eof

:tokenize_parameter parameter
set parameter=%1

if "%parameter:~0,1%"=="-" (
  for %%d in (--noconfirm --downloadonly -w) do (
    if "%parameter%"=="%%d" ( set paramToken=%OPTIONPARAMETER% )
  )
  for %%d in (S Ss Su Sy Suy Syu Sc Scc Sccc U Q Qc Qi Ql Qm Qo Qp Qs R) do (
    if "%parameter%"=="-%%d" ( set paramToken=%OPERATIONPARAMETER% )
  )
  for %%d in (-V -h --help -P) do (
    if "%parameter%"=="%%d" ( set paramToken=%OPERATIONPARAMETER% )
  )
) else (
  set paramToken=%RAWPARAMETER%
)
goto :eof

:interpret_parameter parameter token
if %2==%INVALIDPARAMETER% ( call :interpret_invalid_parameter %1 )
if %2==%OPTIONPARAMETER% ( call :interpret_option_parameter %1 )
if %2==%OPERATIONPARAMETER% ( call :interpret_operation_parameter %1 )
if %2==%RAWPARAMETER% ( call :interpret_raw_parameter %1 )
goto :eof

:interpret_invalid_parameter parameter
@echo error: invalid parameter '%1'
exit /b 1

:interpret_no_parameter
call :display_usage
exit /b 1

:interpret_option_parameter parameter
if "%1"=="--noconfirm" ( set noConfirm=true )
if "%1"=="--downloadonly" ( set downloadOnly=true )
if "%1"=="-w" ( set downloadOnly=true )
goto :eof

:interpret_operation_parameter parameter
if %operationFound%==true (
  @echo error: only one operation may be used at a time
  @echo found '%operation%' and '%1'
  exit /b 1
) else (
  set operation=%1
  set operationFound=true
)
goto :eof

:interpret_raw_parameter parameter
if "%rawParameters%"=="" (
  set rawParameters="%1"
) else (
  set rawParameters=%rawParameters% "%1"
)
goto :eof

:display_version
@echo pacapt (batch-pacapt) version: '%version%'
exit /b 0

:display_usage
@echo Usage: pacapt ^<options^>   # -h for help, -P list supported functions
exit /b 0

:display_help
type %dir%\help.txt
exit /b 0

:: -V, -h/--help and -P will not be displayed here
:display_available_operations
set availableOperations=S

if %chocolateyFound%==false (
  set availableOperations=
)

@echo pacapt: available operations: %availableOperations%
exit /b 0

:handle_synchronize_operation
if "%operation%"=="-S" ( goto handle_operation_S )
if "%operation%"=="-Ss" ( goto handle_operation_Ss )
if "%operation%"=="-Su" ( goto handle_operation_Su )
if "%operation%"=="-Sy" ( goto handle_operation_Sy )
if "%operation%"=="-Suy" ( goto handle_operation_Syu )
if "%operation%"=="-Syu" ( goto handle_operation_Syu )
if "%operation%"=="-Sc" ( goto handle_operation_Sc )
if "%operation%"=="-Scc" ( goto handle_operation_Scc )
if "%operation%"=="-Sccc" ( goto handle_operation_Sccc )
goto :eof

:handle_upgrade_operation
if "%operation%"=="-U" ( goto handle_operation_U )
goto :eof

:handle_query_operation
if "%operation%"=="-Q" ( goto handle_operation_Q )
if "%operation%"=="-Qc" ( goto handle_operation_Qc )
if "%operation%"=="-Qi" ( goto handle_operation_Qi )
if "%operation%"=="-Ql" ( goto handle_operation_Ql )
if "%operation%"=="-Qm" ( goto handle_operation_Qm )
if "%operation%"=="-Qo" ( goto handle_operation_Qo )
if "%operation%"=="-Qp" ( goto handle_operation_Qp )
if "%operation%"=="-Qs" ( goto handle_operation_Qs )
goto :eof

:handle_remove_operation
if "%operation%"=="-R" ( goto handle_operation_R )
goto :eof

:handle_invalid_operation operation
@echo chocolatey: '%1' operation is invalid or not implemented.
goto :eof

:handle_operation_S
@echo launch operation %operation%
@echo options: noConfirm=%noConfirm%, downloadOnly=%downloadOnly%
@echo raw parameters: %rawParameters%
exit /b 0

:handle_operation_Ss
call :handle_invalid_operation Ss
exit /b 1

:handle_operation_Su
call :handle_invalid_operation Su
exit /b 1

:handle_operation_Sy
call :handle_invalid_operation Sy
exit /b 1

:handle_operation_Suy
:: forward :handle_operation_Suy to :handle_operation_Syu
:: both operations will be considered the same

:handle_operation_Syu
call :handle_invalid_operation Syu
exit /b 1

:handle_operation_Sc
call :handle_invalid_operation Sc
exit /b 1

:handle_operation_Scc
call :handle_invalid_operation Scc
exit /b 1

:handle_operation_Sccc
call :handle_invalid_operation Sccc
exit /b 1

:handle_operation_U
call :handle_invalid_operation U
exit /b 1

:handle_operation_Q
call :handle_invalid_operation Q
exit /b 1

:handle_operation_Qc
call :handle_invalid_operation Qc
exit /b 1

:handle_operation_Qi
call :handle_invalid_operation Qi
exit /b 1

:handle_operation_Ql
call :handle_invalid_operation Ql
exit /b 1

:handle_operation_Qm
call :handle_invalid_operation Qm
exit /b 1

:handle_operation_Qo
call :handle_invalid_operation Qo
exit /b 1

:handle_operation_Qp
call :handle_invalid_operation Qp
exit /b 1

:handle_operation_Qs
call :handle_invalid_operation Qs
exit /b 1

:handle_operation_R
call :handle_invalid_operation R
exit /b 1
