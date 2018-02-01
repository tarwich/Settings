
-- HCalendar
hs.loadSpoon('HCalendar')

-- WinWin
hs.loadSpoon('WinWin')
hs.hotkey.bind({'cmd', 'alt'}, 'left', function() spoon.WinWin:moveAndResize('left') end)
hs.hotkey.bind({'cmd', 'alt'}, 'right', function() spoon.WinWin:moveAndResize('right') end)
hs.hotkey.bind({'cmd', 'alt'}, 'up', function() spoon.WinWin:moveAndResize('top') end)
hs.hotkey.bind({'cmd', 'alt'}, 'down', function() spoon.WinWin:moveAndResize('bottom') end)
hs.hotkey.bind({'cmd', 'alt'}, 'return', function() spoon.WinWin:moveAndResize('center') end)
hs.hotkey.bind({'cmd', 'alt'}, 'c', function() spoon.WinWin:moveAndResize('center') end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'left', function() spoon.WinWin:moveToScreen('left') end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'right', function() spoon.WinWin:moveToScreen('right') end)

-- Lockscreen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'L', 'Lock Screen', function() hs.caffeinate.lockScreen() end)

-- Window Hints
hs.hotkey.bind({'alt'}, 'tab', 'Window Hints', function() hs.hints.windowHints() end)
