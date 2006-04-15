package PPT;
use strict;
use warnings;

use base 'Exporter';
my @all = qw(
      basename
      copy
      cwd
      date
      dirname
      fileparse
      find
      move
      rm
      rmtree
      );

our @EXPORT_OK = @all;
our %EXPORT_TAGS = (
    all => \@all,
);

our $VERSION = '0.01';

my @DIRS; # used to implement pushd/popd

sub _not_implemented {
  die "Not implemented\n";
}
=head1 NAME

PPT - UNIX tools implemented as Perl Modules

=head1 SYNOPSIS

use PPT qw(:all);

my $str = cut {bytes => "3-7"}, "123456789";

=head1 WARNING

This is Alpha version of the module.
Interface of the functions will change and some of the functions might even disappear.

=head1 REASON

Why this module?

=over 4

=item *

When I am writing filesystem related applications I always need to load several 
standard modules such as File::Basename, Cwd, File::Copy, File::Path and maybe 
others in order to have all the relevant functions. 
I'd rather just use one module that will bring all the necessary functions.

=item *

On the other hand when I am in OOP mood I want all these functions to be methods of
a shell-programming-object.

=item *

There are many useful commands available for the Unix Shell Programmer that usually need
much more coding than the Unix counterpart, specifically most of the Unix commands can work
recoursively on directory structures while in Perl one has to implement these.
There are some additional modules providing this functionality but then we get back again to
the previous issue.

=back

The goal of this module is to make it even easier to write scripts in Perl that
were traditionally easier to write in Shell.

Partially we will provide functions similar to existing UNIX commands 
and partially we will provide explanation on how rewrite various Shell 
constructs in Perl.

If you are interested in UNIX Reconstruction Project, that was originally called ppt 
but its goals are different. http://search.cpan.org/dist/ppt/

=head1 DESCRIPTTION

=head2 awk

Not implemented.

=cut
sub awk {
  _not_implemented();
}


=head2 basename

Given a path to a file or directory returns the last part of the path.

See L<File::Basename> for details.

=cut
sub basename {
  require File::Basename;
  File::Basename::basename(@_);
}

=head2 cat

Not implemented.

Slurp mode to read in a file:

 my $content;
 if (open my $fh, "<", "filename") {
   local $/ = undef;
   $content = <$fh>;
 }

To process all the files on the command line and print them to the screen.

 while (my $line = <>) {
   print $line;
 }

In shell cut is usually used to concatenate two or more files. That can be achived
with the previous code redirecting it to a file using > command line redirector.

=cut
sub cat {
  _not_implemented();
}


=head2 cd

Use the built in chdir command.

=cut




=head2 chmod

For now use the built in chmod command.

It does not accept any parameters and instead of the a+w strings one has to give the exact octet:

 chmod 0755, @files;

For recursive application use the L<find> function.

 find( sub {chmod $mode, $_}, @dirs);

Later we will let user use the a+w string used with the unix command.

=cut



=head2 chown

For now use the built in chown command.

It accepts only UID and GID values, but it is easy to retreive them: 

 chown $uid, $gid, @files;
 chown getpwnam($user), getgrname($group), @files;

For recursive application use the L<find> function.

 find( sub {chown $uid, $gid, $_}, @dirs);

=cut




=head2 cmp

Not implemented.

See L<File::Compare>

=cut



=head2 compress

Not implemented.

See some of the external modules

=cut




=head2 copy

Copy one file to another name.

For details see L<File::Copy>

For now this does not provide recourseive copy. Later we will provide that
too using either one of these modules: L<File::NCopy> or L<File::Copy::Recursive>.

=cut
sub copy {
  require File::Copy;
  File::Copy::copy(@_);
} 


=head2 cut

Partially implemented but probably will be removed.

Returns some of the fields of a given string (or strings).
As a UNIX command it can work on every line on STDIN or in a list of files.
When implementing it in Perl the most difficult part is to parse the parameters
in order to account for all the overlapping possibilities which should actually
be considered as user error.

  cut -b 1 file
  cut -b 3,7 file
  cut -b 3-7 file
  cut -b -4,7-
  order within the parameter string does not matter

The same can be done in Perl for any single range:
  substr $str, $start, $length;

=cut
sub cut {
# --bytes
# --characters
# --fields
# --delimiter (in case --fields was used, defaults to TAB)
  my ($args, $str) = @_;
  if ($args->{bytes}) {
    my $chars;
    my @ranges = split /,/, $args->{bytes};
    my %chars;
    foreach my $range (@ranges) {
      if ($range =~ /^-/) {
        $range = "1$range";
      } elsif ($range =~ /-$/) {
        $range = $range . length($str)-1;
      }
      if ($range =~ /-/) {
        my ($start, $end) = split /-/, $range;
        $chars{$_}=1 for $start..$end;
      } else {
        $chars{$range} = 1;
      }
    }
    my $ret = "";
    foreach my $c (sort {$a <=> $b} keys %chars) {
      $ret .= substr($str, $c-1, 1);
    }
    return $ret;
  }

  return;
}

=head2 cp

See L<copy> instead.

=cut


=head2 cwd

Returns the current working directory similar to the pwd UNIX command.

See L<Cwd> for details.

=cut
sub cwd {
  require Cwd;
  Cwd::cwd();
}

=head2 date

Can be used to display time in the same formats the date command would do.

See POSIX::strftime for details.

=cut
sub date {
  require POSIX;
  POSIX::strftime(@_);
}

=head2 df

Not implemented.

=cut
sub df {
  _not_implemented();
}

=head2 diff

Not implemented.

See L<Text::Diff> for a possible implementation.

=cut
sub diff {
  _not_implemented();
}

=head2 dirname

Given a path to a file or a directory this function returns the directory part.
(the whole string excpet the last part)

See L<File::Basename> for details.

=cut
sub dirname {
  require File::Basename;
  File::Basename::dirname(@_);
}

=head2 dirs

Not implemented.

=cut



=head2 dos2unix

Not implemented.

=cut



=head2 du

Not implemented.

=cut


=head2 echo

Not implemented.

The print function in Perl prints to the screen (STDOUT or STDERR).

If the given string is in double quotes "" the backslash-escaped characters take effect (-e mode).

Within single quotes '', they don't have an effect.

For printing new-line include \n withn the double quotes.

=cut



=head2 ed - editor

Not implemented.

=cut



=head2 expr

Not implemented.

In Perl there is no need to use a special function to evaluate an expression.

=head3 match

=head3 substr - built in substr

=head3 index - built in index

=head3 length - built in length

=cut



=head2 file

Not implemented.

=cut



=head2 fileparse

This is not a UNIX command but it is provided by the same standard L<File::Basename>
we already use.

=cut
sub fileparse {
  require File::Basename;
  File::Basename::fileparse(@_);
}



=head2 find

See L<File::Find> for details.

See also find2perl

=cut
sub find {
  require File::Find;
  File::Find::find(@_);
}



=head2 move

Move a file from one directory to any other directory with any name.

One can use the built in rename function but it only works on the same filesystem. 

See L<File::Copy> for details.

=cut
sub move {
  require File::Copy;
  File::Copy::move(@_);
}



=head2 getopts

Not implemented.

See L<Getops::Std> and L<Getops::Long> for possible implementations we will use here.

=cut




=head2 grep

Not implemented.

A basic implementation of grep in Perl would be the following code:

 my $p = shift;
 while (<>) {
   print if /$p/
 }

but within real code we are going to be more interested doing such operation
on a list of values (possibly file lines) already in memory in an array or
piped in from an external file. For this one can use the grep build in function.

 @selected = grep /REGEX/, @original;

=cut



=head2 gzip


Not implemented.

=cut



=head2 head

Not implemented.

=cut


=head2 id

Normally the id command shows the current username, userid, group and gid. 
In Perl one can access the current ireal UID as $<  and the effective UID as $>.
The real GID is $(  and the effective GID is $) of the current user.

To get the username and the group name use the getpwuid($uid) and getpwgrid($gid) 
functions respectively in scalar context.


=cut


=head2 kill

See built in kill function.

=cut



=head2 less

Not implemented.

This is used in interactive mode only. No need to provide this functionality here.

=cut


=head2 ln

Not implemented.

See the build in L<link> and L<symlink> functions.

=cut


=head2 ls

Not implemented.

See glob and the opendir/readdir pair for listing filenames
use stat and lstat to retreive information needed for the -l 
display mode of ls.

=cut



=head2 mail

Sending e-mails.

=cut
sub mail {
  require Mail::Sendmail;
  Mail::Sendmail::sendmail(@_);
}


=head2 mkdir

Not implemented.

See the built in mkdir function.

See also L<mkpath>

=cut



=head2 more

Not implemented.

This is used in interactive mode only. No need to provide this functionality here.

=cut


=head2 mv

See L<move> instead.

=cut


=head2 paste

Not implemented.

=cut


=head2 patch

Not implemented.

=cut


=head2 popd

Change directory to last place where pushd was called.

=cut
sub popd {
  my ($dir) = @_;
  my $d = pop @DIRS;
  chdir $d;
}

=head2 pushd

Change directory and save the current directory in a stack. See also L<popd>.

=cut
sub pushd {
  my ($dir) = @_;
  push @DIRS, cwd;
  chdir $dir;
}

=head2 printf

Not implemented.

See the build in L<printf> function.

=cut


=head2 ps

Not implemented.

=cut



=head2 pwd

See <cwd> instead.

=cut



=head2 read

Not implemented.

 read x y z

will read in a line from the keyboard (STDIN) and put the first word into x,
the second word in y and the third word in z

In perl one can implement similar behavior by the following code:

 my ($x, $y, $z) = split /\s+/, <STDIN>;

=cut



=head2 rm

Not implemented.

For removing files, see the built in L<unlink> function.

For removing directories see the built in L<rmdir> function.

For removing trees (rm -r) see L<rmtree>

=cut
sub rm {
  _not_implemented();
}





=head2 rmdir

Not implemented.

For removing empty directories use the built in rmdir function.

For removing tree see L<rmtree>

=cut




=head2 rmtree

Removes a whole directory tree. Similar to rm -rf.
See also L<File::Path>

=cut
sub rmtree {
  require File::Path;
  File::Path::rmtree(@_);
}

=head2 sed

Not implemented.

=cut
sub sed {
  _not_implemented();
}



=head2 shift

Not implemented.

=cut



=head2 sort

Not implemented.

See the built in sort function.

=cut




=head2 tail

Not implemented.

Return the last n lines of a file, n defaults to 10

=cut
sub tail {
  _not_implemented();
}


=head2 tar

Not implemented.

See L<Archive::Tar>

=cut


=head2 touch

Not implemented.

=head2 tr

Not implemented.

See the built in L<tr> function.


=head2 umask

Not implemented.

=cut


=head2 uniq

Not implemented.

The below example ireally returns the uniq values and not as the unix command that 
returns uniq sections. so     a  a a b a a a    would return     a b a in UNIX but not here.

  sub uniq {
    my @uniq;
    my %seen;
    for (@_) {
      push @uniq, $_ if not $seen{$_}++;
    }
    return @uniq;
  }
=cut


=head2 unix2dos

Not implemented.

=head2 wc

Not implemented.

=head2 who

Not implemented.

=head2 who am i

Not implemented.

=head2 zip

Not implemented.


=head2 redirections and pipe

<
>
<
|

Ctr-Z, & fg, bg
set %ENV

=head2 Arguments

$#, $*, $1, $2, ...

$$ - is also available in Perl as $$

=head2 Other

$? error code of last command

if test ...
string operators


=head1 Development

The Subversion repository is here: http://svn1.hostlocal.com/szabgab/trunk/PPT/

=head1 AUTHOR

Gabor Szabo <gabor@pti.co.il>

=head1 Copyright

Copyright 2006 by Gabor Szabo <gabor@pti.co.il>.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=head1 SEE ALSO

Tim Maher has a book called Miniperl http://books.perl.org/book/240 that might be very useful.
I have not seen it yet, but according to what I know about it it should be a good one.

=cut

1;