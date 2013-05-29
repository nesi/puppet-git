# Git installer manifest
# DO NOT USE DIRECTLY
#
# Use this instead:
# include git
#
# or:
# class {'git':
#   svn => true,
#   gui => true,
#}

class git::install(
  $gui,
  $svn,
  $ensure = "installed",
){
  require git::params

  if ! defined(Package[$git::params::package]) {
    package{$git::params::package: ensure => $ensure }
  }

  case $svn {
    true:    { $svn_ensure = "installed" }
    false:   { $svn_ensure = "absent" }
    default: { $svn_ensure = $svn }
  }
  package{$git::params::svn_package: ensure => $svn_ensure }

  case $gui {
    true:    { $gui_ensure = "installed" }
    false:   { $gui_ensure = "absent" }
    default: { $gui_ensure = $gui }
  }
  package{$git::params::gui_package: ensure => $gui_ensure }

  $root_name    = "root on ${::fqdn}"
  $root_email   = "root@${::fqdn}"

  git::user{'root':}

}
