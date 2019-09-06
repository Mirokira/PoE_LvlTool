#Include, %A_ScriptDir%\lib\EasyIni.ahk
config = %A_ScriptDir%\TestConfig.ini
IniWrite, "1", %config%, "General", "LastStep"
IniWrite, "1", %config%, "General", "Act"


IniWrite, "1", %config%, "Hotkeys", "Forwards"
IniWrite, "1", %config%, "Hotkeys", "Backwards"
IniWrite, "1", %config%, "Hotkeys", "SaveProgress"
IniWrite, "1", %config%, "Hotkeys", "Close"

IniRead, Test, %config%, "General", "LastStep"

msgbox %test%