#!/usr/bin/perl 

use Bitcoin::RPC::Client;

##
# Bitcoin global Vars (user supplied)
##
$RPCHOST = "Your.IP.Address.Here";

# User for RPC commands to bitcoind
$RPCUSER = "YourBitcoindRPCUserName";

# RPC password to bitcoind
$RPCPASSWORD = 'YourBitcoindRPCPassword';

# Create RPC object
$btc = Bitcoin::RPC::Client->new(
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
