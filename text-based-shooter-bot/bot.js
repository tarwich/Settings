
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
	
	// Initialize (like new())
	ns.initialize = function() {
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
	};
	
	/**
	 * Join the first room available 
	 */
	ns.joinFirst = function() {
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
	
	// Reload function (because they don't really have one)
	ns.reload = function() {
		var prevammo = player.ammo;
		player.ammo = player.defaultAmmo;
		player.totalAmmo -= (player.ammo - prevammo);
		game.updateHUD();
	};
		
	// The player status hook
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

	// Prune old lines from console
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

	// Create a trap to intercept player status
	ns.trapStatus = function() {
		if(ns.oldStatusFunction == undefined) {
			// Memorize the status function
			ns.oldStatusFunction = player.getStatus;
			// The trap
			player.getStatus = function() { ns.statusHook.apply(this, arguments); };
		}
	};
	
	// Handled every time the server sends us a message
	ns.ajaxSuccess = function(a, b, c, text) {
		var json = null;
		
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
				game.performLook();
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
					for( direction in {n:0, s:0, e:0, w:0} )
					if(player.canGoInDirection(direction)) return player.go(direction);
				} else {
					// Shoot the guy
					ns.fire(other.dir);
				}
			}
		}

		// Remember our health for the future
		ns.health = player.health;
	};
	
	ns.initialize();
})("bot", jQuery);

