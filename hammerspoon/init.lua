
-- HCalendar
hs.loadSpoon('HCalendar')

-- WinWin
hs.loadSpoon('WinWin')
hs.hotkey.bind({'cmd', 'alt'}, 'left', function() spoon.WinWin:moveAndResize('left') end)
hs.hotkey.bind({'cmd', 'alt'}, 'right', function() spoon.WinWin:moveAndResize('right') end)
hs.hotkey.bind({'cmd', 'alt'}, 'up', function() spoon.WinWin:moveAndResize('top') end)
hs.hotkey.bind({'cmd', 'alt'}, 'down', function() spoon.WinWin:moveAndResize('bottom') end)
hs.hotkey.bind({'cmd', 'alt'}, 'c', function() spoon.WinWin:moveAndResize('center') end)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'left', function() spoon.WinWin:moveAndResize('left', true) end)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'right', function() spoon.WinWin:moveAndResize('right') end)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'up', function() spoon.WinWin:moveAndResize('top', true) end)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'down', function() spoon.WinWin:moveAndResize('bottom', true) end)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'C', function() spoon.WinWin:moveAndResize('center', true) end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'left', function() spoon.WinWin:moveToScreen('left', true) end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'right', function() spoon.WinWin:moveToScreen('right', true) end)
hs.hotkey.bind({'cmd', 'alt'}, 'left', function() spoon.WinWin:moveAndResize('left') end)

-- Lockscreen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'L', 'Lock Screen', function() hs.caffeinate.lockScreen() end)

-- Window Hints
hs.hotkey.bind({'alt'}, 'tab', 'Window Hints', function() hs.hints.windowHints() end)

-- Hammerspoon : Reload
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'R', function() hs.reload() end)