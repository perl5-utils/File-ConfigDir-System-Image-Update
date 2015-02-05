#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'File::ConfigDir::System::Image::Update' ) || print "Bail out!\n";
}

diag( "Testing File::ConfigDir::System::Image::Update $File::ConfigDir::System::Image::Update::VERSION, Perl $], $^X" );
