@echo off
setlocal enabledelayedexpansion
title Black Ops 3 Workshop Link (Manual Mode)

echo ============================================================
echo        Black Ops 3 Workshop Symlink Utility (Manual)
echo ============================================================
echo.
echo Enter your Workshop folder path below.
echo Example: F:\SteamLibrary\steamapps\workshop\content\311210
echo.

set /p "workshop_path=Workshop path: "

if not exist "%workshop_path%\" (
    echo.
    echo [ERROR] Invalid path: "%workshop_path%"
    echo Please check the path and try again.
    pause
    exit /b 1
)

:: Create usermaps and mods directories if shit aint there
set "script_dir=%~dp0"
set "usermaps=%script_dir%usermaps"
set "mods=%script_dir%mods"

if not exist "%usermaps%" md "%usermaps%"
if not exist "%mods%" md "%mods%"

echo.
echo [INFO] Scanning workshop items...
echo.

for /f "delims=" %%D in ('dir "%workshop_path%" /b /ad 2^>nul') do (
    call :ProcessFolder "%%D"
)

echo.
echo [INFO] Done
echo ------------------------------------
echo Usermaps:
echo ------------------------------------
dir "%usermaps%" /b /ad
echo ------------------------------------
echo Mods:
echo ------------------------------------
dir "%mods%" /b /ad
echo ------------------------------------
pause
exit /b 0


:ProcessFolder
setlocal enabledelayedexpansion
set "shortname=%~1"
set "src=%workshop_path%\%shortname%"
set "mapname="
set "is_mod=0"

echo Checking folder: !shortname!

:: Detect zm_mod.ff or *_core_mod.ff for mods
for %%F in ("!src!\zm_mod.ff") do if exist "%%~fF" (
    set "mapname=zm_mod"
    set "is_mod=1"
)
for %%F in ("!src!\*_core_mod.ff") do if exist "%%~fF" (
    set "mapname=%%~nF"
    set "is_mod=1"
)

:: Otherwise detect zm_*.ff for usermaps
if !is_mod! EQU 0 (
    for %%F in ("!src!\zm_*.ff") do if exist "%%~fF" (
        set "mapname=%%~nF"
    )
)

:: Skip if nothing detected
if not defined mapname (
    echo   No zm_*.ff or zm_mod.ff found, skipping.
    endlocal
    goto :eof
)

:: Choose destination path
if !is_mod! EQU 1 (
    set "target=%mods%\!mapname!_!shortname!"
) else (
    set "target=%usermaps%\!mapname!"
)

:: Skip existing links
if exist "!target!" (
    echo   Skipping existing link: "!mapname!"
    endlocal
    goto :eof
)

echo   Linking "!shortname!" → "!target!"
mklink /J "!target!" "!src!" >nul 2>&1

if errorlevel 1 (
    echo   [ERROR] Failed to create link.
) else (
    echo   [OK] Linked successfully.
)

endlocal
goto :eof
