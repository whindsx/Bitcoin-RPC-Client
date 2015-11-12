package BitcoinPM;

use 5.008;
use Moo;
use Ouch;
use JSON;
use JSON::RPC::Client;

our $VERSION  = '0.01';

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

has jsonrpc  => (is => "lazy", default => sub { "JSON::RPC::Client"->new });
has user     => (is => 'ro');
has password => (is => 'ro');
has host     => (is => 'ro');
has port     => (is => "lazy", default => 8332);

=cut
   client_operation. Aggregates the common RPC/JSON operations into
   one place.
=cut

sub client_operation{
   my $self = shift;
   my $url = "https://" . $self->user . ":" . $self->password . "\@" . $self->host . ":" . $self->port;

   my $obj = shift;

   my $client = $self->jsonrpc;

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

=cut
  getinfo
         Returns an object containing server information.

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
=cut

sub getinfo {
   my $self = shift;

   my $obj = {
      method  => 'getinfo',
   };

   return &client_operation($self,$obj);
}

=cut
   getaccount 'bitcoinaddress'
         Returns the account associated with the given address.

=cut

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

   getbalance 'account'
         Returns the server's available balance, or the balance for 'account'.

=cut

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

   getreceivedbyaccount 'account' ['minconf=1']
         Returns the total amount received by addresses associated with 'account' in transactions with at least ['minconf'] confirmations.

=cut

sub getreceivedbyaccount {

   my $self = shift;
   my $account = shift;
   my $minconf = shift;

   my $obj = {
      method  => 'getreceivedbyaccount',
      params  => [ $account ]
   };

   push $obj->{params},"minconf=$minconf" if ($minconf);

   return &client_operation($self,$obj);
} 

=cut                                                                                                                                      
                                                                                                                                          
   move <'fromaccount'> <'toaccount'> <'amount'> ['minconf=1'] ['comment']
              Moves funds between accounts.
                                                                                                                                          
=cut

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
   push $obj->{params},"minconf=$minconf" if ($minconf);
   push $obj->{params}, $comment if ($comment);

   return &client_operation($self,$obj);
}

1;

__END__

=head1 NAME

BitcoinPM - access a local bitcoind with

=head1 SYNOPSIS

Creating the client

require("./include/BitcoinPM.inc");

# Create RPC connection object
$btcd = BitcoinPM->new(
    user     => 'rpcusername',
    password => 'rpcpassword',
    path     => '/path/to/bitcoind/binary',
  );

Getting Data

  $info    = $btcd->get_info;
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

=head1 DESCRIPTION

BitcoinPM gives acces to an already running bitcoind (wallet) instance

Gives users and object oriented method of approaching the bitcoind in 
perl. Parses JSON output as well.

Old Way
sub get_account {
   my $self = shift;
   my $cmd  = $self->path . "-rpcssl -rpcconnect=" . $self->host . " -rpcuser=" . $self->user . " -rpcpassword=" . $self->password . " ";

   # Args
   my ($address) = @_; 

   # The bitcoin function
   $cmd    .= "getaccount '$address'";  

   my $result;
   $result = `$cmd 2>&1`; 

   # Do something if there's and error
   $result = &handle_error($result);

   return $result;
}

=cut
