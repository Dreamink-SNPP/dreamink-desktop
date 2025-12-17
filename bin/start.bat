@echo off
cd /d %~dp0

:: Set environment variables
set RAILS_ENV=production
set RAILS_SERVE_STATIC_FILES=true
set RAILS_LOG_TO_STDOUT=true
set RAILS_FORCE_SSL=false

:: Generate secret key if not exists
if not exist .secret_key (
    powershell -Command "$([guid]::NewGuid().ToString('N'))" > .secret_key
)
set /p SECRET_KEY_BASE=<.secret_key

:: Initialize database if needed
if not exist storage\production.sqlite3 (
    dreamink.exe db:migrate
)

:: Start server and open browser
start http://localhost:3000
dreamink.exe server -p 3000 -b 127.0.0.1
