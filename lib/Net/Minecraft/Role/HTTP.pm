use v5.16;
use warnings;

package Net::Minecraft::Role::HTTP {

  # ABSTRACT: Base class for minecrafty http things.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Net::Minecraft::Role::HTTP",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

  use Moo::Role;
  use HTTP::Tiny;
  use Scalar::Util qw( blessed );

=head1 CONSTRUCTOR ARGUMENTS

This section describes arguments that may be optionally passed to L<<< C<< ->new() >>|/new >>>, but as of the time of this writing, none are explicitly required,
and are offered only to give leverage to strange usecases ( and tests )

  my $instance = _SOME_CLASS_->new(
    user_agent   => ... ,
    http_headers => { ... },
    http_engine  => HTTP::Tiny->new(),
  );

=carg user_agent

The User Agent to self-describe over HTTP

  type    : String
  default : "Net::Minecraft::Login/" . VERSION

=attr user_agent

=cut

  has user_agent => (
    is      => rwp =>,
    lazy    => 1,
    default => sub {
      my $class = $_[0];
      $class = blessed($class) if blessed($class);
      my $version = $class->VERSION;
      $version = 'DEVEL' if not defined $version;
      return sprintf q{%s/%s}, $class, $version;
    },
  );

=carg http_headers

Standard Headers that will be injected in each request

  type    : Hash[ string => string ]
  default : { 'Content-Type' => 'application/x-www-form-urlencoded' }

=attr http_headers

=cut

  has http_headers => ( is => rwp =>, lazy => 1, default => sub { { 'Content-Type' => 'application/x-www-form-urlencoded' } }, );

=carg http_engine

Low-Level HTTP Transfer Agent.

  type    : Object[ =~ HTTP::Tiny ]
  default : An HTTP::Tiny instance.

=attr http_engine

=cut

  has http_engine => ( is => rwp =>, lazy => 1, default => sub { return HTTP::Tiny->new( agent => $_[0]->user_agent ) }, );

}

1;
