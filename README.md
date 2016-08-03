# BTC (BitcoinPM - Bitcoin Perl Module) 
This module implements in PERL the functions that are currently part of 
the Bitcoin Core RPC client calls (bitcoin-cli). The function names and 
parameters are identical between the Bitcoin Core API and this module. 
This is done for consistency so that a developer does not have to 
reference two manuals.
https://bitcoin.org/en/developer-reference#getinfo

Currently only a few functions are implemented and tested against Bitcoin 
Core v0.12.1.

DEPENDENCIES:
   - Moo
   - JSON
   - JSON::RPC::Client

INSTALL:
   - perl Makefile.PL
   - make
   - make test
   - make install

TODO:
   - Implement the rest of the standard bitcoin-cli functions
   - Documentation
