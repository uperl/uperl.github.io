#!/usr/bin/env perl

use strict;
use warnings;
use XOR;

my $xor = XOR->new(
  root => '.',
  org  => 'uperl',
  site_name => 'uperl',
);

$xor->pods->add_sister_site("https://alienfile.org");
$xor->pods->add_sister_site("https://perlwasm.github.io");
$xor->pods->add_sister_site("https://pl.atypus.org");

$xor->builder->build;
