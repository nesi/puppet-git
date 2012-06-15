# Define a git user resource

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

	$git_email = $email ? {
		false		=> "${name}@${fqdn}",
		default => $user_email,
	}

	exec{"${name}_git_name":
		user 		=> $user,
		command => "${git::params::bin} config --global user.name '${git_name}'",
		unless	=> "${git::params::bin} config --global user.name|grep '${git_name}'",
		require => [Package[$git::params::package],User[$user]],
	}

	exec{"${name}_git_email":
		user 		=> root,
		command => "${git::params::bin} config --global user.email '${git_email}'",
		unless	=> "${git::params::bin} config --global user.email|grep '${git_email}'",
		require => [Package[$git::params::package],User[$user]],
	}

}