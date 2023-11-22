@echo off
if not exist "%TEMP%\excel-audit" (
    mkdir "%TEMP%\excel-audit"
    cd "%TEMP%\excel-audit"
    curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/ChromeSetup.exe
    curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/SeleniumBasic-2.0.9.0.exe
    curl -LO https://github.com/casualsoty/la-premiere-brique/releases/latest/download/chromedriver.exe
)
    start /wait %TEMP%\excel-audit\ChromeSetup.exe
    start /wait %TEMP%\excel-audit\SeleniumBasic-2.0.9.0.exe
    copy %TEMP%\excel-audit\chromedriver.exe %LOCALAPPDATA%\SeleniumBasic
    taskkill /f /im excel.exe
    start /wait excel.exe
