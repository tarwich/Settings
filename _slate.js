var sammyd = {};

sammyd.main = function() {
	// The size of the window hint icon
	var hintSize = 100;
	// True if hints should use icons, false if they should look like a window
	var hintIcons = false;

	// -------------------------------------------------- 
	// 
	// Configuration
	// 
	// -------------------------------------------------- 

	slate.configAll({
		// true causes all bindings to default to the current screen if the screen 
		// the reference does not exist. false causes only bindings that do not 
		// specify a screen to default to the current screen while bindings that 
		// reference screens that do not exist simply do nothing.
		defaultToCurrentScreen        : true,
		// type                       : String. Must be one of "dvorak", "colemak", "azerty" or "qwerty".
		keyboardLayout                : "qwerty",
		// The number of seconds that Window Hints will display for.
		windowHintsDuration           : 2,
		// The width of the Window Hints ovelay in pixels. (can be an expression)
		windowHintsWidth              : function(window) {
			// Cache the size of the window so we don't have to keep calling it
			var size = window.size();
			// Return the smaller of 100 or the percent of 100 that the width should be
			return 100*Math.min(1, size.width/size.height);
		},
		// The height of the Window Hints ovelay in pixels. (can be an expression)
		windowHintsHeight             : function(window) {
			// Cache the size of the window so we don't have to keep calling it
			var size = window.size();
			// Return the smaller of 100 or the percent of 100 that the height should be
			return 100*Math.min(1, size.height/size.width);
		},
		// If this is set to true, window hints will not show for windows that 
		// are hidden. Hints will show for all windows if this is false. A 
		// window is hidden if the window under the point at the center of 
		// where the hint overlay would show is not the window in question.
		windowHintsIgnoreHiddenWindows: false,
		// If true, the application's icon will be shown as a background for the 
		// letter instead of the rectangle. This is useful if 
		// windowHintsIgnoreHiddenWindows is false so that you can know which 
		// application a hint for a hidden window belongs to.
		windowHintsShowIcons          : hintIcons,
		// If true, hints in the same place will be spread out vertically. This is 
		// useful if windowHintsIgnoreHiddenWindows is false so that multiple 
		// windows with the same center will have distinct hints.
		windowHintsSpread             : true,
		// The padding between hint boxes which have been spread downwards.
		windowHintsSpreadPadding      : hintSize*.3,
		// The width in pixels of the search box for hint collisions. Other 
		// hints within this box will be spread down.
		windowHintsSpreadSearchWidth  : hintSize*.3,
		// The width in pixels of the search box for hint collisions. Other 
		// hints within this box will be spread down.
		windowHintsSpreadSearchHeight : hintSize*.3,
		// The X offset for window hints from the window's top left point 
		// (right is positive, left is negative). If 
		// windowHintsIgnoreHiddenWindows is set to true, the hint operation 
		// will try each expression in this array (using the Y coordinate from 
		// the same index in windowHintsTopLeftY) sequetially to see if it 
		// represents a point that is visible. The hint operation will display 
		// a hint at the first visible point. Note that the number of elements
		// in this array must equal the number of elements in 
		// windowHintsTopLeftY or all hint bindings will fail validation.
		windowHintsTopLeftX           : 0,
		windowHintsTopLeftY           : 0
	});


	// --------------------------------------------------
	// 
	// Keystrokes
	// 
	// --------------------------------------------------

	// Window hints
	slate.bind("esc:cmd", sammyd.windowHints);
};

// --------------------------------------------------
// window hints
// --------------------------------------------------
sammyd.windowHints = function(window) {
	window.doOperation(slate.operation("hint", {
		characters: "QWERASDFZXCV" + "TYUIGHJKBNM"
	}));
};

sammyd.main();

// vim: set foldmethod=syntax :
