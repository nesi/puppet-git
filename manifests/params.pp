# = Class: git::params
#
# Configure how the puppet git module behaves

class git::params {

  case $::operatingsystem {
    'CentOS','Ubuntu', 'Debian', 'Amazon', 'Archlinux', 'Gentoo' :{
      $svn_package  = 'git-svn'
      $gui_package  = 'git-gui'
      $bin          = '/usr/bin/git'
      if $::operatingsystem =~ /^(Debian|Ubuntu)$/ and versioncmp($::operatingsystemrelease, "12") < 0 {
        $package = 'git-core'
      }else{
         $package = 'git'
      }
    }
    default:{
      warning("git not configured for ${::operatingsystem} on ${::fqdn}")
    }
  }
}

class binaries::params {

  case $::operatingsystem {
    'CentOS','Ubuntu', 'Debian', 'Amazon', 'Gentoo' :{
      $grep_cmd = '/bin/grep'
    }
    'Archlinux' :{
      $grep_cmd = '/usr/bin/grep'
    }
    default:{
      warning("git not configured for ${::operatingsystem} on ${::fqdn}")
    }
  }
}
