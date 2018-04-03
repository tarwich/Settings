--- === WinWin ===
---
--- Windows manipulation
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "WinWin"
obj.version = "1.0"
obj.author = "ashfinal <ashfinal@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Windows manipulation history. Only the last operation is stored.
obj.history = {}

--- WinWin.gridparts
--- Variable
--- An integer specifying how many gridparts the screen should be divided into. Defaults to 30.
obj.gridparts = 30

--- WinWin:stepMove(direction)
--- Method
--- Move the focused window in the `direction` by on step. The step scale equals to the width/height of one gridpart.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`.
function obj:stepMove(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w/obj.gridparts
        local steph = cres.h/obj.gridparts
        local wtopleft = cwin:topLeft()
        if direction == "left" then
            cwin:setTopLeft({x=wtopleft.x-stepw, y=wtopleft.y})
        elseif direction == "right" then
            cwin:setTopLeft({x=wtopleft.x+stepw, y=wtopleft.y})
        elseif direction == "up" then
            cwin:setTopLeft({x=wtopleft.x, y=wtopleft.y-steph})
        elseif direction == "down" then
            cwin:setTopLeft({x=wtopleft.x, y=wtopleft.y+steph})
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:stepResize(direction)
--- Method
--- Resize the focused window in the `direction` by on step.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`.
function obj:stepResize(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w/obj.gridparts
        local steph = cres.h/obj.gridparts
        local wsize = cwin:size()
        if direction == "left" then
            cwin:setSize({w=wsize.w-stepw, h=wsize.h})
        elseif direction == "right" then
            cwin:setSize({w=wsize.w+stepw, h=wsize.h})
        elseif direction == "up" then
            cwin:setSize({w=wsize.w, h=wsize.h-steph})
        elseif direction == "down" then
            cwin:setSize({w=wsize.w, h=wsize.h+steph})
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:moveAndResize(option)
--- Method
--- Move and resize the focused window.
---
--- Parameters:
---  * option - A string specifying the option, valid strings are: `halfleft`, `halfright`, `halfup`, `halfdown`, `cornerNW`, `cornerSW`, `cornerNE`, `cornerSE`, `center`, `fullscreen`, `expand`, `shrink`.
local function windowStash(window)
    local winid = window:id()
    local winf = window:frame()
    if #obj.history > 50 then
        -- Make sure the history doesn't reach the maximum (50 items).
        table.remove(obj.history) -- Remove the last item
    end
    local winstru = {winid, winf}
    table.insert(obj.history, winstru) -- Insert new item of window history
end

function obj:moveAndResize(option, adjustSize)
    local cwin = hs.window.focusedWindow()
    local sizeAdjustment = 0.40

    if cwin then
        local cscreen = cwin:screen()
        local screenFrame = cscreen:fullFrame()
        local stepw = screenFrame.w/obj.gridparts
        local steph = screenFrame.h/obj.gridparts
        local windowFrame = cwin:frame()
    
        if option == "halfleft" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y, w=screenFrame.w/2, h=screenFrame.h})
        elseif option == "halfright" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x+screenFrame.w/2, y=screenFrame.y, w=screenFrame.w/2, h=screenFrame.h})
        elseif option == "halfup" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y, w=screenFrame.w, h=screenFrame.h/2})
        elseif option == "halfdown" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y+screenFrame.h/2, w=screenFrame.w, h=screenFrame.h/2})
        elseif option == "cornerNW" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y, w=screenFrame.w/2, h=screenFrame.h/2})
        elseif option == "cornerNE" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x+screenFrame.w/2, y=screenFrame.y, w=screenFrame.w/2, h=screenFrame.h/2})
        elseif option == "cornerSW" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y+screenFrame.h/2, w=screenFrame.w/2, h=screenFrame.h/2})
        elseif option == "cornerSE" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x+screenFrame.w/2, y=screenFrame.y+screenFrame.h/2, w=screenFrame.w/2, h=screenFrame.h/2})
        elseif option == "fullscreen" then
            windowStash(cwin)
            cwin:setFrame({x=screenFrame.x, y=screenFrame.y, w=screenFrame.w, h=screenFrame.h})
        elseif option == "center" then
            windowStash(cwin)
            if (adjustSize) then
                local newWidth = math.max(screenFrame.w * 0.45, 1250)
                local newHeight = screenFrame.h * 0.70

                cwin:setFrame({
                    x = screenFrame.x + (screenFrame.w / 2) - (newWidth / 2),
                    y = screenFrame.y + (screenFrame.h / 2) - (newHeight / 2),
                    w = newWidth,
                    h = newHeight,
                })
            else
                cwin:setFrame({
                    x = screenFrame.x + (screenFrame.w / 2) - (windowFrame.w / 2),
                    y = screenFrame.y + (screenFrame.h / 2) - (windowFrame.h / 2),
                    w = windowFrame.w,
                    h = windowFrame.h,
                })
            end
        elseif option == "expand" then
            cwin:setFrame({x=windowFrame.x-stepw, y=windowFrame.y-steph, w=windowFrame.w+(stepw*2), h=windowFrame.h+(steph*2)})
        elseif option == "shrink" then
            cwin:setFrame({x=windowFrame.x+stepw, y=windowFrame.y+steph, w=windowFrame.w-(stepw*2), h=windowFrame.h-(steph*2)})
        elseif option == "left" then
            cwin:setFrame({
                x = screenFrame.x,
                y = adjustSize and screenFrame.y or windowFrame.y,
                w = adjustSize and (screenFrame.w * sizeAdjustment) or windowFrame.w,
                h = adjustSize and (screenFrame.h) or windowFrame.h,
            })
        elseif option == "right" then
            cwin:setFrame({x=screenFrame.w-windowFrame.w, y=windowFrame.y, w=windowFrame.w, h=windowFrame.h})
        elseif option == "top" then
            cwin:setFrame({x=windowFrame.x, y=screenFrame.y, w=windowFrame.w, h=windowFrame.h})
        elseif option == "bottom" then
            cwin:setFrame({x=windowFrame.x, y=screenFrame.y + screenFrame.h - windowFrame.h, w=windowFrame.w, h=windowFrame.h})
        elseif option == "center" then
            cwin:setFrame({x=screenFrame.x + (screenFrame.w + windowFrame.w) / 2, y=screenFrame.y + (screenFrame.h + windowFrame.h) / 2, w=windowFrame.w, h=windowFrame.h})
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:moveToScreen(direction)
--- Method
--- Move the focused window between all of the screens in the `direction`.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`, `next`.
function obj:moveToScreen(direction, noResize)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        if direction == "up" then
            cwin:moveOneScreenNorth(noResize, true)
        elseif direction == "down" then
            cwin:moveOneScreenSouth(noResize, true)
        elseif direction == "left" then
            cwin:moveOneScreenWest(noResize, true)
        elseif direction == "right" then
            cwin:moveOneScreenEast(noResize, true)
        elseif direction == "next" then
            cwin:moveToScreen(cscreen:next(), noResize, true)
        else
            hs.alert.show("Invalid direction!")
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:undo()
--- Method
--- Undo the last window manipulation. Only those "moveAndResize" manipulations can be undone.
---
function obj:undo()
    local cwin = hs.window.focusedWindow()
    local cwinid = cwin:id()
    for idx,val in ipairs(obj.history) do
        -- Has this window been stored previously?
        if val[1] == cwinid then
            cwin:setFrame(val[2])
        end
    end
end

--- WinWin:centerCursor()
--- Method
--- Center the cursor on the focused window.
---
function obj:centerCursor()
    local cwin = hs.window.focusedWindow()
    local wf = cwin:frame()
    local cscreen = cwin:screen()
    local cres = cscreen:fullFrame()
    if cwin then
        -- Center the cursor one the focused window
        hs.mouse.setAbsolutePosition({x=wf.x+wf.w/2, y=wf.y+wf.h/2})
    else
        -- Center the cursor on the screen
        hs.mouse.setAbsolutePosition({x=cres.x+cres.w/2, y=cres.y+cres.h/2})
    end
end

return obj
