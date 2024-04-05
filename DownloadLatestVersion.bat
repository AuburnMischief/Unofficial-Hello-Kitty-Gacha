@echo off
setlocal

rem Clone the repository into a temporary directory
git clone "https://github.com/AuburnMischief/Unofficial-Hello-Kitty-Gacha.git" "%TEMP%\Unofficial-Hello-Kitty-Gacha"

echo Repository cloned successfully.

rem Move files from the cloned directory to the current directory
for %%i in ("%TEMP%\Unofficial-Hello-Kitty-Gacha\*") do (
    if /i not "%%~nxi"=="DownloadLatestVersion.bat" (
        move "%%i" "%~dp0"
    )
)

echo Files copied successfully.

rem Remove the now empty directory
rmdir /s /q "%TEMP%\Unofficial-Hello-Kitty-Gacha"

echo Done.
pause