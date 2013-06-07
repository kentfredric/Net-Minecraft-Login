use v5.16;
use warnings;

package Net::Minecraft::Role::LoginResult {

  # ABSTRACT: Generic login result role

=begin MetaPOD::JSON v1.0.0

{
    "namespace":"Net::Minecraft::Role::LoginResult"
}

=end MetaPOD::JSON

=cut

  use Moo::Role;

  requires 'is_success';
}

1;
