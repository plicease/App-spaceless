package App::spaceless;

use strict;
use warnings;
use v5.10;
use Config;
use Shell::Guess;
use Shell::Config::Generate qw( win32_space_be_gone );
use Getopt::Long qw( GetOptions );
use Pod::Usage qw( pod2usage );

# ABSTRACT: Convert PATH type environment variables to spaceless versions
# VERSION

=head1 DESCRIPTION

This module provides the machinery for the L<spaceless> app, a program
that helps convert PATH style environment variables to spaceless varieties
on Windows systems (including Cygwin).

=cut

sub _running_shell
{
  state $shell;
  $shell = Shell::Guess->running_shell unless defined $shell;
  $shell;
}

sub main
{
  shift;
  local @ARGV = @_;
  my $shell;
  my $file;
  my $help;
  my $version;
  my $trim;
  my $cygwin = 1;

  GetOptions(
    'csh'       => sub { $shell = Shell::Guess->c_shell },
    'sh'        => sub { $shell = Shell::Guess->bourne_shell },
    'cmd'       => sub { $shell = Shell::Guess->cmd_shell },
    'command'   => sub { $shell = Shell::Guess->command_shell },
    'fish'      => sub { $shell = Shell::Guess->fish_shell },
    'korn'      => sub { $shell = Shell::Guess->korn_shell },
    'power'     => sub { $shell = Shell::Guess->power_shell },
    'no-cygwin' => sub { $cygwin = 0 if $^O eq 'cygwin' },
    'trim|t'    => \$trim,
    'f=s'       => \$file,
    'help|h'    => \$help,
    'version|v' => \$version,
  );

  if($help)
  {
    pod2usage({ -verbose => 2 });
  }
  
  if($version)
  {
    say 'App::spaceless version ', ($App::spaceless::VERSION // 'dev');
    return 1;
  }

  $shell = _running_shell() unless defined $shell;

  my $filter = $^O eq 'cygwin' && $shell->is_win32 ? sub { map { Cygwin::posix_to_win_path($_) } @_ } : sub { @_ };

  @ARGV = ('PATH') unless @ARGV;
  my $config = Shell::Config::Generate->new;
  $config->echo_off;
  my $sep = quotemeta $Config{path_sep};

  foreach my $var (@ARGV)
  {
    $config->set_path(
      $var => grep { $trim ? -d $_ : 1 } $filter->(win32_space_be_gone grep { $cygwin ? 1 : $_ =~ qr{^([A-Za-z]:|/cygdrive/[A-Za-z])} } split /$sep/, $ENV{$var} // '')
    );
  }

  if(defined $file)
  {
    $config->generate_file($shell, $file);
  }
  else
  {
    print $config->generate($shell);
  }
  
  return 0;
}

1;
