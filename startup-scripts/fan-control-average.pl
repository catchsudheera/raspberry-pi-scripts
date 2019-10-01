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

my @history=();

while(true) {
    my $temp=`vcgencmd measure_temp`;
    $temp =~ s/temp=//g;
    $temp =~ s/\'C//g;
    chomp $temp;
    unshift @history, $temp;
    if (scalar(@history) > 10) {
      pop @history;
    }
    #foreach (@history) { print $_ . " "; }
    #say "";
    my $avgTemp = average(@history);
    $log->entry("Temp : $temp , avg temp last min : $avgTemp"); 
    if ($avgTemp > 58.0) {
     	    say "AvgTemp -> $avgTemp : Turning fan on";	 
	    $pin->write(HIGH);
	    $log->entry("fan on"); 
    } else {
	    say "AvgTemp -> $avgTemp : Turning fan off";
            $pin->write(LOW); 
	    $log->entry("fan off");
    }
    $log->commit;
    sleep(5);
}

sub average {
   my @array = @_;
   my $sum = 0;
   foreach (@array) { $sum += $_; }
   return $sum/scalar(@array);
}
