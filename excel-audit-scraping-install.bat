@echo off
if not exist "%TEMP%\excel-audit" (
    mkdir "%TEMP%\excel-audit"
)
cd "%TEMP%\excel-audit"
curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/ChromeSetup.exe
curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/SeleniumBasic-2.0.9.0.exe
start /wait %TEMP%\excel-audit\ChromeSetup.exe
start /wait %TEMP%\excel-audit\SeleniumBasic-2.0.9.0.exe

setlocal enabledelayedexpansion

REM Set the URL for JSON
set "json_url=https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"

REM Make the HTTP request and store the JSON response in a variable
for /f %%a in ('powershell -command "(Invoke-RestMethod '%json_url%').channels.Stable.version"') do set "stable_version=%%a"

REM Display the Stable version
echo Stable Version: %stable_version%

REM Set the URL for chromedriver.zip
set "chromedriver_url=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/%stable_version%/win32/chromedriver-win32.zip"

REM Set the destination folder for the downloaded file
set "download_folder=%CD%"
set "extract_folder=%LOCALAPPDATA%\SeleniumBasic"

REM Download chromedriver.zip using PowerShell
powershell -command "& {Invoke-WebRequest -Uri '%chromedriver_url%' -OutFile '%download_folder%\chromedriver-win32.zip'}"

REM Extract chromedriver.zip
powershell -command "& {Expand-Archive -Path '%download_folder%\chromedriver-win32.zip' -DestinationPath '%extract_folder%' -Force}"

REM Display extraction success message
echo Chromedriver extracted to: %extract_folder%

REM Move chromedriver.exe to the specified directory
move "%extract_folder%\chromedriver-win32\chromedriver.exe" "%extract_folder%\chromedriver.exe"

REM Display move success message
echo Chromedriver moved to: %extract_folder%\chromedriver.exe

start excel.exe

endlocal
exit
