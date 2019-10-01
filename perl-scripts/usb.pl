#!/usr/bin/perl
use USB::LibUSB;
use feature 'say';
use Data::Dump 'pp';

#
# simple program to list all devices on the USB
#
 
my $ctx = USB::LibUSB->init();
my @devices = $ctx->get_device_list();
 
for my $dev (@devices) {
    my $bus_number = $dev->get_bus_number();
    my $device_address = $dev->get_device_address();
    my $desc = $dev->get_device_descriptor();
    my $idVendor = $desc->{idVendor};
    my $idProduct = $desc->{idProduct};
   
    my $prodId = sprintf("%04x:%04x", $idVendor, $idProduct);
    my $busNumber = sprintf("%03d", $bus_number);
    my $deviceAddress = sprintf("%03d", $device_address);

    # say "$prodId --  $busNumber -- $deviceAddress";    

     if ($prodId eq '1d6b:0002') {
     	  say "$prodId --  $busNumber -- $deviceAddress";
		my $handle = $dev->open();
      		my $config = $handle->get_configuration();
		say pp $config;
		say "success";
	 	$handle->set_configuration($config); 

	  	$handle->close();
	  last;
     }

}

$ctx->exit();    
 
