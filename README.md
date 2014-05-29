# spaceless

Convert PATH type environment variables to spaceless versions

# SYNOPSIS

Convert PATH (by default):

    cygwin% spaceless
    PATH=/usr/bin:/cygdrive/c/PROGRA~2/NVIDIA~1/PhysX/Common:...
    export PATH

Convert another PATH style environment variable

    cygwin% spaceless PERL5LIB
    PERL5LIB=/PERL~1/lib:/PERL~2/lib
    export PERL5LIB

Update the PATH in the current shell (works with both sh and csh):

    cygwin% eval `spaceless PATH`

Same thing from `cmd.exe` or `command.com` prompt:

    C:\> spaceless PATH -f path.bat
    C:\> path.bat

# DESCRIPTION

`spaceless` converts PATH style environment variables on windows into equivalents
that do not have spaces.  By default it uses [Shell::Guess](https://metacpan.org/pod/Shell::Guess) to make a reasonable
guess as to the shell you are currently using (not your login shell).  You may
alternately specify a specific shell type using one of the options below.

This may be useful if you have tools that require PATH style environment variables
not include spaces.

# OPTIONS

## --cmd

Generate cmd.exe configuration

## --command

Generate command.com configuration

## --csh

Generate c shell configuration

## -f _filename_

Write configuration to _filename_ instead of standard output

## --expand | -x

Expand short paths to long paths (adding any spaces that may be back in)

## --fish

Generate fish shell configuration

## --help

Print help message and exit

## --korn

Generate korn shell configuration

## --list | -l

Instead of generating a shell configuration, list the directories
in the given path style variable

## --login

Use the your default login shell (as determined by [Shell::Guess](https://metacpan.org/pod/Shell::Guess))
On Unix style systems this consults the `GECOS` field in the
`/etc/passwd` file or uses NIS.  On other platforms it may use
another means to determine your login shell, or simply make an
informed guess based on the platform.

## --no-cygwin

Remove any cygwin paths.  Has no affect on non cygwin platforms.

## --power

Generate Power shell configuration

## --sh

Generate bourne shell configuration

## --trim | -t

Trim non-existing directories.  This is a good idea since such directories can 
sometimes cause [spaceless](https://metacpan.org/pod/spaceless) to die.

## --version | v

Print version number and exit

# EXAMPLES

## Removing spaces from the PATH on Cygwin

My motivation for writing this script was trying to get [perlbrew](https://metacpan.org/pod/perlbrew) to work on Cygwin.
Since Windows frequently includes spaces in its `%PATH%` environment variable, and
cygwin inherits them.

    xian-x86_64% source ~/perl5/perlbrew/etc/cshrc
    setenv: Too many arguments.
    xian-x86_64% eval `spaceless PATH`
    xian-x86_64% source ~/perl5/perlbrew/etc/cshrc
    xian-x86_64%

I could have manually updated my `%PATH%` to not include spaces, or better yet submitted
a patch to [perlbrew](https://metacpan.org/pod/perlbrew) to fix its spacing problem.  This probably won't be the last script
that I will have the spaces in the `%PATH%` problem with.

## Visualizing the PATH

Reading the `%PATH%` variable can be difficult, especially if you have already
removed the spaces and are using the short version.

    C:\> echo %PATH%
    N:\lang\perl\strawberry\x86\5.18.2\c\bin;N:\lang\perl\strawberry
    \x86\5.18.2\perl\site\bin;N:\lang\perl\strawberry\x86\5.18.2\per
    l\bin;n:\program32\GnuWin32\bin;C:\PROGRA~2\NVIDIA~1\PhysX\Commo
    n;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Win
    dows\System32\WindowsPowerShell\v1.0\;C:\PROGRA~1\MICROS~3\110\T
    ools\Binn\;C:\PROGRA~2\Git\cmd;N:\lang\tcl\x86\8.6.1.0\bin;C:\PR
    OGRA~2\NVIDIA~1\PhysX\Common;C:\PROGRA~2\Intel\ICLSCL~1\;C:\PROG
    RA~1\Intel\ICLSCL~1\;C:\Windows\system32;C:\Windows;C:\Windows\S
    ystem32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;

You can use the `-l` (short for `--list`) and `-x` (short for `--expand`) options to
make it a little more readable

    C:\> spaceless -l -x
    N:\lang\perl\strawberry\x86\5.18.2\c\bin
    N:\lang\perl\strawberry\x86\5.18.2\perl\site\bin
    N:\lang\perl\strawberry\x86\5.18.2\perl\bin
    N:\program32\GnuWin32\bin
    C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common
    ...

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
