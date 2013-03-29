# = Class: git::params
#
# Configure how the puppet git module behaves

class git::params {

  case $::operatingsystem {
    'CentOS','Ubuntu', 'Debian', 'Amazon', 'Archlinux' :{
      $package      = 'git'
      $svn_package  = 'git-svn'
      $gui_package  = 'git-gui'
      $bin          = '/usr/bin/git'
    }
    default:{
      warning("git not configured for ${::operatingsystem} on ${::fqdn}")
    }
  }
}

class binaries::params {

  case $::operatingsystem {
    'CentOS','Ubuntu', 'Debian', 'Amazon' :{
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
