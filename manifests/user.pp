# = Define a git user resource
# 
# At the moment this:
# - Sets the git global user.name
# - Sets the git global user.email
#
# == Parameters:
#
# $user_name::		The proper name for the user
# $user_email::		The email address for the user
#
# == Usage:
#
# git::user{'somebody':
#   user_name		=> 'Mr. Some Body',
#   user_email 	=> 's.body@example.org',
# }

define git::user(
	$user_name	= false,
	$user_email = false
){
	require git
	require git::params

	$git_name = $user_name ? {
		false 	=> "${name} on ${fqdn}",
		default => $user_name,
	}

	$git_email = $user_email ? {
		false		=> "${name}@${fqdn}",
		default => $user_email,
	}

	exec{"${name}_git_name":
		user 		=> $user,
		command => "${git::params::bin} config --global user.name '${git_name}'",
		unless	=> "${git::params::bin} config --global user.name|/bin/grep '${git_name}'",
		require => [Package[$git::params::package]],
	}

	exec{"${name}_git_email":
		user 		=> root,
		command => "${git::params::bin} config --global user.email '${git_email}'",
		unless	=> "${git::params::bin} config --global user.email|/bin/grep '${git_email}'",
		require => [Package[$git::params::package]],
	}

}