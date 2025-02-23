#Persistent
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2

; Ensure script runs as administrator
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"  ; Restart script as Admin
    ExitApp
}

; Define folder paths
folders := {"#+y": "YouTube"
         , "#+c": "Coursera"
         , "#+p": "PhysicsWallah"
         , "#+b": "Books"}

; Register hotkeys
for hotkey, subfolder in folders
    Hotkey, %hotkey%, SaveScreenshot

return

SaveScreenshot:
    folder := folders[A_ThisHotkey]
    basePath := "C:\Users\shubh\Pictures\Screenshots\" . folder . "\"

    ; Ensure directory exists
    if !InStr(FileExist(basePath), "D")
        FileCreateDir, %basePath%

    ; Capture active window title
    WinGetTitle, activeTitle, A

    ; Extract video title for YouTube or Coursera
    if (InStr(activeTitle, "- YouTube"))
    {
        extractedText := RegExReplace(activeTitle, " - YouTube", "")  ; Remove "- YouTube"
    }
    else if (InStr(activeTitle, "- Coursera"))
    {
        extractedText := RegExReplace(activeTitle, " - Coursera", "")  ; Remove "- Coursera"
    }
    else
    {
        extractedText := "Screenshot_" . A_Now  ; Default filename if not YouTube or Coursera
    }

    ; Clean filename
    extractedText := RegExReplace(extractedText, "[^\w\s-]", "")
    extractedText := StrReplace(extractedText, " ", "_")

    ; Truncate if too long
    if (StrLen(extractedText) > 150)
        extractedText := SubStr(extractedText, 1, 150)

    ; Define final save path
    finalFile := basePath . extractedText . ".png"

    ; Ensure filename is unique
    index := 1
    while FileExist(finalFile) {
        finalFile := basePath . extractedText . "_" . index . ".png"
        index++
    }

    ; Take screenshot using PrintScreen
    Send, {PrintScreen}

    ; Save the screenshot
    Sleep, 1000  ; Wait for the screenshot to be copied
    Run, mspaint.exe
    WinWaitActive, ahk_exe mspaint.exe
    Sleep, 700
    Send, ^v  ; Paste image
    Sleep, 500
    Send, ^s  ; Save
    Sleep, 500
    SendInput, %finalFile%
    Sleep, 500
    Send, {Enter}
    Sleep, 500
    Send, !{F4}  ; Close Paint

    MsgBox, Screenshot saved: %finalFile%
return
