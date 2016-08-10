package BTC;

use 5.008;
use Moo;
use JSON::RPC::Client;

use BTC::API;

our $VERSION  = '0.01';

has jsonrpc  => (is => "lazy", default => sub { "JSON::RPC::Client"->new });
has user     => (is => 'ro');
has password => (is => 'ro');
has host     => (is => 'ro');
has port     => (is => "lazy", default => 8332);
has timeout  => (is => "lazy", default => 20);

# SSL constructor options
has ssl      => (is => 'ro', default => 0);
has verify_hostname => (is => 'ro', default => 1);

sub AUTOLOAD {
   my $self   = shift;
   my $method = $BTC::AUTOLOAD;

   $method =~ s/.*:://;

   return if ($method eq 'DESTROY');

   $method =~ s/^__(\w+)__$/$1/;  # avoid to call built-in methods (ex. __VERSION__ => VERSION)

   # Check that method is even availabe in the API
   hasMethod($method);

   # Are we using SSL?
   my $uri = "http://";
   if ($self->ssl eq 1) {
      $uri = "https://";
   }
   my $url = $uri . $self->user . ":" . $self->password . "\@" . $self->host . ":" . $self->port;

   my $client = $self->jsonrpc;
   $client->ua->timeout($self->timeout); # Because bitcoind is slow
   # For self signed certs
   if ($self->verify_hostname eq 0) {
      $client->ua->ssl_opts( verify_hostname => 0 );
   }

   my @params = @_;
   my $obj = {
      method => $method,
      params => (ref $_[0] ? $_[0] : [@_]),
   };

   my $res = $client->call( $url, $obj );
   if($res) {
      if ($res->is_error) {
         print STDERR "error : ", $res->error_message->{message};
         return $res->error_message;
      }

      return $res->result;
   }

   # Else the service is down or incorrect
   print STDERR $client->status_line;
   return;
}

sub hasMethod {
   my ($method) = @_;

   # Check that method is even availabe in the API
   my $hasMethod = 0;
   foreach my $meth (@BTC::API::methods) {
      if (lc($meth) eq lc($method)) {
         $hasMethod = 1;
         last;
      }
   }

   if (!$hasMethod) {
      print STDERR "error message: Method does not exist";
      exit(0);
   }

   return 1;
}

1;

=pod

=head1 NAME

BTC - Bitcoin Core API RPCs

=head1 SYNOPSIS


   # Your bitcoind instances credentials
   $rpchost = "Your.IP.Address.Here";
   $rpcuser = "YourBitcoindRPCUserName";
   $rpcpassword = "YourBitcoindRPCPassword";
   # rpcport defaults to 8332

   # Create BTC object
   $btc = BTC->new(
      user     => $rpcuser,
      password => $rpcpassword,
      host     => $rpchost,
      ssl      => 1 # Optional
   );

   # Getting Data when a hash is returned
   $info    = $btc->getinfo;
   $balance = $info->{balance};
   print $balance;

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

   # Other functions that do not return a JSON object will have a scalar result
   $balance  = $btc->getbalance("yourAccountName");
   print $balance;

=head1 DESCRIPTION

This module implements in PERL the functions that are currently part of the
Bitcoin Core RPC client calls (bitcoin-cli).The function names and parameters
are identical between the Bitcoin Core API and this module. This is done for
consistency so that a developer only has to reference one manual:
https://bitcoin.org/en/developer-reference#getinfo

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
