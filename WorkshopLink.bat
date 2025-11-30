@echo off
setlocal enabledelayedexpansion

::  Detect paths
set "script_dir=%~dp0"
set "game_dir=%script_dir:~0,-1%"
set "workshop_path=%game_dir%\..\..\workshop\content\311210"
for %%I in ("%workshop_path%") do set "workshop_path=%%~fI"

echo Detected Workshop folder:
echo     %workshop_path%
if not exist "%workshop_path%\" (
    echo [ERROR] Could not find workshop folder.
    pause
    exit /b 1
)

set "usermaps=%game_dir%\usermaps"
set "mods=%game_dir%\mods"

if not exist "%usermaps%" md "%usermaps%"
if not exist "%mods%" md "%mods%"

set /a total_maps=0
set /a total_mods=0
set /a total_failed=0

echo.
echo [INFO] Scanning workshop items...
echo.


::  Loop through each workshop subfolder
for /f "delims=" %%D in ('dir "%workshop_path%" /b /ad 2^>nul') do (
    call :ProcessFolder "%workshop_path%\%%D"
)

:: ========================================
::  Summary
:: ========================================
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
echo.
echo Summary:
echo ------------------------------------
echo  Maps linked successfully : %total_maps%
echo  Mods linked successfully : %total_mods%
echo  Failed links             : %total_failed%
echo ------------------------------------
pause
exit /b 0


::  Subroutine to process each folder
:ProcessFolder
setlocal enabledelayedexpansion
set "src=%~1"
set "shortname=%~nx1"
set "mapname="
set "is_mod=0"

echo Checking folder: !shortname!

:: Detect mod or map
set "is_mod=0"
set "mapname="

:: Detect mods first
set "foldername="
if exist "!src!\zm_mod.ff" (
    set "is_mod=1"
    set "mapname=zm_mod"
    call :ReadFolderName "!src!\workshop.json" foldername
) else (
    for %%F in ("!src!\*_core_mod.ff") do (
        set "is_mod=1"
        set "mapname=%%~nF"
        call :ReadFolderName "!src!\workshop.json" foldername
        goto :found_mod
    )
)
:found_mod

:: If no mod found, check for usermaps
if !is_mod! equ 0 (
    for %%F in ("!src!\cp_*.ff" "!src!\mp_*.ff" "!src!\zm_*.ff") do (
        set "mapname=%%~nF"
        goto :found_map
    )
)
:found_map

if not defined mapname (
    echo   No cp_*.ff, mp_*.ff, zm_*.ff or *_core_mod.ff found, skipping.
    endlocal
    goto :eof
)

:: Determine target folder
if !is_mod! equ 1 (
    :: For mods, use FolderName from workshop.json if available, otherwise fallback
    if defined foldername (
        set "target=%mods%\!foldername!"
    ) else (
        set "target=%mods%\!mapname!_!shortname!"
    )
    set "link_target=!target!\zone"
) else (
    :: For usermaps, create folder named after the map, then symlink 'zone' inside
    set "target=%usermaps%\!mapname!"
    set "link_target=!target!\zone"
)

:: Skip if link exists
if exist "!link_target!" (
    echo   Skipping existing link: !link_target!
    endlocal
    goto :eof
)

:: Create the parent folder first (for both mods and usermaps)
if not exist "!target!" (
    md "!target!"
)

:: Create symbolic link
echo   Linking "!shortname!" → "!link_target!"
mklink /J "!link_target!" "!src!" >nul 2>&1
if errorlevel 1 (
    echo   [ERROR] Failed to create link.
    endlocal
    set /a total_failed+=1
    goto :eof
) else (
    echo   [OK] Linked successfully.
)

:: Increment counters
if !is_mod! equ 1 (
    endlocal & set /a total_mods+=1
) else (
    endlocal & set /a total_maps+=1
)
goto :eof

:: Subroutine to read FolderName from workshop.json
:ReadFolderName
setlocal enabledelayedexpansion
set "json_file=%~1"
set "result="

if exist "%json_file%" (
    for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "try { $json = Get-Content '%json_file%' -Raw | ConvertFrom-Json; Write-Output $json.FolderName } catch { }"`) do (
        set "result=%%A"
    )
)

endlocal & set "%~2=%result%"
goto :eof
