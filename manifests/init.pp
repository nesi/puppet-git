# Class: git
#
# This module manages git
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

# This file is part of the git Puppet module.
#
#     The git Puppet module is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     The git Puppet module is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with the git Puppet module.  If not, see <http://www.gnu.org/licenses/>.

# [Remember: No empty lines between comments and class definition]
# NeSI git module
#
# Somewhat derived from https://github.com/theforeman/puppet-git
class git(
  $ensure   = 'installed',
  $package  = $git::params::package,
  $gui      = 'absent',
  $svn      = 'installed',
  $git_root = false
) inherits git::params {

  # ensure statement for the git package overrides svn and gui ensure.
  case $ensure {
    /^installed$|^(\d+)?(\.(x|\*|\d+))?(\.(x|\*|\d+))?(|-(\S+))$/: {
      $ensure_svn = $svn
      $ensure_gui = $gui
    }
    default: {
      $ensure_svn = 'absent'
      $ensure_gui = 'absent'
    }
  }

  package{'git':
    ensure => $ensure,
    name   => $package,
  }

  package{'git-svn':
    ensure => $ensure_svn,
    name   => $git::params::svn_package,
  }

  package{'git-gui':
    ensure => $ensure_gui,
    name   => $git::params::gui_package,
  }

  # Need to consider if this should happen or not.
  # if $git_root {
  #   $root_name    = "root on ${::fqdn}"
  #   $root_email   = "root@${::fqdn}"
  #   git::user{'root':}
  # }

}
