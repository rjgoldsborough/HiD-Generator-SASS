use strict;
use warnings;

use Test::More tests => 1;

use Path::Tiny;
use HiD;
use HiD::Generator::Sass;
use Data::Printer;

my $dest = path('t/published/');

unless ($dest->exists) {
  $dest->mkpath;
}

my $hid = HiD->new(
    source      => 't/corpus/src',
    layout_dir  => 't/corpus/layouts',
    destination => $dest->stringify,
    config => { 
      sass => {
        sass_sources => [
          't/corpus/src/sass/test.scss'
        ],
        sass_output => $dest->stringify . '/css/',
      },
    },
    plugins => [HiD::Generator::Sass->new],
);

p $hid;

# TODO will also grab the tests in t.
# but it'll do for now
$hid->publish;

my $test = $dest->child('css/test.css');

ok -e $test, "now we should have a bogus css page...";
