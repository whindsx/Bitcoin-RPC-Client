# BitcoinPM
Bitcoin PM is a PERL module for connecting to bitcoind instances, though 
incomplete example.pl will work.

Currently only a few functions are implemented and tested against Bitcoin Core v0.11.1

Dependencies:
   - Moo
   - Ouch
   - JSON
   - JSON::RPC::Client

TODO:
   - Implement the rest of the standard bitcoind functions
   - Move generic JSON/RPC stuff to its own class, seperate from BTC functions
   - Documentation
