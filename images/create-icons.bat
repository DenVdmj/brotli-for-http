@setlocal enableextensions enabledelayedexpansion
@chcp 65001>nul
@echo off

:main

  if "%~1"=="--help" goto:usage
  if "%~1"=="-h"     goto:usage
  if "%~1"=="/?"     goto:usage

  set settings=%~dpn0.env.bat
  set PNGColors=32
  set ZipLevel=9

  if not exist "%settings%" (
    call:print-settings > "%settings%"
  )

  call "%settings%"

  if "%~1"=="" (
    for /r %%i in (*.svg) do (
      call:create-png "%%~i"
    )
  ) else (
    call:create-png "%~1"
  )

goto:eof

:create-png
  for %%i in (32 48 128 256) do (
    call:svg-to-png "%~1" %%i
  )
  call:optimize-png
  call:print-json "%~n1" "%~dpn1\.." >icons.manifest.json
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
  "%Inkscape%" --file="%svgfile%" --export-png="%pngfile%" -w=%w% -h=%h%
  endlocal
goto:eof

:optimize-png
  for /r %%i in (*.png) do (
    "%TruePNG%" -cq c=%PNGColors% "%%~i"
    "%PNGWolf%" --in="%%~i" --out="%%~i" --zlib-level=%ZipLevel%
  )
goto:eof

:print-json
  echo   "icons": {
  echo      "32": "%~nx2/%~1-32x32.png",
  echo      "48": "%~nx2/%~1-48x48.png",
  echo     "128": "%~nx2/%~1-128x128.png",
  echo     "256": "%~nx2/%~1-256x256.png"
  echo   },
goto:eof

:print-settings
  echo set UtilPath=/program/.imagetools/icatalyst-2.7/tools/apps
  echo set Inkscape=/program/inkscape/inkscape
  echo set PNGWolf=%%UtilPath%%/pngwolfzopfli.exe
  echo set TruePNG=%%UtilPath%%/truepng.exe
  echo set PNGColors=32
  echo set ZipLevel=9
goto:eof

:usage
  echo.First set up pathes in “%~n0.env.bat”:
  echo.
  echo.  set Inkscape=/path/to/inkscape.exe
  echo.  set PNGWolf=/path/to/PNGWolfZopfli.exe
  echo.  set TruePNG=/path/to/TruePNG.exe
  echo.
  echo.Usage:
  echo.  %~nx0 "any-svg-file.svg"
  echo.
  echo.For all *.svg in current directory:
  echo.  %~nx0
goto:eof
