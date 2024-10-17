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
; Area to click
global clickAreaX1 := 170, clickAreaY1 := 56  ; Top-left coordinate
global clickAreaX2 := 915, clickAreaY2 := 475 ; Bottom-right coordinate

Keydown := 800    ; Set the key down delay time here
Waitdelay := 1000   ; Set the wait delay time here
Loopdelay := 5000  ; Set the loop delay time here
; ====== END MODIFIABLE PARAMETERS ======

isClicking := false  ; Initialize isClicking
isPaused := false    ; Initialize pause state
global box  ; Define the GUI globally for reference

F7::
{
    isClicking := true
    ShowTooltip("Starting")  ; Show tooltip at the top left
    ShowClickArea()  ; Display the clickable area

    while isClicking
    {
        ; Check if paused
        if (isPaused) {
            ShowTooltip("Paused. Press F6 to resume, F8 to stop.")
            while isPaused {
                Sleep(100)  ; Wait until unpaused
            }
            ShowTooltip("Resuming")
            Sleep(1000)  ; Give time to show resume tooltip
        }

        idList := WinGetList("ahk_exe RobloxPlayerBeta.exe")
        for id in idList
        {
            ; Activate the Roblox window
            WinActivate("ahk_id " id)
            Sleep(500)

            activeWindow := WinActive("ahk_id " id)
            if (!activeWindow)
            {
                Tooltip("Error: Window not activated")
                Sleep(2000)
                continue
            }
            else
            {
                ShowTooltip("Found window")
                Sleep(1000)
            }

            ; Random click for 1 minute
            RandomClickLoop(60000)  ; 1 minute in milliseconds
            
            ; Perform complex path for one cycle
            ComplexPath()  
        }
        
        Sleep(Loopdelay)  ; Use loop delay for the next iteration
    }
    ToolTip("")  ; Remove tooltip when loop ends
    HideClickArea()  ; Hide the clickable area when stopping
}

; Walking movement
ComplexPath() {
    ShowTooltip("Walking")

    Move("w", Keydown)          ; Move Up - W1
    Sleep(Waitdelay)

    Move("d", Keydown)          ; Move Right - D1
    Sleep(Waitdelay)

    Move("s", Keydown)          ; Move Down - S1
    Sleep(Waitdelay)

    Move("a", Keydown)          ; Move Left - A1
    Sleep(Waitdelay)

    Move("s", Keydown)          ; Move Down - S2
    Sleep(Waitdelay)

    Move("w", Keydown)          ; Move Up - W2
    Sleep(Waitdelay)

    Move("d", Keydown)          ; Move Right - D2
    Sleep(Waitdelay)

    Move("a", Keydown)          ; Move Left - A2
    Sleep(Waitdelay)

    Move("s", Keydown)          ; Move Down - S3
    Sleep(Waitdelay)

    Move("w", Keydown)          ; Move Up - W3
    Sleep(Waitdelay)

    Move("d", Keydown)          ; Move Right - D3
    Sleep(Waitdelay)

    Move("a", Keydown)          ; Move Left - A3
    Sleep(Waitdelay)

    Move("s", Keydown)          ; Move Down - S4
    Sleep(Waitdelay)

    Move("w", Keydown)          ; Move Up - W4
    Sleep(Waitdelay)

    Move("a", Keydown)          ; Move Left - A4
    Sleep(Waitdelay)

    Move("d", Keydown)          ; Move Right - D4
    Sleep(Waitdelay)
}

Move(direction, duration) {
    Send("{" direction " Down}")
    Sleep(duration)
    Send("{" direction " Up}")
}

; Random click within defined area
RandomClick() {
    randX := Random(clickAreaX1, clickAreaX2)
    randY := Random(clickAreaY1, clickAreaY2)
    SendEvent("{Click," randX "," randY ", 2}")
}

; Perform random clicks for the specified duration
RandomClickLoop(duration) {
    endTime := A_TickCount + duration
    while (A_TickCount < endTime)
    {
        ShowTooltip("Clicking")
        RandomClick()  ; Perform a random click
        Sleep(100)     ; Optional delay between clicks (adjust as necessary)
    }
}

ShowTooltip(text) {
    ToolTip(text, 14, 64)  ; Position the tooltip top left in the window
}

; Show the clickable area with a GUI
ShowClickArea() {
    width := clickAreaX2 - clickAreaX1
    height := clickAreaY2 - clickAreaY1
    
    ; Create and show the GUI
    global box := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    box.Color := "FF0000"  ; Red color
    box.Show("x" clickAreaX1 " y" clickAreaY1 " w" width " h" height " NoActivate")
    
    ; Set transparency to 50%
    WinSetTransparent(50, box.Hwnd)
}

; Hide the clickable area
HideClickArea() {
    box.Destroy()  ; Destroy the GUI
}

; ====== Pause/Resume on F6 ======
F6::
{
    global isPaused  ; Declare isPaused as global in the F6 hotkey
    isPaused := !isPaused  ; Toggle the paused state
    if (isPaused) {
        ShowTooltip("Pausing")
        Sleep(1000)
    } else {
        ShowTooltip("Resuming")
        Sleep(1000)
    }
}

; ====== F8 to Stop ======
F8::ExitApp  ; Close the script
