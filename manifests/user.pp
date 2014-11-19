# = Define a git user resource
#
# This uses git::config to set up a git user's basic config.
#
# == Parameters:
#
# $user_name::    The proper name for the user
# $user_email::   The email address for the user
#
# == Usage:
#
# git::user{'somebody':
#   user_name   => 'Mr. Some Body',
#   user_email  => 's.body@example.org',
# }

define git::user(
  $user       = $name,
  $user_name  = false,
  $user_email = false
){
  require git
  require git::params

  $git_name = $user_name ? {
    false   => "${user} on ${::fqdn}",
    default => $user_name,
  }

  $git_email = $user_email ? {
    false   => "${user}@${::fqdn}",
    default => $user_email,
  }

  git::config{"${user}_name":
    config   => 'user.name',
    value    => $git_name,
    provider => 'global',
    user     => $user,
  }

  git::config{"${user}_email":
    config   => 'user.email',
    value    => $git_email,
    provider => 'global',
    user     => $user,
  }

}
