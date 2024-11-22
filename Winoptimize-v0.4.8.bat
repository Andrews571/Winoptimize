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

echo Verificando a versão do Windows...
for /f "tokens=4-5 delims=[.] " %%i in ('ver') do set ver=%%i.%%j

if "%ver%"=="10.0" (
    echo Windows 10 detectado.
    set os_version=10
) else (
    if "%ver%"=="10.1" (
        echo Windows 11 detectado.
        set os_version=11
    ) else (
        echo Versão do Windows não reconhecida.
        pause
        goto fim
    )
)


echo                                                        ==WINDOWS TWEAKS==

echo.
echo.
echo.



echo                                                        === CPU E GPU ===

echo.

echo CPU:
wmic cpu get name | findstr /v "Name"
echo.

echo GPU:
wmic path win32_videocontroller get name | findstr /v "Name"
echo.

echo.
echo                                            ================================
echo                                            === Digite a opcao desejada: ===
echo                                            ================================
echo.

echo [1] Desabilitar servicos do windows.
echo.
echo [2] Desfragmentar o disco.
echo.
echo [3] Otimizacoes basicas.
echo.
echo [4] Desinstalar bloatwares.  
echo.
echo [5] Otimizacoes avancadas.
echo.
echo [6] Corrigir partes corrompidas do sistema.
echo.
echo [7] Reiniciar.
echo.
echo [8] Finalizar e sair.
echo.
set /p opcao=Digite a opcao desejada:

if "%opcao%" == "1" goto op1
if "%opcao%" == "2" goto op2
if "%opcao%" == "3" goto op3
if "%opcao%" == "4" goto op4
if "%opcao%" == "5" goto op5
if "%opcao%" == "6" goto op6
if "%opcao%" == "7" goto op7
if "%opcao%" == "8" goto op8

goto in

:in
echo.
echo.
echo ===A OPCAO ESCOLHIDA NAO EXISTE, ESCOLHA ENTRE 1 - 7...===
echo ===A OPCAO ESCOLHIDA NAO EXISTE, ESCOLHA ENTRE 1 - 7...===
echo ===A OPCAO ESCOLHIDA NAO EXISTE, ESCOLHA ENTRE 1 - 7...===
echo.
pause
goto start

:op1
setlocal
:: Lista de serviços
set "services=vmvss wbengine wcncsvc webthreatdefsvc wercplsupport wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc wscsvc wuauserv svsvc swprv tiledatamodelsvc tzautoupdate uhssvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession lltdsvc lmhosts mpssvc msiserver netprofm nsi p2pimsvc p2psvc perceptionsimulation pla seclogon shpamsvc smphost spectrum sppsvc ssh-agent bthserv camsvccloudidsvc dcsvc diagnosticshub.standardcollector.service dmwappushservice dot3svc edgeupdate edgeupdatem embeddedmode fdPHost fhsvc gpsvc hidserv icssvc WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WinHttpAutoProxySvc inmgmt WpcMonSvc WpnServiceWwanSvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc autotimesvc TapiSrv TermService TextInputManagementService TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TroubleshootingSvc TrustedInstaller UevAgentService UmRdpService VGAuthService VMTools VSS VacSvc VaultSvc WEPHOSTSVC WMPNetworkSvc WManSvc WPDBusEnum WSService NgcCtnrSvc NgcSvc NlaSvc PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PolicyAgent Power PrintNotify PushToInstall QWAVE RasAuto RasMan RemoteAccess RetailDemo RmSvc SCardSvr SDRSVC SEMgrSvc SNMPTRAP SNMPTrap SecurityHealthService Sense SensorDataService SgrmBroker SharedAccess SharedRealitySvc SmsRouter Spooler SstpSvc StateRepository StiSvc StorSvc SysMain SystemEventsBroker TabletInputService DeviceAssociationService DeviceInstall DialogBlockingService DisplayEnhancementService DmEnrollmentSvc DoSvc DsSvc DsmSvc DusmSvc EFS EapHost EntAppSvc FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HvHost IEEtwCollectorService InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LSM LicenseManager LxpSvc MSDTC MSiSCSI MpsSvc NaturalAuthentication NcaSvc NcbService NcdAutoSetup NetSetupSvc Netlogon AJRouter ALG AppIDSvc AppXSvc Appinfo AssignedAccessManagerSvc AudioEndpointBuilder AudioSrv AxInstSV BDESVC BFE BTAGService Browser BthAvctpSvc BthHFSrv CDPSvc CertPropSvc ClipSVC CscService DPS DcpSvc DevQueryBroker"

for %%s in (%services%) do (
    sc config "%%s" start= demand
    sc stop "%%s"
)
:op1.1
echo      ====REINICIE O WINDOWS PARA APLICAR AS ALTERACOES E EVITAR QUAISQUER ERROS====
echo.
echo [1] REINICIAR AGORA (RECOMENDADO).
echo [2] VOLTAR AO INICIO.
 set /p opcao=Digite a opcao desejada:

if "%opcao%" == "1" goto r
if "%opcao%" == "2" goto start

goto in3

:in3
echo.
echo ===A OPCAO ESCOLHIDA NAO EXISTE, ESCOLHA ENTRE 1 - 2...===
pause
goto op1.1


:op2
echo Executando a otimização de disco no disco C:
defrag C: /U /V

goto fim

:op3
:: Desabilitar todos os efeitos visuais
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo Efeitos desabilitados
echo.
:: Criar um novo perfil de energia de desempenho

echo Criando perfil de energia de alto desempenho...

if "%os_version%"=="10" (
    powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a
) else (
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
)

:: Definir as configurações de suspensão de tela do novo perfil como "Nunca"
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Desabilitar o serviço SysMain para que não inicie automaticamente
sc config SysMain start=disabled

:: Define o valor da chave do registro para desativar o Superfetch
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f



:: echo Definindo o tamanho do arquivo de paginação para ?GB...

setlocal

rem Obtém o espaço livre no disco C: em gigabytes usando PowerShell
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "& { [math]::round((Get-PSDrive -Name C).Free / 1GB) }"') do set FreeSpaceGB=%%A

rem Verifica a quantidade de espaço livre e ajusta a memória virtual
if %FreeSpaceGB% LSS 4 (
    echo Espaço insuficiente, faça uma limpeza dos arquivos.
) else if %FreeSpaceGB% LEQ 16 (
    set PagingSize=2048 2048
    echo Definindo a memória virtual para 2GB...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys %PagingSize%" /f
    echo Memória virtual definida para 2GB com sucesso.
) else (
    set PagingSize=4096 4096
    echo Definindo a memória virtual para 4GB...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys %PagingSize%" /f
    echo Memória virtual definida para 4GB com sucesso.
)

endlocal


echo.
echo.
:: echo Reiniciando o sistema para aplicar as alterações...
:: shutdown /r /t 5 /f /d p:0:0 /c "Reiniciando para aplicar as alterações de memória virtual"


goto fim


:op4

echo Desinstalando aplicativos inuteis do sistema...

echo Desinstalando Calendário e Correio...
start /wait "" "powershell" "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"

echo Desinstalando Groove Música...
start /wait "" "powershell" "Get-AppxPackage *zunemusic* | Remove-AppxPackage"

if "%os_version%"=="10" (
    echo Desinstalando Mapas...
    start /wait "" "powershell" "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"

    echo Desinstalando Notícias...
    start /wait "" "powershell" "Get-AppxPackage *bingnews* | Remove-AppxPackage"
) else (
    echo Desinstalando Mapas...
    start /wait "" "powershell" "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage"

    echo Desinstalando Notícias...
    start /wait "" "powershell" "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage"
)

echo Desinstalando Tempo...
start /wait "" "powershell" "Get-AppxPackage *bingweather* | Remove-AppxPackage"

echo Desinstalando Xbox...
start /wait "" "powershell" "Get-AppxPackage *xboxapp* | Remove-AppxPackage"

echo Desinstalando 3D Viewer...
start /wait "" "powershell" "Get-AppxPackage *3dviewer* | Remove-AppxPackage"

echo Desinstalando Dicas...
start /wait "" "powershell" "Get-AppxPackage *windowsreader* | Remove-AppxPackage"

echo Desinstalando Filmes e TV...
start /wait "" "powershell" "Get-AppxPackage *zunevideo* | Remove-AppxPackage"

echo Desinstalando Hub de Comentários...
start /wait "" "powershell" "Get-AppxPackage *feedbackhub* | Remove-AppxPackage"

echo Desinstalando Portal de Realidade Mista...
start /wait "" "powershell" "Get-AppxPackage *mixedreality* | Remove-AppxPackage"

echo Desinstalando Notas Autoadesivas...
start /wait "" "powershell" "Get-AppxPackage *sticky* | Remove-AppxPackage"

echo Desinstalando Paint 3D...
start /wait "" "powershell" "Get-AppxPackage *mspaint* | Remove-AppxPackage"

echo Desinstalando Solitaire Collection...
start /wait "" "powershell" "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"

echo Desinstalacao concluída.
pause

:fim
goto fim

:op5

setlocal
:: Lista de serviços
set "services=vmvss wbengine wcncsvc webthreatdefsvc wercplsupport wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc wscsvc wuauserv svsvc swprv tiledatamodelsvc tzautoupdate uhssvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession lltdsvc lmhosts mpssvc msiserver netprofm nsi p2pimsvc p2psvc perceptionsimulation pla seclogon shpamsvc smphost spectrum sppsvc ssh-agent bthserv camsvccloudidsvc dcsvc diagnosticshub.standardcollector.service dmwappushservice dot3svc edgeupdate edgeupdatem embeddedmode fdPHost fhsvc gpsvc hidserv icssvc WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WinHttpAutoProxySvc inmgmt WpcMonSvc WpnServiceWwanSvc XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc autotimesvc TapiSrv TermService TextInputManagementService TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TroubleshootingSvc TrustedInstaller UevAgentService UmRdpService VGAuthService VMTools VSS VacSvc VaultSvc WEPHOSTSVC WMPNetworkSvc WManSvc WPDBusEnum WSService NgcCtnrSvc NgcSvc NlaSvc PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PolicyAgent Power PrintNotify PushToInstall QWAVE RasAuto RasMan RemoteAccess RetailDemo RmSvc SCardSvr SDRSVC SEMgrSvc SNMPTRAP SNMPTrap SecurityHealthService Sense SensorDataService SgrmBroker SharedAccess SharedRealitySvc SmsRouter Spooler SstpSvc StateRepository StiSvc StorSvc SysMain SystemEventsBroker TabletInputService DeviceAssociationService DeviceInstall DialogBlockingService DisplayEnhancementService DmEnrollmentSvc DoSvc DsSvc DsmSvc DusmSvc EFS EapHost EntAppSvc FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HvHost IEEtwCollectorService InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LSM LicenseManager LxpSvc MSDTC MSiSCSI MpsSvc NaturalAuthentication NcaSvc NcbService NcdAutoSetup NetSetupSvc Netlogon AJRouter ALG AppIDSvc AppXSvc Appinfo AssignedAccessManagerSvc AudioEndpointBuilder AudioSrv AxInstSV BDESVC BFE BTAGService Browser BthAvctpSvc BthHFSrv CDPSvc CertPropSvc ClipSVC CscService DPS DcpSvc DevQueryBroker"

for %%s in (%services%) do (
    sc config "%%s" start= demand
    sc stop "%%s"
)


:: Desabilitar todos os efeitos visuais
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
:: Criar um novo perfil de energia de desempenho

for /f "tokens=4-5 delims=[.] " %%i in ('ver') do set ver=%%i.%%j

if "%ver%"=="10.0" (
    echo Windows 10 detectado.
    set os_version=10
) else (
    if "%ver%"=="10.1" (
        echo Windows 11 detectado.
        set os_version=11
    ) else (
        echo Versão do Windows não reconhecida.
        pause
        goto fim
    )
)

echo Criando perfil de energia de alto desempenho...

if "%os_version%"=="10" (
    powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a
) else (
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
)

:: Definir as configurações de suspensão de tela do novo perfil como "Nunca"
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Desabilitar o serviço SysMain para que não inicie automaticamente
sc config SysMain start=disabled

:: Define o valor da chave do registro para desativar o Superfetch
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f

:: echo Definindo o tamanho do arquivo de paginação para ?GB...


setlocal

rem Obtém o espaço livre no disco C: em gigabytes usando PowerShell
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "& { [math]::round((Get-PSDrive -Name C).Free / 1GB) }"') do set FreeSpaceGB=%%A

rem Verifica a quantidade de espaço livre e ajusta a memória virtual
if %FreeSpaceGB% LSS 4 (
    echo Espaço insuficiente, faça uma limpeza dos arquivos.
) else if %FreeSpaceGB% LEQ 16 (
    set PagingSize=2048 2048
    echo Definindo a memória virtual para 2GB...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys %PagingSize%" /f
    echo Memória virtual definida para 2GB com sucesso.
) else (
    set PagingSize=4096 4096
    echo Definindo a memória virtual para 4GB...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys %PagingSize%" /f
    echo Memória virtual definida para 4GB com sucesso.
)

endlocal


echo.
echo.
:: echo Reiniciando o sistema para aplicar as alterações...
:: shutdown /r /t 5 /f /d p:0:0 /c "Reiniciando para aplicar as alterações de memória virtual"


echo Desinstalando aplicativos inuteis do sistema...

echo Desinstalando Calendário e Correio...
start /wait "" "powershell" "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"

echo Desinstalando Groove Música...
start /wait "" "powershell" "Get-AppxPackage *zunemusic* | Remove-AppxPackage"

if "%os_version%"=="10" (
    echo Desinstalando Mapas...
    start /wait "" "powershell" "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"

    echo Desinstalando Notícias...
    start /wait "" "powershell" "Get-AppxPackage *bingnews* | Remove-AppxPackage"
) else (
    echo Desinstalando Mapas...
    start /wait "" "powershell" "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage"

    echo Desinstalando Notícias...
    start /wait "" "powershell" "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage"
)

echo Desinstalando Tempo...
start /wait "" "powershell" "Get-AppxPackage *bingweather* | Remove-AppxPackage"

echo Desinstalando Xbox...
start /wait "" "powershell" "Get-AppxPackage *xboxapp* | Remove-AppxPackage"

echo Desinstalando 3D Viewer...
start /wait "" "powershell" "Get-AppxPackage *3dviewer* | Remove-AppxPackage"

echo Desinstalando Dicas...
start /wait "" "powershell" "Get-AppxPackage *windowsreader* | Remove-AppxPackage"

echo Desinstalando Filmes e TV...
start /wait "" "powershell" "Get-AppxPackage *zunevideo* | Remove-AppxPackage"

echo Desinstalando Hub de Comentários...
start /wait "" "powershell" "Get-AppxPackage *feedbackhub* | Remove-AppxPackage"

echo Desinstalando Portal de Realidade Mista...
start /wait "" "powershell" "Get-AppxPackage *mixedreality* | Remove-AppxPackage"

echo Desinstalando Notas Autoadesivas...
start /wait "" "powershell" "Get-AppxPackage *sticky* | Remove-AppxPackage"

echo Desinstalando Paint 3D...
start /wait "" "powershell" "Get-AppxPackage *mspaint* | Remove-AppxPackage"

echo Desinstalando Solitaire Collection...
start /wait "" "powershell" "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"

echo Desinstalacao concluída.
goto fim

:op6

echo.
echo.
echo VERIFICANDO E CORRIGINDO PARTES CORROMPIDAS DO SISTEMA... (Pode levar de 5 a 10 Minutos!)
sfc /scannow
echo.
echo =FINALIZADO=
echo.
echo [1] Reiniciar
echo [2] Voltar ao inicio
echo.
echo.
set /p opc=Digite a opcao desejada:

if "%opc%" == "1" goto r
if "%opc%" == "2" goto start
echo.
goto in2

:op7
echo.
echo [1] Reiniciar
echo [2] Voltar ao inicio
echo.
echo.
set /p opc=Digite a opcao desejada:

if "%opc%" == "1" goto r
if "%opc%" == "2" goto start
echo.
goto in2

:in2
echo.
echo ===A OPCAO ESCOLHIDA NAO EXISTE, ESCOLHA ENTRE 1 - 2...===
pause
goto op7

:op8
exit


:r
echo.
echo REINICIANDO...
shutdown /r /t 0

:v
goto start

:fim
echo.
echo.
echo.
echo                   ===Operacao realizada com sucesso!===
echo.
echo.
echo.
echo.
echo "Finalizado... FECHE TODAS AS JANELAS E REINICIE O COMPUTADOR"
echo.
echo.
pause
goto start