@echo off
title GenisysPro Loop Server
color 0a
mode 55
cd /d %~dp0
tasklist /FI "IMAGENAME eq mintty.exe" 2>NUL | find /I /N "mintty.exe">NUL
if %ERRORLEVEL% equ 0 (
    goto :loop
    goto :start
)

:loop
tasklist /FI "IMAGENAME eq mintty.exe" 2>NUL | find /I /N "mintty.exe">NUL
if %ERRORLEVEL% equ 0 (
    goto :loop
) else (
	echo "GenisysPro -> Server is now OFFLINE"
	goto :start
)

:start
if exist bin\php\php.exe (
    set PHP_BINARY=bin\php\php.exe
) else (
    set PHP_BINARY=php
)
if exist PocketMine-MP.phar (
    set POCKETMINE_FILE=PocketMine-MP.phar
) else (
    if exist src\pocketmine\PocketMine.php (
        set POCKETMINE_FILE=src\pocketmine\PocketMine.php
    ) else (
        msg * "Couldn't find a valid PocketMine-MP installation..."
        pause
        exit 1
    )
)
echo "GenisysPro -> Server is now ONLINE"
if exist bin\php\php_wxwidgets.dll (
    %PHP_BINARY% %POCKETMINE_FILE% --enable-gui %*
) else (
    if exist bin\mintty.exe (
        start "" bin\mintty.exe -o Columns=100 -o Rows=40 -o AllowBlinking=0 -o FontQuality=10 -o Font="Consolas" -o FontHeight=12 -o CursorType=1 -o CursorBlinks=1 -h error -t "PocketMine-MP" %PHP_BINARY% %POCKETMINE_FILE% --enable-ansi %*
    ) else (
        %PHP_BINARY% -c bin\php %POCKETMINE_FILE% %*
    )
)

goto :loop
