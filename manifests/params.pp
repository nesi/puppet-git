# = Class: git::params
#
# Configure how the puppet git module behaves

class git::params {

  case $::operatingsystem {
    'Scientific','CentOS','Ubuntu','Debian','Amazon','Archlinux','Gentoo','Fedora' :{
      $svn_package  = 'git-svn'
      $gui_package  = 'git-gui'
      $bin          = '/usr/bin/git'
      $su_cmd       = '/bin/su'
      if $::operatingsystem =~ /^(Debian|Ubuntu)$/ and versioncmp($::operatingsystemrelease, "12") < 0 {
        $package = 'git-core'
      }else{
         $package = 'git'
      }
      $grep_cmd = $::operatingsystem ? {
        Archlinux => '/usr/bin/grep',
        default   => '/bin/grep'
      }
    }
    default:{
      warning("git not configured for ${::operatingsystem} on ${::fqdn}")
    }
  }
}
