# Bitcoin::RPC::Client - Bitcoin Core RPC client as a PERL module

[![Build Status](https://travis-ci.org/whindsx/Bitcoin-RPC-Client.svg?branch=master)](https://travis-ci.org/whindsx/Bitcoin-RPC-Client)

This module is a pure PERL implementation of the methods that are currently
part of the Bitcoin Core RPC client calls (bitcoin-cli). The method names and
parameters are identical between the Bitcoin Core API and this module. This is
done for consistency so that a developer only has to reference one manual:
https://bitcoin.org/en/developer-reference#rpcs

Currently tested against Bitcoin Core v0.12, v0.13, v0.14 and v0.15 but 
should work with earlier versions.

INSTALL:
   - Source
      - perl Makefile.PL
      - make
      - make test
      - make install

   - cpanm
      - cpanm Bitcoin::RPC::Client
   
   - CPAN shell
      - perl -MCPAN -e shell
      - install Bitcoin::RPC::Client

DEPENDENCIES:
   - Moo
   - JSON::RPC::Client

CAVEATS:
   - Boolean parameters must be passed as JSON::Boolean objects E.g. JSON::true

DONATE:
   - 1Ky49cu7FLcfVmuQEHLa1WjhRiqJU2jHxe 
