@ECHO OFF

C:
CD \NodeJS\ROBOS\Robot_Senior

SET SERVICENAME=Node_BOT_Senior_Itrack
SET NSSM="%CD%\nssm\nssm.exe"

ECHO INSTALLING SERVICE %SERVICENAME%

%NSSM% stop %SERVICENAME%
%NSSM% remove %SERVICENAME% confirm
