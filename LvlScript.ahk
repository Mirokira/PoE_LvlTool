#Include, %A_ScriptDir%\lib\EasyIni.ahk

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance Force

config = %A_ScriptDir%\config.ini

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%"

config = %A_ScriptDir%\config.ini


;FileRead, Config, Config.ini
IniRead, Guide, %config%, "General", "Guide"

FileRead, Steps, *t %Guide%

;Var Initiation
CurrentStep = Errors
NextStep = Errors
PHStep1 = Errors
PHStep2 = Errors
PHStep3 = Errors

Act = 1
LastStep = 1
ShowBool = true
FBool = false
ForwardBool = true

;---------------------------------------------------------

;Load LastStep
IniRead, LastStep, %config%, "General", "LastStep"
IniRead, Act, %config%, "General", "Act"

IniRead, Forwards, %config%, "Hotkeys", "Forwards"
IniRead, Backwards, %config%, "Hotkeys", "Backwards"
IniRead, ShowHide, %config%, "Hotkeys", "ShowHide"
IniRead, CloseP, %config%, "Hotkeys", "Close"
IniRead, Save, %config%, "Hotkeys", "SaveProgress"
IniRead, ResetP, %config%, "Hotkeys", "ResetProgress"


Hotkey %Forwards%, Forwards
Hotkey %Backwards%, Backwards
Hotkey %ShowHide%, ShowHide
Hotkey %CloseP%, CloseP
Hotkey %Save%, Save
Hotkey %ResetP%, ResetP

/*
;Load Act
FileReadLine, ActPH, config.ini, 3
StringTrimLeft, Act, ActPH, 6
*/
;Set Text first time
gosub, GetStepsText

;Gui show
gosub UpdateText
;-----------------------------------------------------------
;Hotkeys
Forwards: ;Step forward
LastStep++
ForwardBool := true
gosub, GetStepsText
gosub, UpdateText
return

Backwards: ;Step backwards
If(LastStep == 1)
	return
LastStep--
ForwardBool := false
gosub, GetStepsText
gosub, UpdateText
return


Save: ;Save Progress
gosub, SaveProgress
return


ShowHide: ;Show/Hide Gui
if(ShowBool == false){
	gosub, UpdateText
	}else{
	gosub, HideGUI
}
ShowBool := !ShowBool
return


CloseP:
gosub, SaveProgress
ExitApp


ResetP:
LastStep := 1
Act := 1
gosub, GetStepsText
gosub, UpdateText
return

;----------------------------------------------------------------
;SubRoutines
GetStepsText:
Loop, parse, Steps, `n 
{
	if (LastStep >= A_Index){
	CurrentStep := A_LoopField
	}else{break
	}	
}
Loop, parse, Steps, `n
{
	if (LastStep + 1 >= A_Index){
		NextStep := A_LoopField
	}else{break
	}
}
return

UpdateText:

;get Code from CurrentStep and NextStep
StrSC := SubStr(CurrentStep, 2, 3)
StrSN := SubStr(NextStep, 1, 1)

;remove code from NextStep
if (StrSN == "-")
{
	StringTrimLeft, NextStep, NextStep, 5
}

;Code Sheet:
;001 Act up
;002 Double anzeige (3 rows)
;003 tripple anzeige (4 rows) incl. Pictures/ThreeWayFork.png
;010 Picture Pictures/RuinedSquare.png
;012 Picture Pictures/LunarisCart.png
;015 Picture Pictures/LongBridge.jpg

;Decide what to do if code is existent
if ( StrSC == 001)
{
	StringTrimLeft, CurrentStep, CurrentStep, 5
	
	If(Forwardbool){
	Act++
	}
	else{
	Act-- 
	}
	
	gosub, UpdateTextNormal
}
else if (StrSC == 002)
{
	;if we come back, we need to set LastStep to the first shown
	if (!Forwardbool)
	{
		LastStep := LastStep - 2
	}
	
	;Get all Strings again
	Loop, parse, Steps, `n
	{
		if (LastStep >= A_Index){
			CurrentStep := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 1 >= A_Index){
			PHStep1 := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 2 >= A_Index){
			PHStep2 := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 3 >= A_Index){
			NextStep := A_LoopField
		}else{break
		}
	}
	
	if(Forwardbool){
	LastStep := LastStep + 2
	}
	
	StringTrimLeft, CurrentStep, CurrentStep, 5
	StringTrimLeft, PHStep1, PHStep1, 5
	StringTrimLeft, PHStep2, PHStep2, 5
	
	StrSN := SubStr(NextStep, 1, 1)
	if (StrSN == "-")
	{
		StringTrimLeft, NextStep, NextStep, 5
	}
	
	Gui, 33:Destroy ;Destroy old gui so it sizes it correctly, gui,move did not work
	;formatting
	Gui, 33:New, +AlwaysOnTop -SysMenu -Caption +Owner
	Gui, 33:Font, s10 w600 q5, Arial
	;Add texts
	Gui, 33:Add, Text, vAct w800 c008000 Left, Act %Act%
	Gui, 33:Add, Text, vCS xp y+10 wp cFFFF00 Left, Current Step: `n%CurrentStep% `n-%PHStep1%`n-%PHStep2% ; adjust y+n if needed
	Gui, 33:Add, Text, vNS Xp y+10 wp cFF0000 Left, Next Step: `n%NextStep% ;%NextStep%
	;make transparent
	Gui, 33: Color, 000000 ;Background Color
	Gui, 33: +LastFound ;set active gui for line below
	WinSet, TransColor, 000000
	;Show
	Gui, 33:Show, X40 Y170 NoActivate, Act

}
else if (StrSC == 003)
{
	
	if (!Forwardbool)
	{
		LastStep := LastStep - 3
	}
	;Get all Strings again
	Loop, parse, Steps, `n
	{
		if (LastStep >= A_Index){
			CurrentStep := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 1 >= A_Index){
			PHStep1 := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 2 >= A_Index){
			PHStep2 := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 3 >= A_Index){
			PHStep3 := A_LoopField
		}else{break
		}
	}
	Loop, parse, Steps, `n
	{
		if (LastStep + 4 >= A_Index){
			NextStep := A_LoopField
		}else{break
		}
	}
	
	if(Forwardbool){
	LastStep := LastStep + 3
	}
	
	StringTrimLeft, CurrentStep, CurrentStep, 5
	StringTrimLeft, PHStep1, PHStep1, 5
	StringTrimLeft, PHStep2, PHStep2, 5
	StringTrimLeft, PHStep3, PHStep3, 5
	
	StrSN := SubStr(NextStep, 1, 1)
	if (StrSN == "-")
	{
		StringTrimLeft, NextStep, NextStep, 5
	}
	
	Gui, 33:Destroy ;Destroy old gui so it sizes it correctly, gui,move did not work
	;formatting
	Gui, 33:New, +AlwaysOnTop -SysMenu -Caption +Owner
	Gui, 33:Font, s10 w600 q5, Arial
	;Add texts
	Gui, 33:Add, Text, vAct w800 c008000 Left, Act %Act%
	Gui, 33:Add, Text, vCS xp y+10 wp cFFFF00 Left, Current Step: `n%CurrentStep% `n-%PHStep1%`n-%PHStep2%`n-%PHStep3% ; adjust y+n if needed
	Gui, 33:Add, Text, vNS Xp y+10 wp cFF0000 Left, Next Step: `n%NextStep% ;%NextStep%
	Gui, 33:Add, Picture, , Pictures/ThreeWayFork.png
	;make transparent
	Gui, 33: Color, 000000 ;Background Color
	Gui, 33: +LastFound ;set active gui for line below
	WinSet, TransColor, 000000
	;Show
	Gui, 33:Show, X40 Y170 NoActivate, Act
	
	
}
else if ( StrSC == 010 or StrSC == 012 or StrSC == 015)
{
	StringTrimLeft, CurrentStep, CurrentStep, 5
	
	Gui, 33:Destroy ;Destroy old gui so it sizes it correctly, gui,move did not work
	;formatting
	Gui, 33:New, +AlwaysOnTop -SysMenu -Caption +Owner
	Gui, 33:Font, s10 w600 q5, Arial
	;Add texts
	Gui, 33:Add, Text, vAct w800 c008000 Left, Act %Act%
	Gui, 33:Add, Text, vCS xp y+10 wp cFFFF00 Left, Current Step: `n%CurrentStep% ; adjust y+n if needed
	Gui, 33:Add, Text, vNS Xp y+10 wp cFF0000 Left, Next Step: `n%NextStep% ;%NextStep%
	
	if (StrSC == 010)
	{
		Gui, 33:Add, Picture, , Pictures/RuinedSquare.png
	}
	if (StrSC == 012)
	{
		Gui, 33:Add, Picture, , Pictures/LunarisCart.png
	}
	if (StrSC == 015)
	{
		Gui, 33:Add, Picture, , Pictures/LongBridge.jpg
	}
	
	;make transparent
	Gui, 33: Color, 000000 ;Background Color
	Gui, 33: +LastFound ;set active gui for line below
	WinSet, TransColor, 000000
	;Show
	Gui, 33:Show, X40 Y170 NoActivate, Act
}
else
{
	gosub, UpdateTextNormal
}

return


UpdateTextNormal:
Gui, 33:Destroy ;Destroy old gui so it sizes it correctly, gui,move did not work
;formatting
Gui, 33:New, +AlwaysOnTop -SysMenu -Caption +Owner
Gui, 33:Font, s10 w600 q5, Arial
;Add texts
Gui, 33:Add, Text, vAct w800 c008000 Left, Act %Act%
Gui, 33:Add, Text, vCS xp y+10 wp cFFFF00 Left, Current Step: `n%CurrentStep% ; adjust y+n if needed
Gui, 33:Add, Text, vNS Xp y+10 wp cFF0000 Left, Next Step: `n%NextStep% ;%NextStep%
;make transparent
Gui, 33: Color, 000000 ;Background Color
Gui, 33: +LastFound ;set active gui for line below
WinSet, TransColor, 000000
;Show
Gui, 33:Show, X40 Y170 NoActivate, Act
return

SaveProgress:
IniWrite %LastStep%, %config%, "General", "LastStep"
IniWrite %Act%, %config%, "General", "Act"


return

HideGUI:
Gui, 33:Hide
return