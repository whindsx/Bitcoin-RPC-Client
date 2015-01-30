# BitcoinPM
Bitcoin PM is a PERL module for connecting to bitcoind instances, though 
incomplete example.pl will work.

The main issue is proper error catching. Bitcoind does not produce a string 
that JSON can parse when an error occurs. The JSON module is looking for a 
string starting with "{" rather than "error: ...", so it returns nothing at all.

Dependencies:
   - Moo
   - Ouch
   - JSON
   - JSON::RPC::Client

TODO:
   - Proper error handling
   - Implement the rest of the standard bitcoind functions
   - Move generic JSON/RPC stuff to its own class, seperate from BTC functions
   - Investigate using bitcoind code to error check, ex. rpcserver.cpp
