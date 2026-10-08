#define AppName "Guen's Travel 7 Tours"
#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

[Setup]
AppId={{7B1C2E4A-5D3F-4A8B-9C11-6E7F0A2D9B35}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=Guen's Travel
DefaultDirName={autopf}\GuensTravel7Tours
DefaultGroupName={#AppName}
OutputDir=..\..\build
OutputBaseFilename=Guens-Travel-7-Tours-Setup
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\guenstravel7tours.exe
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "Créer un raccourci sur le bureau"

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\guenstravel7tours.exe"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\guenstravel7tours.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\guenstravel7tours.exe"; Description: "Lancer {#AppName}"; Flags: nowait postinstall skipifsilent
