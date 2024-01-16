I_Icon = C:\Users\eppsn\Documents\GitHub\various-scripts\autohotkey\keychron.ico
ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
if I_Icon <>
IfExist, %I_Icon%
	Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon 

; Case adjsuting script from the web.
; ctrl+capslock to show text case change menu 
; run script as admin (reload if not as admin) 

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
SetTitleMatchMode 2

GroupAdd All

Menu Case, Add, &UPPERCASE, CCase
Menu Case, Add, &lowercase, CCase
Menu Case, Add, &Title Case, CCase
Menu Case, Add, &Sentence case, CCase
Menu Case, Add
Menu Case, Add, &Fix Linebreaks, CCase
Menu Case, Add, &Reverse, CCase


^CapsLock::
GetText(TempText)
If NOT ERRORLEVEL
   Menu Case, Show
Return

CCase:
If (A_ThisMenuItemPos = 1)
   StringUpper, TempText, TempText
Else If (A_ThisMenuItemPos = 2)
   StringLower, TempText, TempText
Else If (A_ThisMenuItemPos = 3)
   StringLower, TempText, TempText, T
Else If (A_ThisMenuItemPos = 4)
{
   StringLower, TempText, TempText
   TempText := RegExReplace(TempText, "((?:^|[.!?]\s+)[a-z])", "$u1")
} ;Seperator, no 5
Else If (A_ThisMenuItemPos = 6)
{
   TempText := RegExReplace(TempText, "\R", "`r`n")
}
Else If (A_ThisMenuItemPos = 7)
{
   Temp2 =
   StringReplace, TempText, TempText, `r`n, % Chr(29), All
   Loop Parse, TempText
      Temp2 := A_LoopField . Temp2
   StringReplace, TempText, Temp2, % Chr(29), `r`n, All
}
PutText(TempText)
Return

; Handy function.
; Copies the selected text to a variable while preserving the clipboard.
GetText(ByRef MyText = "")
{
   SavedClip := ClipboardAll
   Clipboard =
   Send ^c
   ClipWait 0.5
   If ERRORLEVEL
   {
      Clipboard := SavedClip
      MyText =
      Return
   }
   MyText := Clipboard
   Clipboard := SavedClip
   Return MyText
}

; Pastes text from a variable while preserving the clipboard.
PutText(MyText)
{
   SavedClip := ClipboardAll 
   Clipboard =              ; For better compatability
   Sleep 20                 ; with Clipboard History
   Clipboard := MyText
   Send ^v
   Sleep 100
   Clipboard := SavedClip
   Return
}

; =========================================
;  __  __          _____ _          __  __ 
; |  \/  |        / ____| |        / _|/ _|
; | \  / |_   _  | (___ | |_ _   _| |_| |_ 
; | |\/| | | | |  \___ \| __| | | |  _|  _|
; | |  | | |_| |  ____) | |_| |_| | | | |  
; |_|  |_|\__, | |_____/ \__|\__,_|_| |_|  
;          __/ |                           
;         |___/                            
; =========================================
; Resources:
; https://www.autohotkey.com/docs/KeyList.htm
; https://cloudahk.com/editor/#
; =========================================
; Modifier keys:
; ctrl ^, use <^ and >^ for left/right ctrl
; alt !, <! >! for left/right alt. AltGr <^>!
; shift +, <+ >+ for left/right shift
; Lwin, <#
; =========================================
; Notes:
; shortcuts are intercepted from all programs. ie ctrl+p script does not make chrome go to print menu.
; a maximum of 2 modifier keys can be combined
; =========================================
;
; =========================================
; Right control + key = F13~F24 binds
;
; Use following to set macros in programs, otherwise they will pick up as modifer key + macros key
; Tooltip, Preparing to fire...
; Sleep, 1000
; Send, {command here}
; Tooltip, FIRE IN THE HOLE!
; Sleep, 1000
; Tooltip ;clear tooltip
; return
; =========================================
; Macros have all been replaced by my StreamDeck. This was one of them:
; >^ins:: ;Insert to F19
; Send, {F19}
; return
; =========================================
; Keychron C1 tweaks
; =========================================
; Remap Rightwin to context menu (right click)
RWin:: 
Send, {AppsKey}
return

; Remap left winkey+c "microphone key" to launch windows sound settings.
<#c::
Run, ms-settings:sound
return