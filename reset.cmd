@echo off

REM ============================================================================
:Admin_Check
cd /d "%~dp0" && ( if exist "%TEMP%\getadmin.vbs" del "%TEMP%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~0"" %params%", "", "runas", 1 > "%TEMP%\getadmin.vbs" && "%TEMP%\getadmin.vbs" && exit /B )
REM ============================================================================

echo ===================================================================
echo     NEIS / K-Edufine 을 위한 Internet Explorer 재설정 스크립트     
echo ===================================================================

REM ============================================================================
REM 시도 기본 설정 : 시도명과 기본 도메인을 수정해야 합니다.
set SIDO=테스트교육청
set SIDO_URL=test.go.kr
REM ============================================================================

REM ==== 브라우저 종료 =============================================================
echo 원활한 설정을 위해 브라우저를 종료합니다.
echo .

echo TaskKill /f /im iexplorer.exe
echo TaskKill /f /im msedge.exe
echo TaskKill /f /im microsoftEdge.exe
echo TaskKill /f /im chrome.exe
REM ============================================================================

REM ==== MS Edge 자동 전환 기능 차단 ================================================
echo Internet Explorer 실행시 MS Edge로 자동 전환되는 기능을 차단합니다.
echo .

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" /v "{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}" /t REG_SZ /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}" /v "NoInternetExplorer" /t REG_SZ /d 1 /f
REM ============================================================================

REM ==== 신뢰할 수 있는 사이트 등록 ===================================================
echo   %SIDO% 도메인(*.%SIDO_URL%)을 신뢰할 수 있는 사이트로 등록합니다.
echo .

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%SIDO_URL%" /v "*" /t REG_DWORD /d 00000002 /f
echo   NEIS / K-에듀파인 지원서비스 사이트를 신뢰할 수 있는 사이트로 등록합니다.
echo .

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\klef.go.kr\help" /v "*" /t REG_DWORD /d 00000002 /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\neis.go.kr\help" /v "*" /t REG_DWORD /d 00000002 /f
REM ============================================================================

REM ==== IE 기본설정 등록 ==========================================================
echo   Internet Explore 기본 설정을 등록합니다.(팝업차단해제, 호환성보기 설정 제거)
echo .
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Internet Explorer\Restrictions" /v NoHelpItemSendFeedback /t REG_DWORD /d 00000001 /f
REM ActiveX필터링 해제
REG DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_RESTRICT_ACTIVEXINSTALL" /f
REG DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Safety\ActiveXFiltering" /f
REM 팝업차단 해제
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows" /v PopupMgr /t REG_DWORD /d "0" /f
REM Windows Defender SmartScreen 필터 해제
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV9 /t REG_DWORD /d "0" /f
REM 호환성 보기 설정 초기화
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\BrowserEmulation\ClearableListData" /v "UserFilter" /f
REM TLS 모두 사용
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SecureProtocols" /t REG_DWORD /d 2688 /f
REM 종료할때 검색기록삭제 체크 해제
REM REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d 00000000 /f
REM 저장된 페이지의 새버전확인 -> 웹페이지를 열때마다
REM REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SyncMode5" /t REG_DWORD /d 00000003 /f
REM 사용할 디스크 공간 330MB로 설정

REM ============================================================================

REM ==== IE 보안 설정 초기화 =======================================================
echo   Internet Explorer 보안 설정 정보를 초기화합니다.

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

REM ==== 인터넷옵션 보안탭 설정 ======================================================
echo 인터넷옵션 중 보안탭 설정을 변경합니다.
REM 사용자 지정 수준 설정 등록
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "CurrentLevel" /t REG_DWORD /d 00000000 /f
REM Windows Defender SmartScreen 사용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2301" /t REG_DWORD /d 00000003 /f
REM 웹사이트에서 주소 또는 상태표시줄 없이 창을 열도록 허용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2104" /t REG_DWORD /d 00000000 /f
REM 크기 및 위치 제한 없이 스크립트 실행 창을 열 수 있습니다.
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2102" /t REG_DWORD /d 00000000 /f
REM 팝업 차단 사용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1609" /t REG_DWORD /d 00000000 /f
REM 혼합된 콘텐츠 표시
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1809" /t REG_DWORD /d 00000003 /f
REM XSS 필터 사용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1409" /t REG_DWORD /d 00000003 /f
REM 웹 사이트에서 스크립팅된 창을 사용하여 정보를 요청하도록 허용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2105" /t REG_DWORD /d 00000000 /f
REM 프로그램 클립보드 액세스 허용
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1407" /t REG_DWORD /d 00000000 /f
REM 보호모드 사용 안함
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "2500" /t REG_DWORD /d 00000003 /f
REM ============================================================================



REM ==== K-에듀파인 기안기 관련 ActiveX 강제설정 =======================================
echo 기안기 관련 ActiveX를 재등록합니다.
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

