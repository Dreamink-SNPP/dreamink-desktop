!include "MUI2.nsh"

; Application details
Name "Dreamink Desktop"
OutFile "../../dist/DreaminkSetup-${VERSION}-windows.exe"
InstallDir "$PROGRAMFILES64\Dreamink"
InstallDirRegKey HKLM "Software\Dreamink" "Install_Dir"

; Request admin privileges
RequestExecutionLevel admin

; UI settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\public\icon.ico"
!define MUI_UNICON "..\..\public\icon.ico"
!define MUI_WELCOMEPAGE_TITLE "Welcome to Dreamink Desktop Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Dreamink Desktop, an offline screenwriting structure organizer.$\r$\n$\r$\nClick Next to continue."

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\..\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; Installer sections
Section "Main Application" SecMain
    SetOutPath "$INSTDIR"

    ; Copy all files from distribution
    File /r "..\..\dist\dreamink-${VERSION}-windows\*.*"

    ; Create start menu shortcuts
    CreateDirectory "$SMPROGRAMS\Dreamink"
    CreateShortcut "$SMPROGRAMS\Dreamink\Dreamink.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\public\icon.ico" 0 SW_SHOWMINIMIZED
    CreateShortcut "$SMPROGRAMS\Dreamink\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

    ; Create desktop shortcut
    CreateShortcut "$DESKTOP\Dreamink.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\public\icon.ico" 0 SW_SHOWMINIMIZED

    ; Write uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; Registry entries for Add/Remove Programs
    WriteRegStr HKLM "Software\Dreamink" "Install_Dir" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "DisplayName" "Dreamink Desktop"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "Publisher" "Dreamink"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "DisplayIcon" "$INSTDIR\public\icon.ico"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink" "NoRepair" 1

    ; Success message
    MessageBox MB_OK "Dreamink Desktop has been successfully installed!$\r$\n$\r$\nYou can now launch it from the Start Menu or Desktop shortcut."
SectionEnd

; Uninstaller
Section "Uninstall"
    ; Remove shortcuts
    Delete "$SMPROGRAMS\Dreamink\*.*"
    RMDir "$SMPROGRAMS\Dreamink"
    Delete "$DESKTOP\Dreamink.lnk"

    ; Remove installation directory
    RMDir /r "$INSTDIR"

    ; Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dreamink"
    DeleteRegKey HKLM "Software\Dreamink"

    MessageBox MB_OK "Dreamink Desktop has been successfully removed from your computer."
SectionEnd
