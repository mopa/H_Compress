REM Fix MKV header compression issues on Standalone media players
REM Requires MKVToolnix
REM Version 1.0
REM Author: Pablo M. Pareja
@ECHO OFF
SET HOMEDIR=%~dp0
SET LOGFILE=%~dpn0_log.txt
REM SET MKVTOOLPATH=C:\Program Files\MKVToolnix
SET KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mmg.exe"
FOR /F "tokens=2*" %%A IN ('REG QUERY %KEY%') DO SET MKVTOOLPATH=%%B
IF "%MKVTOOLPATH%" == "" (
FOR /F "tokens=*" %%I IN ('DIR "%HOMEDRIVE%\mkvmerge.exe" /s /b') DO SET MKVTOOLPATH=%%I
)
IF "%MKVTOOLPATH%" == "" (
ECHO %DATE%%TIME%: MKVToolnix NOT found!!!>"%LOGFILE%"
GOTO STATUS
) ELSE (
ECHO %DATE%%TIME%: MKVToolnix found at "%MKVTOOLPATH%">"%LOGFILE%"
)

IF (%1) == () GOTO CLICKED
ECHO FixMKV v2 removing Header Compression from all files DROPPED!!
ECHO %DATE%%TIME%: PROCESSING ALL FILES DRAGGED AND DROPPED>>"%LOGFILE%"

:DROPFILES
IF (%1) == () GOTO STATUS
CALL :MKVFIXMUX %1 "%MKVTOOLPATH%"
SHIFT
GOTO DROPFILES

:CLICKED
ECHO FixMKV v2 removing Header Compression from all files in %HOMEDIR% AND all Sub-Directories!!
ECHO %DATE%%TIME%: PROCESSING ALL FILES IN %HOMEDIR% + SUBDIRECTORIES>>"%LOGFILE%"
FOR /F "delims=*" %%A IN ('dir /b /s *.MKV') DO CALL :MKVFIXMUX "%%A" "%MKVTOOLPATH%"

:STATUS
START "" "%LOGFILE%"
PING 1.1.1.1 -w 1000 -n 2$1>nul
DEL "%LOGFILE%"
GOTO END

:MKVFIXMUX
ECHO %DATE%%TIME%: "%~nx1" - Header Compression Found, processing ... >>"%LOGFILE%"
"%~dp2mkvmerge.exe" -o "%~dpn1_fix.mkv" --engage keep_bitstream_ar_info -A -S --compression -1:none "%~dpnx1" -D -S --compression -1:none "%~dpnx1" -A -D --compression -1:none "%~dpnx1">nul

:END