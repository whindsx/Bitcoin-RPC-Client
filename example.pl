#!/usr/bin/perl 

require("./lib/BitcoinPM.pm");

##
# Bitcoin global Vars (user supplied)
##
$RPCHOST = "Your.IP.Address.Here";

# User for RPC commands to bitcoind
$RPCUSER = "YourBitcoindRPCUserName";

# RPC password to bitcoind
$RPCPASSWORD = 'YourBitcoindRPCPassword';

# Create RPC object
$btcd = BitcoinPM->new(
    user     => $RPCUSER,
    password => $RPCPASSWORD,
    host     => $RPCHOST,
);

$info    = $btcd->get_info;
$balance = $info->{balance};

print $balance;

#$account  = $btcd->get_account("18hrZZjnNEJiSZArcLhFF3HmXbaL8xeWAW");
#print $account;

#$balance  = $btcd->get_balance("root");
#print $balance;

#$amount  = $btcd->get_received_by_account("xyz2013");
#print $amount;

exit(0);
