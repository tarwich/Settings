@ECHO OFF

SET mypath=%~dp0
node "%mypath:~0,-5%\bin\create-component" %*
