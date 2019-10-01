#!/usr/bin/perl

use feature 'say';
use Data::Dump 'pp';
use RPi::Pin;
use RPi::Const qw(:all);
use Log::Rolling;
my $log = Log::Rolling->new('/var/log/fan-control/logfile.txt');
$log->max_size(500);

$log->entry("Getting pin");
my $pin = RPi::Pin->new(14);
$pin->mode(OUTPUT);
$log->entry("Got pin");

while(true) {
    my $temp=`vcgencmd measure_temp`;
    $temp =~ s/temp=//g;
    $temp =~ s/\'C//g;
    chomp $temp;
    $log->entry("Temp : $temp"); 
    if ($temp > 65.0) {
     	    say "Temp -> $temp : Turning fan on";	 
	    $pin->write(HIGH);
	   $log->entry("fan on"); 
    } else {
	    say "Temp -> $temp : Turning fan off";
            $pin->write(LOW); 
	    $log->entry("fan off");
    }
    $log->commit;
    sleep(4);
}

#print "pin number $num is in mode $mode with state $state\n";
