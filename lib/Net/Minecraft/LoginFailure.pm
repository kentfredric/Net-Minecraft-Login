use v5.16;
use warnings;

package Net::Minecraft::LoginFailure {

  # ABSTRACT: Result info for a Minecraft Login.

  use Moo;
  with 'Net::Minecraft::Role::LoginResult';

  use Carp qw( confess );
  use Params::Validate qw( validate SCALAR );
  use overload q{""} => 'as_string';

=method is_success

Always returns a false value for instances of this class.

=cut

  sub is_success { return; }

=begin MetaPOD::JSON v1.0.0

{
    "namespace":"Net::Minecraft::LoginFailure",
    "inherits":"Moo::Object",
    "does":"Net::Minecraft::Role::LoginResult"
}

=end MetaPOD::JSON

=head1 CONSTRUCTOR ARGUMENTS

	my $error = Net::Minecraft::LoginFailure->new(
		code => $somecode,
		reason => $reason,
	);

This is ultimately a very low quality exception without throw on by default.

=carg code

The HTTP Failure Code.

	type : HTTP Status Number ( ie: 000 -> 599 )

=carg reason

The Reason given by the server for a Login Failure.

	type : String

=cut

  has code   => ( is => rwp =>, required => 1, isa => \&_defined_scalar_number );
  has reason => ( is => rwp =>, required => 1, isa => \&_defined_scalar );

=method as_string

	overload: for ""
	returns a string description of this login failure.

=cut

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
