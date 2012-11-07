
(function(NS, $) {
	// Create a namespace
	var ns; (ns = window[NS]) || (ns = window[NS] = {});

	var $content;
	// Stuff that the game makes
	//var player;
	//var game;
	
	// Remove old timer
	if(ns.interval) window.clearInterval(ns.interval);
	// Remove old ajaxSuccess listener (if present)
	$("body").unbind("ajaxSuccess", window.bot.ajaxSuccess);
	// Reset the last action time
	ns.lastActionTime = new Date().getTime();
	// Setup an idle seed
	ns.idleIn = 99999;
	// Setup the idle seed (seconds)
	ns.IDLE_SEED = 5;
	// What should a bored bot do? LOOK / MOVE
	ns.idleAction = "MOVE";
	// Tell the user what you're doing
	ns.verbose = true;
	
	/**
	 * Initialize (like new())
	 */
	ns.initialize = function() {
		// Reset the idle time
		ns.resetIdle();
		// Find the content div
		$content = ns.$content = $("#content");
		// Hook into the old player status
		ns.trapStatus();
		// Start the grand timer
		//ns.interval = window.setInterval(ns.tick, 1000);
		// Add new ajaxSuccess listener
		$("body").bind("ajaxSuccess", ns.ajaxSuccess);
	};

	/**
	 * Fires in current direction, checking ammo before and after
	 */
	ns.fire = function(direction) {
		// If we're supposed to fire in a certain direction
		if(direction != undefined) {
			// If we're not facing the direction
			if(player.direction != direction) 
				// Then turn
				player.turnToDirection(direction, true);
		}

		// If we're out of ammo, then reload
		if(player.ammo <= 0) ns.reload();
		// And fire!
		player.fireInCurrentDirection();
		// If we're out of ammo, then reload
		if(player.ammo <= 0) ns.reload();
		// Reset the idle timer
		ns.resetIdle();
	};
	
	/**
	 * Join the first room available 
	 */
	ns.joinFirst = function() {
		// Tell the user
		if(verbose) ns.message("Trying to join the first non-full room");

		// Go through the rooms
		for(var i=0; i<game.rooms.length; ++i) {
			var room = game.rooms[i];

			// If there's room in this room
			if(room.players < parseInt(room.maxplayers, 0)) {
				// Join this room
				game.joinRoom.apply(game, room.id);
				// Don't look at further rooms
				break;
			}
		}
	};

	/**
	 * Look around
	 */
	ns.look = function() {
		// Tell the user 
		if(ns.verbose) ns.message("Looking around nervously");
		// Look around
		game.performLook();
		// Reset the idle timer
		ns.resetIdle();
	}

	/**
	 * Show a message to the user
	 */
	ns.message = function(text) {
		// Output the text to the game's native display object
		if(text != undefined) display.print(["BOT: ", text, "<br />"].join(""));
	};

	/**
	 * Move in a direction, or randomly if none provided
	 */
	ns.move = function(direction) {
		// No direction defaults to random
		if(direction == undefined) {
			var i, directions = "news".split("");

			// Find a direction to move
			while(directions.length > 0) {
				// Get the index of a random item out of the array
				i = Math.floor(Math.random() * directions.length);
				// Remove that direction from the array
				direction = directions.splice(i, 1)[0];
				// If we can move, then go
				if(player.canGoInDirection(direction)) return ns.move(direction);
			}
		} else {
			// Tell the user 
			if(ns.verbose) ns.message("Going " + game.getFullDirection(direction));
			// Go where we were asked
			player.go(direction);
			// Reset the idle timer
			ns.resetIdle();
		}
	};
	
	/** 
	 * Reload function (because they don't really have one)
	 */
	ns.reload = function() {
		// Tell the user
		ns.message("Reloading");
		// Shanked stright from the game code ---{
		var prevammo = player.ammo;
		player.ammo = player.defaultAmmo;
		player.totalAmmo -= (player.ammo - prevammo);
		game.updateHUD();
		// }---
		// Reset the idle timer
		ns.resetIdle();
	};

	/**
	 * Update the idle time
	 */
	ns.resetIdle = function() {
		// Set the lastActionTime to right now
		ns.lastActionTime = new Date().getTime();
		// Set a new idle time
		ns.idleIn = 1000 + (Math.random() * ns.IDLE_SEED * 1000);
	};
		
	/**
	 * The player status hook
	 */
	ns.statusHook = function() {
		// Pre status
		
		// Native status
		ns.oldStatusFunction.apply(this, arguments);

		// Post status
		
		
		// Respawn if dead
		if(player.dead == true) player.respawn();
		// Reload if needed
		if(player.ammo <= 0) ns.reload();
		
	};

	/**
	 * Prune old lines from console
	 */
	ns.tick = function() {
		// Do not write commands in here. This is ONLY for the purpose of 
		// reading the text in $content
		var lines = $content.html().split("<br>");
		
		// If more than 200 lines of content, then...
		if(lines.length > 200) {
			// Trim content to 100 lines and update $content
			$content.html($content.html().slice(-100).join("\n<br>\n"));
		}
	};

	/**
	 * Create a trap to intercept player status
	 */
	ns.trapStatus = function() {
		if(ns.oldStatusFunction == undefined) {
			// Memorize the status function
			ns.oldStatusFunction = player.getStatus;
			// The trap
			player.getStatus = function() { ns.statusHook.apply(this, arguments); };
		}
	};
	
	/**
	 * Handled every time the server sends us a message
	 */
	ns.ajaxSuccess = function(a, b, c, text) {
		var json = null;
		
		// Don't act in the lobby
		if(game.inRoom < 1) return;
		try { json = jQuery.parseJSON(text); } catch(e) {}
		// Don't handle null json
		if(json == null) return;

		console.log(json, [parseInt(json.h, 0), ns.health].join("/"), text);
		
		// If we're alive
		if(!player.dead) {
			// Hit someone, but didn't kill 'em
			if( (json.response == "HIT") ) {
				// Shoot the guy again
				ns.fire();
			}

			// We killed someone
			else if(json.response == "KILL") {
				// Look around
				ns.look();
			}
			
			// Last attacker (if last+direction) (if hurtMe)
			else if( (json.l) && (json.l.d) && (parseInt(json.h, 0) != ns.health) ) {
				// Fire (in the direction of the other)
				ns.fire(json.l.d);
			}

			// Seen (you see people)
			else if( (json.seen) && (json.seen[0]) ) {
				// The player we 'see'
				other = json.seen[0];
				
				// If the distance is zero, then we're on top of them
				if(json.distance == 0) {
					// Move off of the other player
					ns.move();
				} else {
					// Shoot the guy
					ns.fire(other.dir);
				}
			}

			// We moved. Look around
			else if( (json.directions) ) {
				// Get a clean look at things
				ns.look();
			}

			// If we're idle
			else if( (new Date().getTime() - ns.lastActionTime) >= ns.idleIn) {
				// Look around nervously
				if(ns.idleAction == "LOOK") ns.look();
				// Move around nervously
				else if(ns.idleAction == "MOVE") ns.move();
			}
		}

		// Remember our health for the future
		ns.health = player.health;
	};
	
	ns.initialize();
})("bot", jQuery);

