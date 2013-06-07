
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.4003",
    "Test::Fatal" => 0,
    "Test::More" => "0.98",
    "strict" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.4003"
  },
  "dist_abstract" => "Basic implementation of the Minecraft Login Protocol.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Net-Minecraft-Login",
  "dist_version" => "0.001000",
  "license" => "perl",
  "module_name" => "Net::Minecraft::Login",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "HTTP::Tiny" => 0,
    "Moo" => 0,
    "Params::Validate" => 0,
    "Scalar::Util" => 0,
    "overload" => 0,
    "perl" => "v5.16.0",
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
