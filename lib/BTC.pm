package BTC;

use 5.008;
use Moo;
use JSON;
use JSON::RPC::Client;

#use Data::Dumper;

our $VERSION  = '0.01';

has jsonrpc  => (is => "lazy", default => sub { "JSON::RPC::Client"->new });
has user     => (is => 'ro');
has password => (is => 'ro');
has host     => (is => 'ro');
has port     => (is => "lazy", default => 8332);

# SSL constructor options
has ssl      => (is => 'ro', default => 0);
has verify_hostname => (is => 'ro', default => 1);

# client_operation. Aggregates the common RPC/JSON operations into
# one place.
sub client_operation{
   my $self = shift;

   # Are we using SSL?
   my $uri = "http://";
   if ($self->ssl eq 1) {
      $uri = "https://";
   } 
   my $url = $uri . $self->user . ":" . $self->password . "\@" . $self->host . ":" . $self->port;

   my $method = shift;
   $method = getMethodName($method);
   my $obj = {
      method  => "$method",
      params  => [] 
   };   

   push @{$obj->{params}}, @_ if (@_);   

   my $client = $self->jsonrpc;
   $client->ua->timeout(20); # Because bitcoind is slow
   # For self signed certs
   if ($self->verify_hostname eq 0) {
      $client->ua->ssl_opts( verify_hostname => 0 ); 
   }

   my $res = $client->call( $url, $obj );
   if($res) {
      if ($res->is_error) {
         print STDERR "error : ", $res->error_message->{message};
         return $res->error_message;
      }

      return $res->result;
   }

   #print Dumper($res->result);

   # Else the service is down or incorrect
   print STDERR $client->status_line;                                                                                                     
   return;
}

sub getMethodName {
   my ($method) = @_; 
   my $pkg = __PACKAGE__;
   $method =~ s/$pkg\:\://g;
   return $method;
}

#
# Use prepare rather than write each function?
#
# #$client->prepare($uri, ['sum', 'echo']);
#
# @methods = ['geinfo,'getbalance']
# $client->prepare($uri, @methods);
#
# return $client;

sub getinfo { 
   my $self = shift;
   return &client_operation($self,(caller(0))[3],@_); 
}

sub getbalance {
   my $self = shift;
   return &client_operation($self,(caller(0))[3],@_);
}

sub getblockcount {
   my $self = shift;                                                                                                                      
   return &client_operation($self,(caller(0))[3],@_);    
}

sub listaccounts {
   my $self = shift;
   return &client_operation($self,(caller(0))[3],@_);
}

=cut
# getinfo
#{
#    "version" : 110100,
#    "protocolversion" : 70002,
#    "walletversion" : 60000,
#    "balance" : 0.01787039,
#    "blocks" : 388586,
#    "timeoffset" : 34,
#    "connections" : 16,
#    "proxy" : "",
#    "difficulty" : 79102380900.22598267,
#    "testnet" : false,
#    "keypoololdest" : 1401215157,
#    "keypoolsize" : 101,
#    "paytxfee" : 0.00005000,
#    "relayfee" : 0.00005000,
#    "errors" : "Warning: This version is obsolete; upgrade required!"
#}
sub getinfo {
   my $self = shift;

   my $obj = {
      method  => 'getinfo',
   };

   return &client_operation($self,$obj);
}
=cut

# getaccount 'bitcoinaddress'
#     Returns the account associated with the given address.
sub getaccount {

   my $self = shift;
   my $address = shift;

   my $obj = {
      method  => 'getaccount',
      params  => [ $address ]
   };

   return &client_operation($self,$obj);
}

=cut
# getbalance 'account'
#     Returns the server's available balance, or the balance for 'account'.
sub getbalance {

   my $self = shift;
   my $account = shift;

   my $obj = {
      method  => 'getbalance',
      params  => [ $account ]
   };

   return &client_operation($self,$obj);
}
=cut

# getreceivedbyaccount 'account' ['minconf=1']
#     Returns the total amount received by addresses associated with 'account' in transactions with at least ['minconf'] confirmations.
sub getreceivedbyaccount {

   my $self = shift;
   my $account = shift;
   my $minconf = shift;

   my $obj = {
      method  => 'getreceivedbyaccount',
      params  => [ $account ]
   };

   push @{$obj->{params}}, $minconf if ($minconf);

   return &client_operation($self,$obj);
} 

# move <'fromaccount'> <'toaccount'> <'amount'> ['minconf=1'] ['comment']
#     Moves funds between accounts.
sub move {
   my $self = shift;                                                                                                                       

   my $fromaccount = shift;
   my $toaccount = shift;
   my $amount = shift;
   my $minconf = shift;
   my $comment = shift;

   my $obj = {
      method  => 'move',
      params  => [ $fromaccount, $toaccount, $amount ]
   };
   # Add optional params
   push @{$obj->{params}}, $minconf if ($minconf);
   push @{$obj->{params}}, $comment if ($comment);

   return &client_operation($self,$obj);
}

# listaccounts 1 true
#     lists accounts and their balances.
#     Returns JSON object
=cut
sub listaccounts{

   my $self = shift;                                                                                                                       

   my $minconf = shift;
   my $watch = shift;

   my $obj = {                                                                                                                            
      method  => 'listaccounts',                                                                                                                  
   };                                                                                                                                     
   # Add optional params                                                                                                                  
   push @{$obj->{params}}, $minconf if ($minconf);
   push @{$obj->{params}}, $watch if ($watch);

   return &client_operation($self,$obj);
}
=cut

#     The backupwallet RPC safely copies wallet.dat to the specified file, i
#     which can be a directory or a path with filename.
sub backupwallet{

   my $self = shift;

   my $dest = shift;

   my $obj = {
      method  => 'backupwallet',
      params  => [ $dest ]
   };

   return &client_operation($self,$obj);
}

# validateaddress mgnucj8nYqdrPFh2JfZSB1NmUThUGnmsqe
#     returns information about the given Bitcoin address
sub validateaddress{

   my $self = shift;

   my $address = shift;

   my $obj = {
      method  => 'validateaddress',
      params  => [ $address ]
   };

   return &client_operation($self,$obj);
}

1;

=pod

=head1 NAME

BTC - Bitcoin Core API RPCs

=head1 SYNOPSIS

use BTC; 
 
# Your bitcoind instances credentials  
$RPCHOST = "Your.IP.Address.Here";  
$RPCUSER = "YourBitcoindRPCUserName"; 
$RPCPASSWORD = 'YourBitcoindRPCPassword'; 
# RPC Port defaults to 8332

# Create BTC object
$btc = BTC->new( 
    user     => $RPCUSER, 
    password => $RPCPASSWORD, 
    host     => $RPCHOST, 
    ssl      => 1 # Optional 
); 

# Getting Data when a hash is returned
$info    = $btc->getinfo;
$balance = $info->{balance};

  A person would need to know the JSON elements of
  the output. Ex.

   {
      "version" : 80100,
      "protocolversion" : 70001,
      "walletversion" : 60000,
      "balance" : 0.00720000,
      "blocks" : 253032,
      "connections" : 16,
      "proxy" : "",
      "difficulty" : 50810339.04827648,
      "testnet" : false,
      "keypoololdest" : 1365114158,
      "keypoolsize" : 101,
      "paytxfee" : 0.00500000,
      "errors" : ""
   }

# Other functions that do not return a JSON object will
# simply have a scalar result
$balance  = $btc->getbalance("yourAccountName");
print $balance;

=head1 DESCRIPTION

This module implements in PERL the functions that are currently part of the 
Bitcoin Core RPC client calls (bitcoin-cli).The function names and parameters 
are identical between the Bitcoin Core API and this module. This is done for 
consistency so that a developer does not have to reference two manuals.
https://bitcoin.org/en/developer-reference#getinfo

=head2 Methods                                                                                                                                      
                                                                                                                                                    
=over 12                                                                                                                                            
                                                                                                                                                    
=item getinfo 
=item getaccount
=item getbalance
=item getreceivedbyaccount 
=item move 
=item listaccounts 
=item backupwallet 
=item validateaddress

=back

=head1 AUTHOR

Wesley Hinds wesley.hinds@swri.org

=head1 AVAILABILITY

The latest branch is avaiable from Github.

https://github.com/whinds84/BitcoinPM

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Wesley Hinds.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut
