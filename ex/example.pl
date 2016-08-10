#!/usr/bin/perl 

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
$btc = BTC->new(
    host     => $RPCHOST,
    user     => $RPCUSER,
    password => $RPCPASSWORD,
);

$info    = $btc->getinfo;
$balance = $info->{balance};

print $balance;

#$account  = $btc->getaccount("18hrZZjnNEJiSZArcLhFF3HmXbaL8xeWAW");
#print $account;

#$balance  = $btc->getbalance("root");
#print $balance;

#$amount  = $btc->getreceivedbyaccount("xyz2013");
#print $amount;

exit(0);
