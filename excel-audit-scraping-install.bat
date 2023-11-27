@echo off

rem Enable delayed expansion for variables
setlocal enabledelayedexpansion

rem Set the URL for the JSON containing Chrome version information
set "json_url=https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"

rem Make an HTTP request and store the JSON response in a variable
for /f %%a in ('powershell -command "(Invoke-RestMethod '%json_url%').channels.Stable.version"') do set "stable_version=%%a"

rem Set the URL for dotNetFx35setup.exe, SeleniumBasic-2.0.9.0.exe and chromedriver-win32.zip
set "dotnet_url=https://github.com/casualsoty/la-premiere-brique/releases/latest/download/dotNetFx35setup.exe"
set "seleniumexe_url=https://github.com/casualsoty/la-premiere-brique/releases/latest/download/SeleniumBasic-2.0.9.0.exe"
set "chromedriver_url=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/%stable_version%/win32/chromedriver-win32.zip"

rem Set the destination folder for the downloaded files
set "download_folder=%CD%"

rem Download dotNetFx35setup.exe, SeleniumBasic-2.0.9.0.exe and chromedriver-win32.zip using PowerShell
powershell -command "& {Invoke-WebRequest -Uri '%dotnet_url%' -OutFile '%download_folder%\dotNetFx35setup.exe'}"
powershell -command "& {Invoke-WebRequest -Uri '%seleniumexe_url%' -OutFile '%download_folder%\SeleniumBasic-2.0.9.0.exe'}"
powershell -command "& {Invoke-WebRequest -Uri '%chromedriver_url%' -OutFile '%download_folder%\chromedriver-win32.zip'}"

rem Extract chromedriver.zip
powershell -command "& {Expand-Archive -Path '%download_folder%\chromedriver-win32.zip' -DestinationPath '%download_folder%' -Force}"

rem Installs .NET Framework 3.5 using the provided setup executable.
start /wait dotNetFx35setup.exe

rem Installs SeleniumBasic version 2.0.9.0. 
start /wait SeleniumBasic-2.0.9.0.exe

rem Move chromedriver.exe to the SeleniumBasic folder
move "%download_folder%\chromedriver-win32\chromedriver.exe" "%LOCALAPPDATA%\SeleniumBasic\chromedriver.exe"

rem Clean up - delete downloaded files and folders
del /f /q "%download_folder%\dotNetFx35setup.exe"
del /f /q "%download_folder%\SeleniumBasic-2.0.9.0.exe"
del /f /q "%download_folder%\chromedriver-win32.zip"
rmdir /s /q "%download_folder%\chromedriver-win32"

rem End local scope and exit the script
endlocal
exit
