use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = '0.0.1';
%IRSSI = (
	authors     => 'phisher1',
	contact     => 'phisher1@gmail.com',
	commands    => 'rev',
	name        => 'reverse_text',
	description => 'A script that reverses the text you type.', 
	license     => 'GNU GPL version 2',
	changed     => '2019-07-29'
);

#--------------------------------------------------------------------
# Changelog
#--------------------------------------------------------------------
#
# reverse.pl 0.0.1 (2019-07-29) 
# initial rip and rewrite of another script to suit my needs
# 
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# Public Variables
#--------------------------------------------------------------------
my %myHELP = ();


#--------------------------------------------------------------------
# Help function
#--------------------------------------------------------------------
sub cmd_help { 
	my ($about) = @_;

	%myHELP = (
		rev =>
"%9rev - reverse%9

  /rev <text>

reverses the text you type
",
	);

	if ( $about =~ /(rev)/i ) {
		Irssi::print($myHELP{rev},MSGLEVEL_CLIENTCRAP);
		Irssi::signal_stop;
	}
}

#--------------------------------------------------------------------
# reverse line
#--------------------------------------------------------------------
sub reverseline{
	my $line = shift;
	my $outline = "";
	my $word = "";
	my $i=0;
	my @splitLine;
        my $array_size;
	my @revarray;
        my $output;

	#we leave the \n at the end, less interference.
	chomp($line);
        @splitLine=split(/(\W)/,$line);
        @revarray = reverse @splitLine;
        $array_size = @revarray;
        if ($array_size > 1) { 
           for ($i=0; $i<= @revarray;$i++) {                         
              $output .= reverse($revarray[$i]);
           }
           return $output;
        } else { 
           $output = reverse($line);
           return $output;
        }          
}

#--------------------------------------------------------------------
# Defintion of /rev
#--------------------------------------------------------------------
sub cmd_rev {
	my ($args, $server, $witem) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to server");
		return;
	}

	my $reversedline = reverseline($args);
	if ($witem && ($witem->{type} eq "CHANNEL" ||
			$witem->{type} eq "QUERY")) {
		# there's query/channel active in window
		$witem->command("MSG ".$witem->{name}." $reversedline");
	} else {
		Irssi::print("Nick not given, and no active channel/query in window");
	}
}

#--------------------------------------------------------------------
# Irssi::Settings / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::command_bind("rev", "cmd_rev", "Reverse Line");
Irssi::command_bind("help","cmd_help", "Irssi commands");

