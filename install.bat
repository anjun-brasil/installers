rem @echo off

set service-dir=C:\etc

mkdir %service-dir% && cd %service-dir%

choco
if errorlevel gtr 0 goto install_chocolatey
goto test_node

:install_chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
goto test_node

:test_node
node -v
if errorlevel gtr 0 goto install_node
goto install_pm2

:install_node
cinst nodejs.install
if errorlevel 1 goto install_chocolatey
goto install_pm2

:install_pm2
npm i -g pm2
if errorlevel 1 goto install_node
goto install_git


:install_git
cinst git
goto clone_repo


:clone_repo
git clone https://github.com/anjun-brasil/printer-service.git
if errorlevel 1 goto install_git
goto build


:build
cd printer-service
npm build && goto start_service

:start_service
pm2 start dist/index.js && pm2 save && goto EOF

:EOF
exit




