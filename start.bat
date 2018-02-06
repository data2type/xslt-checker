echo off

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

rmdir /s /q %TEMPROOT%
mkdir %TEMPROOT%

mkdir %LOGDIR%
mkdir %TEMPDIR%00Config\
mkdir %TEMPDIR%\05Results\


java -jar saxon\saxon8.jar -l  -w0 -o %TCFG% %CFG% XSLT-Styles\01_MainProc\01MainProc.xsl   2>%LOGDIR%0101MainProc.log

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\03Commands\commands.xml %TCFG% XSLT-Styles\01_MainProc\02MainProc.xsl   2>%LOGDIR%0102MainProc.log

java -jar saxon\saxon8.jar -l -im {http://www.data2type/software/xslt-check}start -o %TEMPDIR%\dummy.xml %TCFG% %TEMPDIR%\01OutStyle\d2t.main.xsl   2>%LOGDIR%command.log

java -jar saxon\saxon8.jar -l  -w0 -o %LOGDIR%\used_commands.xml %TCFG% XSLT-Styles\02_CommandAnalyze\01ComUnique.xsl   2>%LOGDIR%0201ComUnique.log

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\05Results\unused_commands.xml %TEMPDIR%\03Commands\commands.xml XSLT-Styles\03_Result\01Result.xsl +used_commands=%LOGDIR%\used_commands.xml   2>%LOGDIR%0301Result.log

java -jar saxon\saxon8.jar -l  -w0 -o %TEMPDIR%\05Results\unused_commands.txt %TEMPDIR%\05Results\unused_commands.xml XSLT-Styles\03_Result\02Result2TXT.xsl 2>%LOGDIR%0302Result.log


mkdir %TRG_DIR%

robocopy %TEMPDIR%\05Results\ %TRG_DIR% /e /NJS /NJH 2>%LOGDIR%0401Copy.log

echo ### finished
pause 

:eof