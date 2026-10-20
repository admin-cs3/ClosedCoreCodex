@echo off
setlocal
echo ClosedCoreCodex - FAT32 LBA formatter voor Windows
echo WAARSCHUWING: de gekozen schijf wordt volledig gewist.
echo.
echo Controleer eerst de schijfnummers met: diskpart, list disk, exit
echo.
set /p DISKNUM=Voer het nummer van de JUISTE EXTERNE USB-schijf in:
echo(%DISKNUM%| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
  echo Ongeldig schijfnummer. Gestopt.
  exit /b 1
)
echo.
echo Je staat op het punt schijf %DISKNUM% volledig te wissen.
set /p CONFIRM=Typ ERASE om door te gaan:
if /i not "%CONFIRM%"=="ERASE" (
  echo Geannuleerd.
  exit /b 1
)
set "DPFILE=%TEMP%\closedcorecodex-format-%RANDOM%.txt"
(
  echo select disk %DISKNUM%
  echo detail disk
  echo clean
  echo convert mbr
  echo create partition primary
  echo set id=0c
  echo format fs=fat32 quick label=USB
  echo assign
  echo exit
) > "%DPFILE%"
diskpart /s "%DPFILE%"
set "RESULT=%ERRORLEVEL%"
del "%DPFILE%" >nul 2>&1
if not "%RESULT%"=="0" (
  echo Formatteren is mislukt. Controleer de melding hierboven.
  exit /b 1
)
echo Klaar.
endlocal
