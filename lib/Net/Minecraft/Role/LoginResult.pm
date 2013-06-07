use v5.16;
use warnings;

package Net::Minecraft::Role::LoginResult {

  # ABSTRACT: Generic login result role


  use Moo::Role;

  requires 'is_success';
}

1;
BEGIN {
  $Net::Minecraft::Role::LoginResult::AUTHORITY = 'cpan:KENTNL';
}
{
  $Net::Minecraft::Role::LoginResult::VERSION = '0.001001';
}

__END__

=pod

=encoding utf-8

=head1 NAME

Net::Minecraft::Role::LoginResult - Generic login result role

=head1 VERSION

version 0.001001

=begin MetaPOD::JSON v1.0.0

{
    "namespace":"Net::Minecraft::Role::LoginResult"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
