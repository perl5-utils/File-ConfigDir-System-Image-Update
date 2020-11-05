#!perl

use strict;
use warnings;

use Test::More;

use Cwd            ();
use File::Basename ();
use File::Spec     ();

use File::Path qw(mkpath rmtree);

my ($test_dir, $sysupdt_state_dir, $sysupdt_vol_dir, $keep);

BEGIN
{
    defined $ENV{KEEP_TEST_OUTPUT} and $keep = $ENV{KEEP_TEST_OUTPUT};
    $test_dir = File::Spec->rel2abs(File::Spec->curdir());
    $test_dir = File::Spec->catdir($test_dir, "test_output_" . $$);

    $sysupdt_state_dir = File::Spec->catdir($test_dir, "sysupdt");
    $sysupdt_vol_dir   = File::Spec->catdir($test_dir, "sysvolatile");

    if ($^O eq "VMS")
    {
        $test_dir          = VMS::Filespec::unixify($test_dir);
        $sysupdt_state_dir = VMS::Filespec::unixify($sysupdt_state_dir);
        $sysupdt_vol_dir   = VMS::Filespec::unixify($sysupdt_vol_dir);
    }

    rmtree $test_dir;
    mkpath $_ for ($test_dir, $sysupdt_state_dir, $sysupdt_vol_dir);

    $ENV{SYSTEM_IMAGE_UPDATE_STATE_DIR}    = $sysupdt_state_dir;
    $ENV{SYSTEM_IMAGE_UPDATE_VOLATILE_DIR} = $sysupdt_vol_dir;
}

END { defined($test_dir) and rmtree $test_dir unless $keep }

use File::ConfigDir 'config_dirs';
use File::ConfigDir::System::Image::Update qw/system_image_update_state_dir system_image_update_volatile_dir/;

my @supported_functions = (qw(config_dirs system_image_update_state_dir system_image_update_volatile_dir));

my @dirs = config_dirs();
note("config_dirs: " . join(",", @dirs));
ok(scalar @dirs >= 3, "config_dirs")
  ;    # we expect system_cfg_dir + .. + system_image_update_state_dir + system_image_update_volatile_dir
is($dirs[-2], (system_image_update_state_dir)[0],    'system_image_update_state_dir');
is($dirs[-1], (system_image_update_volatile_dir)[0], 'system_image_update_volatile_dir');

is((system_image_update_state_dir)[0],    $sysupdt_state_dir, "direct system_image_update_state_dir");
is((system_image_update_volatile_dir)[0], $sysupdt_vol_dir,   "direct system_image_update_volatile_dir");

done_testing();
