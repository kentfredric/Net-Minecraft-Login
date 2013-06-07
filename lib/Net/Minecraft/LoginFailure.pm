use v5.16;
use warnings;

package Net::Minecraft::LoginFailure {
BEGIN {
  $Net::Minecraft::LoginFailure::AUTHORITY = 'cpan:KENTNL';
}

{
  $Net::Minecraft::LoginFailure::VERSION = '0.001000';
}


  # ABSTRACT: Result info for a Minecraft Login.

  use Moo;
  use Carp qw( confess );
  use Params::Validate qw( validate SCALAR );
  use overload q{""} => 'as_string';


  has code   => ( is => rwp =>, required => 1, isa => \&_defined_scalar_number );
  has reason => ( is => rwp =>, required => 1, isa => \&_defined_scalar );


  sub as_string {
    my ($self) = @_;
    return sprintf q[Login Failed: %s => %s], $self->code, $self->reason;
  }

  ## no critic ( RequireArgUnpacking RequireFinalReturn )
  sub _defined_scalar_number {
    confess q[parameter is not a defined value] unless defined $_[0];
    confess q[parameter is not a scalar] if ref $_[0];
    confess q[parameter is not a number] unless $_[0] =~ /^\d{1,3}$/;
  }

  sub _defined_scalar {
    confess q[parameter is not a defined value] unless defined $_[0];
    confess q[parameter is not a scalar] if ref $_[0];
  }
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Net::Minecraft::LoginFailure - Result info for a Minecraft Login.

=head1 VERSION

version 0.001000

=head1 CONSTRUCTOR ARGUMENTS

	my $error = Net::Minecraft::LoginFailure->new(
		code => $somecode,
		reason => $reason,
	);

This is ultimately a very low quality exception without throw on by default.

=head2 code

The HTTP Failure Code.

	type : HTTP Status Number ( ie: 000 -> 599 )

=head2 reason

The Reason given by the server for a Login Failure.

	type : String

=head1 METHODS

=head2 as_string

	overload: for ""
	returns a string description of this login failure.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
