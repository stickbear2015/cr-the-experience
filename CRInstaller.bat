@echo off
:: Checking for admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges. Please right-click the file and select "Run as administrator."
    pause
    exit /b
)

setlocal

set "source=%~dp0"
set "target=C:\Users\%USERNAME%\Documents\VIP Mud"
set "logfile=C:\Users\%USERNAME%\Documents\VIPMudInstallLog.txt"

set /p mudName=Please enter the name for your MUD session (no spaces allowed): 

for /f "tokens=* delims= " %%A in ("%mudName%") do set "mudName=%%A"

if "%mudName%" neq "%mudName: =%" (
    echo ERROR: The MUD session name should not contain spaces.
    echo ERROR: The MUD session name contains spaces at %date% %time% >> "%logfile%"
    pause
    exit /b
)

echo Installation started at %date% %time% > "%logfile%"

if not exist "%target%" (
    echo VIP Mud folder not found, creating folder...
    mkdir "%target%"
    echo VIP Mud folder created at %date% %time% >> "%logfile%"
) else (
    echo VIP Mud folder already exists.
    echo VIP Mud folder already existed at %date% %time% >> "%logfile%"
)

echo Copying files and folders to %target%...

set "fileList=sounds CosmicRageBufferlist.txt readme.txt settings.set sounds.ini"

for %%f in (%fileList%) do (
    if not exist "%target%\%%f" (
        echo Copying %%f to %target%...
        xcopy "%source%\%%f" "%target%\" /I /Y >nul
        if %errorlevel% GEQ 1 (
            echo ERROR: Xcopy encountered errors while copying %%f.
            echo ERROR: Xcopy encountered errors at %date% %time% >> "%logfile%"
            exit /b
        ) else (
            echo Successfully copied %%f >> "%logfile%"
        )
    ) else (
        echo %%f already exists, skipping copy.
        echo %%f already exists at %date% %time% >> "%logfile%"
    )
)

set "cosmicRageFolder=%target%\Cosmic Rage"
if not exist "%cosmicRageFolder%" (
    echo Copying Cosmic Rage folder to %target%...
    xcopy "%source%\Cosmic Rage" "%target%\Cosmic Rage\" /E /I /Y >nul
    if %errorlevel% GEQ 1 (
        echo ERROR: Xcopy encountered errors while copying Cosmic Rage folder.
        echo ERROR: Xcopy encountered errors at %date% %time% >> "%logfile%"
        exit /b
    ) else (
        echo Successfully copied Cosmic Rage folder >> "%logfile%"
    )
) else (
    echo Cosmic Rage folder already exists, skipping copy.
    echo Cosmic Rage folder already exists at %date% %time% >> "%logfile%"
)

set "charFile=%cosmicRageFolder%\%mudName%.set"
echo #Char %mudName% > "%charFile%"

if %errorlevel% neq 0 (
    echo ERROR: Failed to create the character set file.
    echo ERROR: Failed to create %charFile% at %date% %time% >> "%logfile%"
) else (
    echo Character set file %charFile% created successfully >> "%logfile%"
)

echo.
echo All files have been processed.
echo MUD session setup complete.
echo.
echo To complete the setup, follow these steps:
echo 1. Open VIP Mud and locate the session named {mudName}.
echo 2. Press Control + E to access session settings.
echo 3. Configure the ports to 7777. host to cosmicrage.earth. and set the Cosmic Rage directory to "Cosmic Rage" as indicated in the readme file.
echo.

:: Prompt to open readme file
set /p openReadme=Do you want to open the readme file now? (Y/N): 
if /I "%openReadme%"=="Y" (
    start "" "%target%\readme.txt"
)

echo Check the log file at "%logfile%" for more details.
echo If you have problems in the installation process, please contact Nemesis as the creator of this script. Thank You.
pause
