# = Define a git repository as a resource
#
# == Parameters:
#
# $source::			The URI to the source of the repository
#
# $path::				The path where the repository should be cloned to, fully qualified paths are recommended, and the $owner needs write permissions.
# 
# $checkout::		The branch or tag to be checked out
#
# $owner::			The user who should own the repository
# 
# $update::			If this is true, puppet will pull any changes when it runs.
#
# $bare::				If this is true, git will create a bare repository

define git::repo(
	$path,
	$source		= false,
	$checkout	= 'master',
	$owner		= 'root',
	$update		= false,
	$bare			= false
){
	
	require git
	require git::params

	if $source {
		$init_cmd = "${git::params::bin} clone ${source} ${path} --recursive"
	} else {
		if $bare {
			$init_cmd = "${git::params::bin} init --bare ${target}"
    } else {
      $init_cmd = "${git::params::bin} init ${target}"
    }
	}

	$creates = $bare ? {
		true		=> "${path}/objects",
		default	=> "${path}/.git",
	}

	exec {"git_repo_${name}":
		user 		=> root,
		command	=> $init_cmd,
		creates	=> $creates,
		require => Package[$git::params::package],
	}

	file {$path:
		owner		=> $user,
		recurse => true,
		require => Exec["git_repo_${name}"],
	}

}