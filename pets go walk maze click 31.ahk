#Requires AutoHotkey v2.0
SetWorkingDir A_ScriptDir
CoordMode("Mouse", "Window")
CoordMode("Pixel", "Window")
SetTitleMatchMode(2)
SetControlDelay(1)
SetWinDelay(0)
SetKeyDelay(-1)
SetMouseDelay(-1)

; ====== MODIFIABLE PARAMETERS ======
global clickAreaX1 := 280, clickAreaY1 := 170      ; Top-left of clickable area
global clickAreaX2 := 780, clickAreaY2 := 500      ; Bottom-right coordinate
global tooltipX := 10, tooltipY := 10              ; Tooltip coordinates
global keyDownTime := 800                          ; Key down duration for walking
global shortDelay := 500                           ; Delay 
global mediumDelay := 1000                         ; Delay between actions
global longDelay := 5000                           ; Delay between action loops
; ====== END MODIFIABLE PARAMETERS ======

global isClicking := false                         ; Track if clicking is active
global startClicking := false                      ; Activate clicking on second F7 press
global idList                                      ; List of Roblox windows

F7:: {
    global isClicking, startClicking, idList

    ShowClickArea()

    if !isClicking {
        isClicking := true
        startClicking := false
        idList := WinGetList("ahk_exe RobloxPlayerBeta.exe")
        if (idList.Length < 2) {
            ShowTooltip("Error: Not enough windows found.")
            return
        }

        ShowTooltip("Click area displayed. Press F7 again to start.")
    } else if !startClicking {
        startClicking := true
        HideClickArea()
        ShowTooltip("Starting actions")
        Sleep(mediumDelay)
        PerformActions()
    }
}

PerformActions() {
    global isClicking, startClicking, idList
    counter := 1
    while isClicking {
        for id in idList {
            WinActivate("ahk_id " id)
            Sleep(shortDelay)
            activeWindow := WinActive("ahk_id " id)
            if (!activeWindow) {
                ShowTooltip("Error: Window not activated. Skipping.")
                continue
            } else {
                ShowTooltip("Found window: " counter)
                counter++
                Sleep(mediumDelay)
            }

            if (idList[1] == id) {
                ShowTooltip("Performing clicks in main window")
                RandomClickLoop(600000)
                ComplexPath()
            } else {
                ShowTooltip("Performing background actions")
                BackgroundAccounts()
            }
        }
        if (idList.Length > 1) {
            ShowTooltip("Returning to main window")
            WinActivate("ahk_id " idList[1])
            Sleep(shortDelay)
        }
        Sleep(10000)
    }
    ToolTip("")
}

; Walking movement
ComplexPath() {
    ShowTooltip("Walking")

    Move("w", keyDownTime)
    Sleep(shortDelay)

    Move("d", keyDownTime)
    Sleep(shortDelay)

    Move("s", keyDownTime)
    Sleep(shortDelay)

    Move("a", keyDownTime)
    Sleep(shortDelay)

    Move("s", keyDownTime)
    Sleep(shortDelay)

    Move("w", keyDownTime)
    Sleep(shortDelay)

    Move("d", keyDownTime)
    Sleep(shortDelay)

    Move("a", keyDownTime)
    Sleep(shortDelay)

    Move("s", keyDownTime)
    Sleep(shortDelay)

    Move("w", keyDownTime)
    Sleep(shortDelay)

    Move("d", keyDownTime)
    Sleep(shortDelay)

    Move("a", keyDownTime)
    Sleep(shortDelay)

    Move("s", keyDownTime)
    Sleep(shortDelay)

    Move("w", keyDownTime)
    Sleep(shortDelay)

    Move("a", keyDownTime)
    Sleep(shortDelay)

    Move("d", keyDownTime)
    Sleep(shortDelay)
}

Move(direction, duration) {
    Send("{" direction " Down}")
    Sleep(duration)
    Send("{" direction " Up}")
}

RandomClick() {
    randX := Random(clickAreaX1, clickAreaX2)
    randY := Random(clickAreaY1, clickAreaY2)
    Click randX, randY
}

RandomClickLoop(duration) {
    endTime := A_TickCount + duration
    while (A_TickCount < endTime) {
        ShowTooltip("Clicking")
        RandomClick()
        Sleep(shortDelay)
    }
}

BackgroundAccounts() {
    WinGetPos(&X, &Y, &W, &H, "A")
    ClickX := X + 345
    ClickY := Y + 825

    ClickUltimate(50, ClickX, ClickY)
    ShowTooltip("Party Box")
    Send("{b Down}{b Up}")
    Sleep(shortDelay)

    ClickUltimate(20, ClickX, ClickY)
    OpenGift(10)
    Sleep(shortDelay)

    ClickUltimate(10, ClickX, ClickY)
    ShowTooltip("Flag")
    Send("{l Down}{l Up}")
    Sleep(shortDelay)

    ClickUltimate(15, ClickX, ClickY)
    ShowTooltip("Sprinkler")
    Send("{k Down}{k Up}")
    Sleep(shortDelay)

    ClickUltimate(30, ClickX, ClickY)
    Sleep(mediumDelay)
}

ShowClickArea() {
    width := clickAreaX2 - clickAreaX1
    height := clickAreaY2 - clickAreaY1
    global box := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    box.Color := "FF0000"
    box.Show("x" clickAreaX1 " y" clickAreaY1 " w" width " h" height " NoActivate")
    WinSetTransparent(50, box.Hwnd)
}

HideClickArea() {
    box.Destroy()
}

ClickUltimate(clickCount, ClickX, ClickY, sleepTime := 50) {
    ShowTooltip("Ultimate")
    Loop clickCount {
        Click ClickX, ClickY
        Sleep(sleepTime)
    }
}

OpenGift(giftCount, sleepTime := 50) {
    ShowTooltip("Gift")
    Loop giftCount {
        Send("{g Down}{g Up}")
        Sleep(sleepTime)
    }
}

ShowTooltip(text) {
    ToolTip(text, tooltipX, tooltipY)
    Sleep(mediumDelay)
    ToolTip("")
}

F8::ExitApp
