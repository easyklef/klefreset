@echo off

REM ============================================================================
:Admin_Check
cd /d "%~dp0" && ( if exist "%TEMP%\getadmin.vbs" del "%TEMP%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~0"" %params%", "", "runas", 1 > "%TEMP%\getadmin.vbs" && "%TEMP%\getadmin.vbs" && exit /B )
REM ============================================================================

echo ===================================================================
echo     NEIS / K-Edufine �� ���� Internet Explorer �缳�� ��ũ��Ʈ     
echo ===================================================================

REM ============================================================================
REM �õ� �⺻ ���� : �õ���� �⺻ �������� �����ؾ� �մϴ�.
set SIDO=�׽�Ʈ����û
set SIDO_URL=test.go.kr
REM ============================================================================

REM ==== ������ ���� =============================================================
echo ��Ȱ�� ������ ���� �������� �����մϴ�.
echo .

echo TaskKill /f /im iexplorer.exe
echo TaskKill /f /im msedge.exe
echo TaskKill /f /im microsoftEdge.exe
echo TaskKill /f /im chrome.exe
REM ============================================================================

REM ==== MS Edge �ڵ� ��ȯ ��� ���� ================================================
echo Internet Explorer ����� MS Edge�� �ڵ� ��ȯ�Ǵ� ����� �����մϴ�.
echo .

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" /v "{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}" /t REG_SZ /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}" /v "NoInternetExplorer" /t REG_SZ /d 1 /f
REM ============================================================================

REM ==== �ŷ��� �� �ִ� ����Ʈ ��� ===================================================
echo   %SIDO% ������(*.%SIDO_URL%)�� �ŷ��� �� �ִ� ����Ʈ�� ����մϴ�.
echo .

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%SIDO_URL%" /v "*" /t REG_DWORD /d 00000002 /f
echo   NEIS / K-�������� �������� ����Ʈ�� �ŷ��� �� �ִ� ����Ʈ�� ����մϴ�.
echo .

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\klef.go.kr\help" /v "*" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\neis.go.kr\help" /v "*" /t REG_DWORD /d 00000002 /f
REM ============================================================================

REM ==== IE �⺻���� ��� ==========================================================
echo   Internet Explore �⺻ ������ ����մϴ�.(�˾���������, ȣȯ������ ���� ����)
echo .
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Internet Explorer\Restrictions" /v NoHelpItemSendFeedback /t REG_DWORD /d 00000001 /f
REM ActiveX���͸� ����
REG DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_RESTRICT_ACTIVEXINSTALL" /f
REG DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Safety\ActiveXFiltering" /f
REM �˾����� ����
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows" /v PopupMgr /t REG_DWORD /d "0" /f
REM Windows Defender SmartScreen ���� ����
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV9 /t REG_DWORD /d "0" /f
REM ȣȯ�� ���� ���� �ʱ�ȭ
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\BrowserEmulation\ClearableListData" /v "UserFilter" /f
REM TLS ��� ���
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SecureProtocols" /t REG_DWORD /d 2688 /f
REM �����Ҷ� �˻���ϻ��� üũ ����
REM REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d 00000000 /f
REM ����� �������� ������Ȯ�� -> ���������� ��������
REM REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SyncMode5" /t REG_DWORD /d 00000003 /f
REM ����� ��ũ ���� 330MB�� ����

REM ============================================================================

REM ==== IE ���� ���� �ʱ�ȭ =======================================================
echo   Internet Explorer ���� ���� ������ �ʱ�ȭ�մϴ�.

if exist "%TEMP%\IE.vbs" del "%TEMP%\IE.vbs"

ECHO set WshShell = Wscript.CreateObject("Wscript.Shell")  > %TEMP%\IE.vbs
ECHO WshShell.Run("rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,0")  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 1000  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "^{TAB}"  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 500  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "%%R"  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 500  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "{TAB}"  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 500  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "{TAB}"  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 500  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "{TAB}"  >> %TEMP%\IE.vbs
ECHO WScript.Sleep 500  >> %TEMP%\IE.vbs
ECHO WshShell.SendKeys "{ENTER}"  >> %TEMP%\IE.vbs

CScript //nologo %TEMP%\IE.vbs

if exist "%TEMP%\IE.vbs" del "%TEMP%\IE.vbs"
REM ============================================================================

REM ==== ���ͳݿɼ� ������ ���� ======================================================
echo ���ͳݿɼ� �� ������ ������ �����մϴ�.
REM ����� ���� ���� ���� ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "CurrentLevel" /t REG_DWORD /d 00000000 /f
REM Windows Defender SmartScreen ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2301" /t REG_DWORD /d 00000003 /f
REM ������Ʈ���� �ּ� �Ǵ� ����ǥ���� ���� â�� ������ ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2104" /t REG_DWORD /d 00000000 /f
REM ũ�� �� ��ġ ���� ���� ��ũ��Ʈ ���� â�� �� �� �ֽ��ϴ�.
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2102" /t REG_DWORD /d 00000000 /f
REM �˾� ���� ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1609" /t REG_DWORD /d 00000000 /f
REM ȥ�յ� ������ ǥ��
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1809" /t REG_DWORD /d 00000003 /f
REM XSS ���� ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1409" /t REG_DWORD /d 00000003 /f
REM �� ����Ʈ���� ��ũ���õ� â�� ����Ͽ� ������ ��û�ϵ��� ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2105" /t REG_DWORD /d 00000000 /f
REM ���α׷� Ŭ������ �׼��� ���
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1407" /t REG_DWORD /d 00000000 /f
REM ��ȣ��� ��� ����
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2500" /t REG_DWORD /d 00000003 /f
REM ============================================================================



REM ==== K-�������� ��ȱ� ���� ActiveX �������� =======================================
echo ��ȱ� ���� ActiveX�� �����մϴ�.
REM HSAttach Class
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{205D1F4F-DB85-4393-AC6D-D3FF2434E37E}\iexplore" /v "Count" /t REG_DWORD /d 0 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{205D1F4F-DB85-4393-AC6D-D3FF2434E37E}\iexplore\AllowedDomains\*" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Settings\{205D1F4F-DB85-4393-AC6D-D3FF2434E37E}" /f

REM HShell WShell Class
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{AA4372DE-FBA7-4DF1-B213-A3E17859B6E7}\iexplore" /v "Count" /t REG_DWORD /d 0 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{AA4372DE-FBA7-4DF1-B213-A3E17859B6E7}\iexplore\AllowedDomains\*" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Settings\{AA4372DE-FBA7-4DF1-B213-A3E17859B6E7}" /f

REM HwpODTCtrl Control
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{BD9C32E4-3155-4691-8972-097D53B10052}\iexplore" /v "Count" /t REG_DWORD /d 0 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{BD9C32E4-3155-4691-8972-097D53B10052}\iexplore\AllowedDomains\*" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Settings\{BD9C32E4-3155-4691-8972-097D53B10052}" /f

REM HwpCtrl Control
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{BD9C32DE-3155-4691-8972-097D53B10052}\iexplore" /v "Count" /t REG_DWORD /d 0 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Stats\{BD9C32DE-3155-4691-8972-097D53B10052}\iexplore\AllowedDomains\*" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\Settings\{BD9C32DE-3155-4691-8972-097D53B10052}" /f
REM ============================================================================

