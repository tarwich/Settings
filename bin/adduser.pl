#!/usr/bin/perl -w

=head1 NAME

	Symfono::AddUser

=head1 Synopsis

	This package is to make a system for adding users easily to a UNIX system
	bearing in mind that it is run as an administrator and typically for adding
	administrators.

=cut
package Symfono::AddUser;

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
	my $username = $ARGV[0] ? $ARGV[0] : "";
	my @groups = ();
	my $home = 1;
	my $fullName = "";
	
	while(1) {
		my @items = (
				{"n" => "Set user name : $username"            }, 
				{"g" => "Set groups    : ". join(",", @groups) }, 
				{"h" => "Create home   : ". ($home?"YES":"NO") }, 
				{"f" => "Set full name : $fullName"            }, 
				{"c" => "Create the user"                      }, 
				{"q" => "Quit"                                 }, 
			);

		# Show the menu
		my $item = menu(@items);

		given ( $item ) {
			when("n") { $username = prompt("Enter the new user name: "); } # Get a new user name
			when("g") { @groups = getGroups(); }                           # Get the groups to create
			when("h") { $home = !$home; }                                  # Invert the create home directories option
			when("f") { $fullName = prompt("Full name: "); }               # Get full name of user
			when("c") { createUser({                                       # Actually make the user
						"username"   => $username , 
						"groups"     => \@groups  , 
						"createHome" => $home     ,
						"fullName"   => $fullName ,
					}); }                                    
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
Args     : 
         : 1 = A dictionary of user options {
         :	name       => The user name to create
         :	fullName   => The full name of the user
         :	createHome => True if a home directory should be created for the user
         :	password   => The new password for the user
         :	@groups    => Array of groups to add the user to
         : }

=cut
sub createUser {
	# Get the options from the first argument
	my $options = shift;

	# Decide whether or not to create the home directory
	my $createHome = $options->{createHome} ? "--create-home" : "";
	# Join groups with a comma for usermod
	my $groups = @{$options->{groups}} ? "--groups " . join(",", @{$options->{groups}}) : "";
	# Get the username from the options
	my $username = $options->{username};
	# Make comment if fullName provided
	my $comment = $options->{fullName} ? "--comment \"$options->{fullName}\"" : "";

	# Make sure a username was provided
	unless($username) { fail("Must provide username"); }
	# Add the user
	system("useradd $username $createHome $groups $comment") or fail("Unable to create user");
	# Set the password for the user
	system("passwd $username") or fail("Unable to set password");
	quit("User $username added.");
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
	my @items = @_;

	# Check input
	unless(@items) { fail("menu called with no items"); }
	
	# Print menu
	foreach my $item (@items) {
		# Break up the item into its key and caption
		my ($i, $caption) = each(%$item);
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
Returns  : An array of the groups to add the user to after it is created
Args     : none

=cut
sub getGroups {
	print ""
		. "Enter the groups for the new user. "
		. "You may separate groups by any combination of whitespace and commas. "
		. "If you enter a blank line, then the groups will be cleared. "
		. "If you enter a ?, then the groups of the current user will be used. "
		. "\n";
	# Get the groups from the user
	my $groups = prompt("Groups: ");

	# If no groups were provided, then 
	if($groups eq "?") {
		# Set groups to the groups of the currently logged in user
		$groups = `groups`;
		# Cleanup the groups
		chomp $groups;
	}

	# Break up groups on commas and whitespace
	my @groups = split(/[,\s]+/, $groups);
	
	return @groups;
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
	# Get parametters
	my $message = @_ ? shift : ""; # Message to display to the user
	my $length  = @_ ? shift : 0 ; # Length of input
	# The result 
	my $value;

	# Show the message 
	print($message);

	# If we're only supposed to get one character:
	if($length == 1) {
		# Get the character from the user
		$value = ReadKey(0);
		# Echo input and clear the line
		if($message) { print("\n"); }
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

sub ReadKey {
	my $BSD_STYLE = 0;
	
    if ($BSD_STYLE) {
        system "stty cbreak </dev/tty >/dev/tty 2>&1";
    }
    else {
        system "stty", '-icanon', 'eol', "\001";
    }

    my $key = getc(STDIN);

    if ($BSD_STYLE) {
        system "stty -cbreak </dev/tty >/dev/tty 2>&1";
    }
    else {
        system 'stty', 'icanon', 'eol', '^@'; # ASCII NUL
    }

	return $key;
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

