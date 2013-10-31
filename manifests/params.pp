# = Class: git::params
#
# Configure how the puppet git module behaves

class git::params {

  # Common variables:
  $svn_package  = 'git-svn'
  $gui_package  = 'git-gui'
  $bin          = '/usr/bin/git'
  $su_cmd       = '/bin/su'

  case $::osfamily {
    Debian: {
      if $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '11') < 0 {
        $package = 'git-core'
      }else{
        $package = 'git'
      }
      $grep_cmd =  '/bin/grep'
    }
    RedHat: {
      $package = 'git'
      $grep_cmd = '/bin/grep'
    }
    ArchLinux:{
      $package = 'git'
      $grep_cmd = '/usr/bin/grep'
    }
    default:{
      fail("The NeSI Git Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
