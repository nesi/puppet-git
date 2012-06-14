# Git installer manifest
# DO NOT USE DIRECTLY
#
# Use this instead:
# include git
#
# or:
# class {'git':
#		svn => true,
#   gui => true,
#} 

class git::install(
	$gui,
	$svn
){
	require git::params

	package{$git::params::package: ensure => installed}

	if $svn {
		package{$git::params::svn_package: ensure => installed}
	} else {
		package{$git::params::svn_package: ensure => absent}
	}

	if $gui {
		package{$git::params::gui_package: ensure => installed}
	} else {
		package{$git::params::gui_package: ensure => absent}
	}

	$root_name 		= "root on ${fqdn}"
	$root_email		= "root@${fqdn}"

	exec{'git_root_name':
		user 		=> root,
		command => "${git::params::bin} config --global user.name '${root_name}'",
		unless	=> "${git::params::bin} config --global user.name|grep '${root_name}'",
		require => Package[$git::params::package],
	}

	exec{'git_root_email':
		user 		=> root,
		command => "${git::params::bin} config --global user.email '${root_email}'",
		unless	=> "${git::params::bin} config --global user.email|grep ${root_email}",
		require => Package[$git::params::package],
	}

}