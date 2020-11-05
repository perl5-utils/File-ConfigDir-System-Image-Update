package File::ConfigDir::System::Image::Update;

use 5.008;

use strict;
use warnings FATAL => 'all';

use base qw(Exporter);

use Carp qw(croak);
use Cwd             ();
use Exporter        ();
use File::Basename  ();
use File::Spec      ();
use File::ConfigDir ();

=head1 NAME

File::ConfigDir::System::Image::Update - System::Image::Update plugin for File::ConfigDir

=cut

our $VERSION     = '0.001';
our @EXPORT_OK   = (qw(system_image_update_state_dir system_image_update_volatile_dir),);
our %EXPORT_TAGS = (
    ALL => [@EXPORT_OK],
);

=head1 SYNOPSIS

    use File::ConfigFir 'config_dirs';
    use File::ConfigDir::System::Image::Update;

    my @dirs = config_dirs();
    my @foos = config_dirs('foo');

Of course, in edge case you need to figure out the dedicated configuration
locations:

    use File::ConfigDir::Plack qw/plack_app_dir plack_env_dir/;

    # remember - directory source functions always return lists, even
    #            only one entry is in there
    my @sysupdt_state_dir = system_image_update_state_dir;
    my @sysupdt_vol_dir = system_image_update_volatile_dir;
    my @sysupdt_vol_foo_dir = system_image_update_volatile_dir('foo');

=head1 DESCRIPTION

File::ConfigDir::System::Image::Update works as plugin for L<File::ConfigDir>
to find configurations directories for updaters of embedded environments.
This requires the environment variable C<SYSTEM_IMAGE_UPDATE_STATE_DIR> and/or
C<SYSTEM_IMAGE_UPDATE_VOLATILE_DIR> being set.

=head1 EXPORT

This module doesn't export anything by default. You have to request any
desired explicitly.

=head1 SUBROUTINES

=head2 system_image_update_state_dir

Returns the configuration directory of C<SYSTEM_IMAGE_UPDATE_STATE_DIR>.

For backwards compatibility, a sane amount of time, C<SYSTEM_IMAGE_UPDATE_DIR>
is used unless C<SYSTEM_IMAGE_UPDATE_STATE_DIR> is available.

=cut

my $system_image_update_state_dir = sub {
    my @dirs;

    defined $ENV{SYSTEM_IMAGE_UPDATE_STATE_DIR}
      and -d $ENV{SYSTEM_IMAGE_UPDATE_STATE_DIR}
      and push @dirs, $ENV{SYSTEM_IMAGE_UPDATE_STATE_DIR}
      and return @dirs;

    # mind: there is no else after return
    defined $ENV{SYSTEM_IMAGE_UPDATE_DIR} and -d $ENV{SYSTEM_IMAGE_UPDATE_DIR} and push @dirs, $ENV{SYSTEM_IMAGE_UPDATE_DIR};

    return @dirs;
};

sub system_image_update_state_dir
{
    my @cfg_base = @_;
    0 == scalar(@cfg_base)
      or croak "system_image_update_state_dir(), not system_image_update_state_dir("
      . join(",", ("\$") x scalar(@cfg_base)) . ")";
    return $system_image_update_state_dir->();
}

=head2 system_image_update_volatile_dir

Returns the configuration directory of C<SYSTEM_IMAGE_UPDATE_VOLATILE_DIR>.

=cut

my $system_image_update_volatile_dir = sub {
    my @cfg_base = @_;
    my @dirs;

    defined $ENV{SYSTEM_IMAGE_UPDATE_VOLATILE_DIR}
      and -d $ENV{SYSTEM_IMAGE_UPDATE_VOLATILE_DIR}
      and push @dirs, $ENV{SYSTEM_IMAGE_UPDATE_VOLATILE_DIR};

    return @dirs;
};

sub system_image_update_volatile_dir
{
    my @cfg_base = @_;
    0 == scalar(@cfg_base)
      or croak "system_image_update_dir(), not system_image_update_dir(" . join(",", ("\$") x scalar(@cfg_base)) . ")";
    return $system_image_update_volatile_dir->();
}

my $registered;
File::ConfigDir->can("_plug_dir_source")->($system_image_update_state_dir)
  and File::ConfigDir->can("_plug_dir_source")->($system_image_update_volatile_dir)
  unless $registered++;

=head1 AUTHOR

Jens Rehsack, C<< <rehsack at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-File-ConfigDir-System-Image-Update at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-ConfigDir-System-Image-Update>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::ConfigDir::System::Image::Update

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-ConfigDir-System-Image-Update>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-ConfigDir-System-Image-Update>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/File-ConfigDir-System-Image-Update>

=item * Search CPAN

L<http://search.cpan.org/dist/File-ConfigDir-System-Image-Update/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Jens Rehsack.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;    # End of File::ConfigDir::System::Image::Update
