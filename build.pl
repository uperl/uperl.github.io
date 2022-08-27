#!/usr/bin/env perl

use strict;
use warnings;
use XOR;

my $xor = XOR->new(
  root => '.',
  org  => 'uperl',
  site_name => 'uperl',
);
$xor->builder->build;
