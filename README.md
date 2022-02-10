# Bitcoin::RPC::Client - Bitcoin Core RPC client as a Perl module

[![CPAN version](https://badge.fury.io/pl/Bitcoin-RPC-Client.svg)](http://badge.fury.io/pl/Bitcoin-RPC-Client)
[![Build Status](https://github.com/whindsx/Bitcoin-RPC-Client/workflows/build/badge.svg)](https://github.com/whindsx/Bitcoin-RPC-Client/actions)

This module is a pure Perl implementation of the methods that are currently
part of the Bitcoin Core RPC client calls (bitcoin-cli). The method names and
parameters are identical between the Bitcoin Core API and this module. This is
done for consistency so that a developer only has to reference one manual:
https://developer.bitcoin.org/reference/rpc/index.html

Currently tested against Bitcoin Core v0.12, v0.13, v0.14, v0.15, v0.16, v0.17,
v0.18, v0.19, v0.20 and v0.21 but should work with earlier versions. Also, 
though not thoroughly tested, this module will work with other Bitcoin Core 
forks that have a bitcoind compatible JSON RPC API. E.g. Bitcoin Unlimited, 
Bitcoin UASF, Litecoin Core.

SYNOPSIS:
```perl
   use Bitcoin::RPC::Client;

   $btc = Bitcoin::RPC::Client->new(
      user     => "username",
      password => "p4ssword",
      host     => "127.0.0.1",
   );

   $chaininfo = $btc->getblockchaininfo;
   $blocks = $chaininfo->{blocks};
```

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
   - JSON::RPC::Legacy::Client

CAVEATS:
   - Boolean parameters must be passed as JSON::Boolean objects E.g. JSON::true

DONATE:
   - 1DopyzQi9mX3huvGacfjpzCKFug2Dtvykp
