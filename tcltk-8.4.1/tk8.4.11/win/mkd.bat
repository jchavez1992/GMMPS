@echo off
rem RCS: @(#) $Id: mkd.bat,v 1.1.1.1 2006/01/16 18:21:15 abrighto Exp $

if exist %1\nul goto end

md %1
if errorlevel 1 goto end

echo Created directory %1

:end



