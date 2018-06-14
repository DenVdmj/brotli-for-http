@setlocal enableextensions enabledelayedexpansion
@chcp 65001>nul
@echo off

:main

  if "%~1"=="--help" goto:usage
  if "%~1"=="-h"     goto:usage
  if "%~1"=="/?"     goto:usage

  call "%~dpn0.env.bat"

  if "%~1"=="" (
    for /r %%i in (*.svg) do call "%~0" "%%~i"
    goto:eof
  )

  rem  for %%i in (32 48 128 256) do call svg-to-png "%~1" %%i

  rem call :optimize-png

  call :print-json "%~n1" "%~dpn1\.." >icons.manifest.json

goto:eof

:print-json
  echo   "icons": {
  echo      "32": "%~nx2/%~1-32x32.png",
  echo      "48": "%~nx2/%~1-48x48.png",
  echo     "128": "%~nx2/%~1-128x128.png",
  echo     "256": "%~nx2/%~1-256x256.png"
  echo   },
goto:eof

:svg-to-png
  setlocal
  set svgfile=%~dpnx1
  set pngname=%~dpn1
  set w=%~2
  set h=%~2
  if not "%~3"=="" set h=%~3
  set pngfile=%pngname%-%w%x%h%.png
  echo Create file «%pngfile%»
  "%inkscape%" --file="%svgfile%" --export-png="%pngfile%" -w=%w% -h=%h%
goto:eof

:optimize-png
  @echo on
  for /r %%i in (*.png) do (
    %truepng% -cq c=32 "%%~i"
    %pngwolf% --in="%%~i" --out="%%~i" --zlib-level=9
  )
goto:eof

:usage
  echo Set up pathes in “%~n0.env.bat”
  echo.Usage:
  echo.  %~nx0 "any-svg-file.svg"
  echo.
  echo.For all *.svg in current directory:
  echo.  %~nx0
goto:eof
