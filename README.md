# Bitcoin::RPC::Client - Bitcoin Core RPC client as a PERL module

This module is a pure PERL implementation of the methods that are currently
part of the Bitcoin Core RPC client calls (bitcoin-cli). The method names and
parameters are identical between the Bitcoin Core API and this module. This is
done for consistency so that a developer only has to reference one manual:
https://bitcoin.org/en/developer-reference#rpcs

Currently only tested against Bitcoin Core v0.12.1 and v0.13.0 but should work
with other versions.

DEPENDENCIES:
   - Moo
   - JSON::RPC::Client

INSTALL:
   - perl Makefile.PL
   - make
   - make test
   - make install

CAVEATS:
   - Boolean parameters must be passed as JSON::Boolean objects E.g. JSON::true
   - Fees are set server side (bitcoin.conf)

TODO:
   - Implement support for fees in constructor
