@echo off

rem Download the latest version of SeleniumBasic
curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/SeleniumBasic.zip

rem Enable delayed expansion for variables
setlocal enabledelayedexpansion

rem Set the URL for the JSON containing Chrome version information
set "json_url=https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"

rem Make an HTTP request and store the JSON response in a variable
for /f %%a in ('powershell -command "(Invoke-RestMethod '%json_url%').channels.Stable.version"') do set "stable_version=%%a"

rem Set the URL for chromedriver.zip
set "chromedriver_url=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/%stable_version%/win32/chromedriver-win32.zip"

rem Set the destination folder for the downloaded files
set "download_folder=%CD%"

rem Download chromedriver.zip using PowerShell
powershell -command "& {Invoke-WebRequest -Uri '%chromedriver_url%' -OutFile '%download_folder%\chromedriver-win32.zip'}"

rem Extract chromedriver.zip and SeleniumBasic.zip
powershell -command "& {Expand-Archive -Path '%download_folder%\chromedriver-win32.zip' -DestinationPath '%download_folder%' -Force}"
powershell -command "& {Expand-Archive -Path '%download_folder%\SeleniumBasic.zip' -DestinationPath '%download_folder%' -Force}"

rem Move chromedriver.exe to the SeleniumBasic folder
move "%download_folder%\chromedriver-win32\chromedriver.exe" "%download_folder%\SeleniumBasic\chromedriver.exe"

rem Move the SeleniumBasic folder to the user's local app data folder
move "%download_folder%\SeleniumBasic" "%LOCALAPPDATA%"

rem Clean up - delete downloaded files and folders
del /f /q "%download_folder%\chromedriver-win32.zip"
rmdir /s /q "%download_folder%\chromedriver-win32"
del /f /q "%download_folder%\SeleniumBasic.zip"
rmdir /s /q "%download_folder%\SeleniumBasic"

rem Pause the script to allow the user to see any error messages
pause

rem End local scope and exit the script
endlocal
exit
