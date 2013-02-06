#!/usr/bin/perl -w

=head1 NAME

	Symfono::AddUser

=head1 Synopsis

	This package is to make a system for adding users easily to a UNIX system
	bearing in mind that it is run as an administrator and typically for adding
	administrators.

=cut
package Symfono::AddUser;

use Term::ReadKey;

# Turn on strict error checking
use strict;

our $usage = "$0 <username>";

=head2 main

Title    : main
Usage    : main();
Function : This is the main entry point for the program.
         : Usually I sort my methods alphabetically with the
         : exception of main.
Returns  : void
Args     : (none)

=cut
sub main {
    use 5.010;
	my $username = $ARGV[0];
	my $groups = "";
	my $home = 1;
	
	while(1) {
		my %items = (
				"n" => "Set user name : $username"            , 
				"g" => "Set groups    : $groups"              , 
				"h" => "Create home   : ". ($home?"YES":"NO") , 
				"c" => "Create the user"                      , 
				"q" => "Quit"                                 , 
			);
		# Show the menu
		my $item = menu(\%items);

		given ( $item ) {
			when("n") { $username = prompt("Enter the new user name: "); }
			when("g") { $groups = getGroups(); }
			when("c") { createUser(); }
			when("q") { quit(); }
			default { fail("Unknown item: $item. Quitting"); }
		}
	}
	# If the username was not provided on the command line, then get it through
	# a prompt
	unless($username) { $username = prompt("Enter the new user name: "); }
	# If we still don't have a username, then quit, displaying the usage
	unless($username) { fail("Usage: $usage"); }

	print "Will create user named: $username";
}

=head2 createUser

Title    : createUser
Usage    : createUser();
Function : This is the method that actually makes the user, adds the groups,
         : sets the key data, etc.
Returns  : void
Args     : none

=cut
sub createUser {
	print "useradd --create-home ";
	print "\n";
	quit();
}

=head2 menu

Title    : menu
Usage    : my $selection = menu(["First item", "Second item"])
Function : Prints a list of items prefixed by a number and asks the user to
         : enter a number. Returns user input regardless of validity.
Return   : The number chosen by the user
Args     : 
         : Array of items to display

=cut
sub menu {
	# Get the list of menu items
	my $items = shift;
	my %items = %$items;

	# Check input
#	unless($items) { fail("menu called with no items"); }
	
	# Print menu
	while( my($i, $caption) = each(%items) ) {
		# Break up the item into its key and caption
#		my ($i, $caption) = each(%item);
		print "$i) $caption\n";
	}

	# Prompt
	prompt("Choose an item: ", 1);
}

=head2 fail

Title    : fail
Usage    : fail("Failure message");
Function : This method prints the error message and quits with error code 1
Returns  : void
Args     : 
         : The message to print

=cut
sub fail {
	print STDERR "ERROR: " . shift(@_);
	exit(1);
}

=head2 getGroups

Title    : getGroups
Usage    : my $groups = getGroups();
Function : Prompts the user for a list of groups, then returns it. If the user doesn't provide any groups, then the groups of the currently logged-in user will be used.
Returns  : A string of the groups to add the user to after it is created
Args     : none

=cut
sub getGroups {
	print ""
		. "Enter the groups for the new user. "
		. "You may separate groups by any combination of whitespace and commas. "
		. "If you enter a blank line, then the groups of the current user will be used. "
		. "\n";
	# Get the groups from the user
	my $groups = prompt("Groups: ");

	# If no groups were provided, then 
	unless($groups) {
		# Set groups to the groups of the currently logged in user
		$groups = `groups`;
		# Cleanup the groups
		chomp $groups;
	}
	
	return $groups;
}

=head2 prompt

Title    : prompt
Usage    : my $value = prompt("Message: ");
Function : Show a message and get a line of text from the user
Returns  : The text that the user entered (chomped)
Args     : 
         : 1 = The message to display to the user
		 : 2 = The length of the input (either absent or 1). If 1, then only 1
		 :     character will be read / returned

=cut
sub prompt {
	use Term::ReadKey;
	
	# Get parametters
	my $message = @_ ? shift : ""; # Message to display to the user
	my $length  = @_ ? shift : 0 ; # Length of input
	# The result 
	my $value;

	# Show the message 
	print($message);

	# If we're only supposed to get one character:
	if($length == 1) {
		# Set the read mode to raw to get only one character
		ReadMode "raw";
		# Get the character from the user
		$value = ReadKey(0);
		# Set the read mode back to what it was before
		ReadMode "restore";
		# Echo input and clear the line
		if($message) { print("$value\n"); }
	}

	# More than one character
	else {
		# Get the input
		$value = <STDIN>;
		# Trim the input
		chomp($value);
	}

	# Return the value
	return $value;
}

=head2 quit

Title    : quit
Usage    : quit("message");
Function : Quits the application, and displays the (optional) message
Returns  : void
Args     : 
         : 1 = Message. Optional. Defaults to "Bye"

=cut
sub quit {
	# Parse arguments
	my $message = @_ ? shift : "Bye"; # Message (defaults to "Bye")

	# Show the message
	print "$message\n";
	# Quit, returning 0
	exit(0);
}

# Go to the program entry point
main

