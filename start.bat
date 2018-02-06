@echo off

set CFG=%~fp1
set TRG_DIR=%~fp2

if "%CFG%"=="" (

set CFG="%~dp0\config\config.xml"

)

if "%TRG_DIR%"=="" (

set TRG_DIR="%~dp0\sample\result"

)

set timef=%time::=%
set timef=%timef:,=%
set TEMPROOT=%TEMP%\XSLT-CHECKER-TEMPDIR\
set TEMPDIR=%TEMPROOT%\temp_%date:.=%%timef%\
set TCFG=%TEMPDIR%00Config\Config.xml

set LOGDIR=%TEMPDIR%\04LOG\

IF EXIST rmdir /s /q %TEMPROOT%
IF NOT EXIST %TEMPROOT% mkdir %TEMPROOT%

mkdir %LOGDIR%
mkdir %TEMPDIR%00Config\

mkdir %TEMPDIR%\05Results\

echo Prepare XSLT stylesheets and analyze for available commands

java -jar saxon\saxon8.jar -l  -w0 -o %TCFG% %CFG% XSLT-Styles\01_MainProc\01MainProc.xsl   2>%LOGDIR%0101MainProc.log

if %errorlevel% NEQ 0 call :error %LOGDIR%0101MainProc.log && goto :stop

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\03Commands\commands.xml %TCFG% XSLT-Styles\01_MainProc\02MainProc.xsl   2>%LOGDIR%0102MainProc.log

if %errorlevel% NEQ 0 call :error %LOGDIR%0102MainProc.log && goto :stop



echo Process XML data by the XSLT stylesheets

java -jar saxon\saxon8.jar -l -im {http://www.data2type/software/xslt-check}start -o %TEMPDIR%\dummy.xml %TCFG% %TEMPDIR%\01OutStyle\d2t.main.xsl 2>%LOGDIR%command.log

if %errorlevel% NEQ 0 call :error %LOGDIR%command.log && goto :stop



echo Analyze process log for used commands

java -jar saxon\saxon8.jar -l  -w0 -o %LOGDIR%\used_commands.xml %TCFG% XSLT-Styles\02_CommandAnalyze\01ComUnique.xsl   2>%LOGDIR%0201ComUnique.log

if %errorlevel% NEQ 0 call :error %LOGDIR%0201ComUnique.log && goto :stop



echo Compare existing commands with used commands

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\05Results\unused_commands.xml %TEMPDIR%\03Commands\commands.xml XSLT-Styles\03_Result\01Result.xsl +used_commands=%LOGDIR%\used_commands.xml   2>%LOGDIR%0301Result.log

if %errorlevel% NEQ 0 call :error %LOGDIR%0301Result.log && goto :stop



echo Create text version

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\05Results\unused_commands.txt %TEMPDIR%\05Results\unused_commands.xml XSLT-Styles\03_Result\02Result2TXT.xsl 2>%LOGDIR%0302Result.log

if %errorlevel% NEQ 0 call :error %LOGDIR%0302Result.log && goto :stop

IF NOT EXIST %TRG_DIR% mkdir %TRG_DIR%

robocopy %TEMPDIR%\05Results\ %TRG_DIR% /e /NJS /NJH 2>%LOGDIR%0402Copy.log >%LOGDIR%0401Copy.log

echo Finished! You will find the XSLT-Checker result in the output directory:
echo.
echo %TRG_DIR%
echo.
pause
goto :eof

:error
echo.
echo An error occured during the process!
echo.
echo Please read the following log:

echo.

type %1

echo.
echo (This log will also be copied into the result folder)
echo.

copy /y %1 %TRG_DIR%\error.log 2>%LOGDIR%0404CopyErrors.log >%LOGDIR%0403CopyErrors.log

pause
goto :eof

:stop
exit /b %errorlevel%

:eof