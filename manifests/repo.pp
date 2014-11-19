# = Define a git repository as a resource
#
# == Parameters:
#
# $source::     The URI to the source of the repository
#
# $path::       The path where the repository should be cloned to, fully qualified paths are recommended, and the $owner needs write permissions.
#
# $branch::     The branch to be checked out
#
# $git_tag::    The tag to be checked out
#
# $owner::      The user who should own the repository
#
# $update::     If this is true, puppet will revert local changes and pull remote changes when it runs.
#
# $bare::       If this is true, git will create a bare repository

define git::repo(
  $path,
  $source        = false,
  $branch        = undef,
  $git_tag       = undef,
  $owner         = 'root',
  $group         = 'root',
  $update        = false,
  $bare          = false,
  $timeout       = '60',
  $suppress_warn = false
){

  require git
  require git::params

  validate_bool($bare, $update, $suppress_warn)

  if ! $suppress_warn {
    warning('The use of the git::repo resource is depreciated. Please consider using the Puppetlabs vcsrepo class.')
  }

  if $branch {
    $real_branch = $branch
  } else {
    $real_branch = 'master'
  }

  if $source {
    $init_cmd = "${git::params::bin} clone -b ${real_branch} ${source} ${path} --recursive"
  } else {
    if $bare {
      $init_cmd = "${git::params::bin} init --bare ${path}"
    } else {
      $init_cmd = "${git::params::bin} init ${path}"
    }
  }

  $creates = $bare ? {
    true    => "${path}/objects",
    default => "${path}/.git",
  }


  if ! defined(File[$path]){
    file{$path:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      recurse => true,
    }
  }

  exec {"git_repo_${name}":
    command  => $init_cmd,
    user     => $owner,
    group    => $group,
    provider => shell,
    creates  => $creates,
    require  => Package[$git::params::package],
    timeout  => $timeout,
  }

  # I think tagging works, but it's possible setting a tag and a branch will just fight.
  # It should change branches too...
  if $git_tag {
    exec {"git_${name}_co_tag":
      cwd      => $path,
      provider => shell,
      user     => $owner,
      group    => $group,
      command  => "${git::params::bin} checkout ${git_tag}",
      unless   => "${git::params::bin} describe --tag|${git::params::grep_cmd} -P '${git_tag}'",
      require  => Exec["git_repo_${name}"],
    }
  } elsif ! $bare {
    exec {"git_${name}_co_branch":
      cwd      => $path,
      provider => shell,
      user     => $owner,
      group    => $group,
      command  => "${git::params::bin} checkout ${real_branch}",
      unless   => "${git::params::bin} branch|${git::params::grep_cmd} -P '\\* ${real_branch}'",
      require  => Exec["git_repo_${name}"],
    }
    if $update {
      exec {"git_${name}_pull":
        cwd      => $path,
        provider => shell,
        user     => $owner,
        group    => $group,
        command  => "${git::params::bin} reset --hard origin/${real_branch}",
        unless   => "${git::params::bin} fetch && ${git::params::bin} diff origin/${real_branch} --no-color --exit-code",
        require  => Exec["git_repo_${name}"],
      }
    }
  }
}
