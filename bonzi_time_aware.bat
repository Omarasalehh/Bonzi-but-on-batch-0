@echo off
:: Detect Windows Version
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    set "winver=%%i.%%j"
)

:: Check if major version is less than 10
setlocal enabledelayedexpansion
set "v=!winver!"
for /f "tokens=1 delims=." %%x in ("!v!") do (
    if %%x LSS 10 (
        mshta "javascript:alert('Some features may not work on your version of Windows (!winver!)\nPlease consider upgrading if you can.');close()"
    )
)
endlocal

setlocal enabledelayedexpansion

:: Set storage paths
set "appDataFolder=%APPDATA%\BonziClone"
set "nameFile=%appDataFolder%\name.txt"
set "colorFile=%appDataFolder%\color.txt"

:: Create folder if it doesn't exist
if not exist "%appDataFolder%" mkdir "%appDataFolder%"

:: Ask for name and color if not stored
if not exist "%nameFile%" (
    set /p realname=What's your name?: 
    echo !realname! > "%nameFile%"
) else (
    set /p realname=<"%nameFile%"
)

if not exist "%colorFile%" (
    set /p favcolor=What's your favorite color?: 
    echo !favcolor! > "%colorFile%"
) else (
    set /p favcolor=<"%colorFile%"
)

:: Greet based on time
for /f "tokens=1 delims=:" %%A in ("%time%") do set hour=%%A
if "%hour:~0,1%"=="0" set hour=%hour:~1%

if %hour% GEQ 5 if %hour% LSS 12 (
    set /a rand=%random%%%2
    if !rand! EQU 0 (
        set "message=Good morning, !realname!!"
    ) else (
        set "message=It's good to start the day off with you, !realname!!"
    )
) else if %hour% GEQ 12 if %hour% LSS 18 (
    set "message=Happy afternoon, !realname!!"
) else (
    set /a rand=%random%%%4
    if !rand! EQU 0 (
        set "message=Surprised to see you up this late, !realname!!"
    ) else if !rand! EQU 1 (
        set "message=Isn't it past your bedtime, !realname!!"
    ) else if !rand! EQU 2 (
        set "message=Do you ever sleep, !realname!!"
    ) else (
        set "message=I'm not used to being up this late, !realname!!"
    )
)
mshta "javascript:var sh=new ActiveXObject('SAPI.SpVoice'); sh.Speak('%message%');close()"

:: Menu
:menu
cls
color 0A
echo === BonziClone Assistant ===
echo Hello, !realname! Your favorite color is !favcolor!
echo.
echo [1] Tell me a joke
echo [2] Tell me a story
echo [3] Sing a song
echo [4] Play a quiz game
echo [5] Toggle prank mode
echo [6] Exit
set /p choice=Choose an option: 

if "%choice%"=="1" call :joke
if "%choice%"=="2" call :story
if "%choice%"=="3" call :song
if "%choice%"=="4" call :quiz
if "%choice%"=="5" call :prank
if "%choice%"=="6" exit

pause
goto menu

:joke
set /a r=%random%%%3
if !r! EQU 0 set msg=Why did the computer go to therapy? It had a hard drive!
if !r! EQU 1 set msg=I told my CPU a joke, but it didn’t process it.
if !r! EQU 2 set msg=What’s a computer’s favorite snack? Microchips!
goto :speakmsg

:story
set /a r=%random%%%2
if !r! EQU 0 set msg=Once upon a time, a user named !realname! clicked the wrong EXE... and nothing happened. Boring story!
if !r! EQU 1 set msg=In a folder deep inside the C drive, there lived a happy script named BonziClone...
goto :speakmsg

:song
set msg=I am your buddy, yes it's true~ I live in AppData just like you~
goto :speakmsg

:quiz
set /p answer=What does CPU stand for?: 
if /i "%answer%"=="Central Processing Unit" (
    echo Correct!
) else (
    echo Wrong! It's Central Processing Unit.
)
pause
goto menu

:prank
set /a r=%random%%%3
if !r!==0 set prankmsg=I see what you're doing 👀
if !r!==1 set prankmsg=Are you watching me?
if !r!==2 set prankmsg=Scanning your desktop...
mshta "javascript:var sh=new ActiveXObject('SAPI.SpVoice'); sh.Speak('%prankmsg%');close()"
pause
goto menu

:speakmsg
mshta "javascript:var sh=new ActiveXObject('SAPI.SpVoice'); sh.Speak('%msg%');close()"
goto menu
