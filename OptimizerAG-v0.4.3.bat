@echo off
cls
:start
echo.

:: Verifica se o script está sendo executado com privilégios de administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" && (
    goto :runAsAdmin
) || (
    echo Solicitando privilégios de administrador...
    echo.
    :: Executa o script novamente com privilégios de administrador
    powershell Start-Process -FilePath "%0" -Verb RunAs
    exit /b
)

:runAsAdmin
echo Privilegios de administrador concedidos.
echo.

echo.

echo                                                   ==WINDOWS 10 TWEAKS==

echo.
echo.
echo.



echo                                             === Informacoes do Dispositivo ===

echo.

echo Modelo do Processador:
wmic cpu get name | findstr /v "Name"
echo.

echo Placa de Video:
wmic path win32_videocontroller get name | findstr /v "Name"
echo.

echo.
echo.

echo                                 Tweaks avancados == Digite o numero da opcao desejada:

echo.
echo.

echo [1] desabilitar servicos do windows
echo.
echo [2] desfragmentar o disco
echo.
echo [3] otimizacoes basicas
echo.
echo [4] otimizacoes avancadas (op1 + op3)
echo.
echo [5] desinstalar bloatwares(ainda nao funcionando)
echo.
echo [6] finalizar e sair
echo.
echo [7] reiniciar o pc
set /p opcao=Digite a opcao desejada:

if "%opcao%" == "1" goto op1
if "%opcao%" == "2" goto op2
if "%opcao%" == "3" goto op3
if "%opcao%" == "4" goto op4
if "%opcao%" == "5" goto nao
if "%opcao%" == "6" goto op6
if "%opcao%" == "7" goto op7

:op1
setlocal
:: Lista de serviços
set "services=vmvss wbengine wcncsvc webthreatdefsvc wercplsupport wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc wscsvc wuauserv wudfsvc svsvc swprv tiledatamodelsvc tzautoupdate uhssvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession vmicvsslfsvc iphlpsvc lfsvc lltdsvc lmhosts mpssvc msiserver netprofm nsi p2pimsvc p2psvc perceptionsimulation pla seclogon shpamsvc smphost spectrum sppsvc ssh-agent bthserv camsvccloudidsvc dcsvc diagnosticshub.standardcollector.service diagsvc dmwappushservice dot3svc edgeupdate edgeupdatem embeddedmode fdPHost fhsvc gpsvc hidserv icssvc WSearch WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WebClient Wecsvc WerSvc WiaRpc WinDefend WinHttpAutoProxySvc WinRM Winmgmt WlanSvc WpcMonSvc WpnServiceWwanSvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc autotimesvc TapiSrv TermService TextInputManagementService Themes TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TrkWks TroubleshootingSvc TrustedInstaller UI0Detect UevAgentService UmRdpService UserManager UsoSvc VGAuthService VMTools VSS VacSvc VaultSvc W32Time WEPHOSTSVC WFDSConMgrSvc WMPNetworkSvc WManSvc WPDBusEnum WSService Netman NgcCtnrSvc NgcSvc NlaSvc PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PlugPlay PolicyAgent Power PrintNotify ProfSvc PushToInstall QWAVE RasAuto RasMan RemoteAccess RemoteRegistry RetailDemo RmSvc RpcEptMapper RpcLocator RpcSs SCPolicySvc SCardSvr SDRSVC SEMgrSvc SENS SNMPTRAP SNMPTrap SSDPSRV SamSs ScDeviceEnum Schedule SecurityHealthService Sense SensorDataService SensorService SensrSvc SessionEnv SgrmBroker SharedAccess SharedRealitySvc ShellHWDetection SmsRouter Spooler SstpSvc StateRepository StiSvc StorSvc SysMain SystemEventsBroker TabletInputService DeviceAssociationService DeviceInstall Dhcp DialogBlockingService DispBrokerDesktopSvc DisplayEnhancementService DmEnrollmentSvc Dnscache DoSvc DsSvc DsmSvc DusmSvc EFS EapHost EntAppSvc EventLog EventSystem FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HvHost IEEtwCollectorService IKEEXT InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LSM LanmanServer LanmanWorkstation LicenseManager LxpSvc MSDTC MSiSCSI MpsSvc NaturalAuthentication NcaSvc NcbService NcdAutoSetup NetSetupSvc Netlogon AJRouter ALG AppIDSvc AppMgmt AppReadiness AppXSvc Appinfo AssignedAccessManagerSvc AudioEndpointBuilder AudioSrv Audiosrv AxInstSV BDESVC BFE BITS BTAGService BrokerInfrastructure Browser BthAvctpSvc BthHFSrv CDPSvc COMSysApp CertPropSvc ClipSVC CoreMessagingRegistrar CryptSvc CscService DPS DcomLaunch DcpSvc DevQueryBroker"

for %%s in (%services%) do (
    sc config "%%s" start= demand
    sc stop "%%s"
)

goto fim

:op2
echo Executando a otimização de disco no disco C:
defrag C: /U /V

goto fim

:op3
:: Desabilitar todos os efeitos visuais
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: Criar um novo perfil de energia de desempenho
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Definir as configurações de suspensão de tela do novo perfil como "Nunca"
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Parar o serviço SysMain
sc stop SysMain

:: Desabilitar o serviço SysMain para que não inicie automaticamente
sc config SysMain start=disabled

:: Define o valor da chave do registro para desativar o Superfetch
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f

:: echo Definindo o tamanho do arquivo de paginação para 3GB...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys 3072 3072" /f
echo.
echo Tamanho do arquivo de paginação definido para 3GB com sucesso.
echo.
:: echo Reiniciando o sistema para aplicar as alterações...
:: shutdown /r /t 5 /f /d p:0:0 /c "Reiniciando para aplicar as alterações de memória virtual"


goto fim


:op4

setlocal
:: Lista de serviços
set "services=vmvss wbengine wcncsvc webthreatdefsvc wercplsupport wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc wscsvc wuauserv wudfsvc svsvc swprv tiledatamodelsvc tzautoupdate uhssvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession vmicvsslfsvc iphlpsvc lfsvc lltdsvc lmhosts mpssvc msiserver netprofm nsi p2pimsvc p2psvc perceptionsimulation pla seclogon shpamsvc smphost spectrum sppsvc ssh-agent bthserv camsvccloudidsvc dcsvc diagnosticshub.standardcollector.service diagsvc dmwappushservice dot3svc edgeupdate edgeupdatem embeddedmode fdPHost fhsvc gpsvc hidserv icssvc WSearch WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WebClient Wecsvc WerSvc WiaRpc WinDefend WinHttpAutoProxySvc WinRM Winmgmt WlanSvc WpcMonSvc WpnServiceWwanSvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc autotimesvc TapiSrv TermService TextInputManagementService Themes TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TrkWks TroubleshootingSvc TrustedInstaller UI0Detect UevAgentService UmRdpService UserManager UsoSvc VGAuthService VMTools VSS VacSvc VaultSvc W32Time WEPHOSTSVC WFDSConMgrSvc WMPNetworkSvc WManSvc WPDBusEnum WSService Netman NgcCtnrSvc NgcSvc NlaSvc PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PlugPlay PolicyAgent Power PrintNotify ProfSvc PushToInstall QWAVE RasAuto RasMan RemoteAccess RemoteRegistry RetailDemo RmSvc RpcEptMapper RpcLocator RpcSs SCPolicySvc SCardSvr SDRSVC SEMgrSvc SENS SNMPTRAP SNMPTrap SSDPSRV SamSs ScDeviceEnum Schedule SecurityHealthService Sense SensorDataService SensorService SensrSvc SessionEnv SgrmBroker SharedAccess SharedRealitySvc ShellHWDetection SmsRouter Spooler SstpSvc StateRepository StiSvc StorSvc SysMain SystemEventsBroker TabletInputService DeviceAssociationService DeviceInstall Dhcp DialogBlockingService DispBrokerDesktopSvc DisplayEnhancementService DmEnrollmentSvc Dnscache DoSvc DsSvc DsmSvc DusmSvc EFS EapHost EntAppSvc EventLog EventSystem FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HvHost IEEtwCollectorService IKEEXT InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LSM LanmanServer LanmanWorkstation LicenseManager LxpSvc MSDTC MSiSCSI MpsSvc NaturalAuthentication NcaSvc NcbService NcdAutoSetup NetSetupSvc Netlogon AJRouter ALG AppIDSvc AppMgmt AppReadiness AppXSvc Appinfo AssignedAccessManagerSvc AudioEndpointBuilder AudioSrv Audiosrv AxInstSV BDESVC BFE BITS BTAGService BrokerInfrastructure Browser BthAvctpSvc BthHFSrv CDPSvc COMSysApp CertPropSvc ClipSVC CoreMessagingRegistrar CryptSvc CscService DPS DcomLaunch DcpSvc DevQueryBroker"

for %%s in (%services%) do (
    sc config "%%s" start= demand
    sc stop "%%s"
)


:: Desabilitar todos os efeitos visuais
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: Criar um novo perfil de energia de desempenho
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Definir as configurações de suspensão de tela do novo perfil como "Nunca"
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Parar o serviço SysMain
sc stop SysMain

:: Desabilitar o serviço SysMain para que não inicie automaticamente
sc config SysMain start=disabled

:: Define o valor da chave do registro para desativar o Superfetch
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f

:: echo Definindo o tamanho do arquivo de paginação para 3GB...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys 3072 3072" /f
echo.
:: echo Tamanho do arquivo de paginação definido para 3GB com sucesso.
echo.
:: echo Reiniciando o sistema para aplicar as alterações...
:: shutdown /r /t 5 /f /d p:0:0 /c "Reiniciando para aplicar as alterações de memória virtual"


goto fim

:op5
echo Desinstalando aplicativos...

rem Aplicativos a serem desinstalados
set "aplicativos=3DViewer Calendário Contatos Correio e Calendário Dicas FilmesTV Groove Música Mapas Microsoft.Noticias Microsoft.SolitaireCollection MixedRealityPortal OneNote Paint3D Pessoas Vídeo Xbox"

rem Loop pelos aplicativos e tenta desinstalar cada um
for %%a in (%aplicativos%) do (
    echo Desinstalando %%a...
    powershell.exe -Command "Get-AppxPackage -Name '*%%a*' | Remove-AppxPackage -AllUsers"
    echo.
)

goto fim


:op6
exit

:op7
echo.
echo [r] Reiniciar
echo [v] voltar ao inicio
echo.
echo.
set /p opc=Digite a opcao desejada:

if "%opc%" == "r" goto r
if "%opc%" == "v" goto v
echo.
:r
echo.
echo Reiniciando o computador...
shutdown /r /t 0

:v
goto start

:fim
echo.
echo.
echo.
echo Operação realizada com sucesso!
echo.
echo.
echo.
echo.
echo "Finalizado... FECHE TODAS AS JANELAS E REINICIE O COMPUTADOR"
echo.
echo.
pause
goto start




:nao
echo.
echo.
echo Ainda nao funcionando, Em breve...
echo.
echo.
pause
goto start