# Define a git user resource

define git::user(
	$user,
	$name 	= false,
	$email 	= false
){
	require git
	require git::params
	require User[$user]

	$git_name = $name ? {
		false 	=> "${user} on ${fqdn}",
		default => $name,
	}

	$git_email = $email ? {
		false		=> "${user}@${fqdn}",
		default => $email,
	}

	exec{'git_name':
		user 		=> $user,
		command => "${git::params::bin} config --global user.name '${git_name}'",
		unless	=> "${git::params::bin} config --global user.name|grep '${git_name}'",
		require => [Package[$git::params::package],User[$user]],
	}

	exec{'git_email':
		user 		=> root,
		command => "${git::params::bin} config --global user.email '${git_email}'",
		unless	=> "${git::params::bin} config --global user.email|grep '${git_email}'",
		require => [Package[$git::params::package],User[$user]],
	}

}