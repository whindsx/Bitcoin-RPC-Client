#!/usr/bin/perl 

#require("./lib/BitcoinPM.pm");

use BTC;

##
# Bitcoin global Vars (user supplied)
##
$RPCHOST = "Your.IP.Address.Here";

# User for RPC commands to bitcoind
$RPCUSER = "YourBitcoindRPCUserName";

# RPC password to bitcoind
$RPCPASSWORD = 'YourBitcoindRPCPassword';

# Create RPC object
$btcd = BTC->new(
    user     => $RPCUSER,
    password => $RPCPASSWORD,
    host     => $RPCHOST,
);

$info    = $btcd->getinfo;
$balance = $info->{balance};

print $balance;

#$account  = $btcd->getaccount("18hrZZjnNEJiSZArcLhFF3HmXbaL8xeWAW");
#print $account;

#$balance  = $btcd->getbalance("root");
#print $balance;

#$amount  = $btcd->getreceivedbyaccount("xyz2013");
#print $amount;

exit(0);
