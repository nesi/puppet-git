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
  $source   = false,
  $branch   = undef,
  $git_tag  = undef,
  $owner    = 'root',
  $group    = 'root',
  $update   = false,
  $bare     = false
){

  require git
  require git::params

  validate_bool($bare, $update)

  if $owner != 'root' {
    $su_do  = "${git::params::su_cmd} -l ${owner} -c \""
    $su_end = "\""
  } else {
    $su_do  = ''
    $su_end = ''
  }

  if $branch {
    $real_branch = $branch
  } else {
    $real_branch = 'master'
  }

  if $source {
    $init_cmd = "${su_do}${git::params::bin} clone -b ${real_branch} ${source} ${path} --recursive${su_end}"
  } else {
    if $bare {
      $init_cmd = "${su_do}${git::params::bin} init --bare ${path}${su_end}"
    } else {
      $init_cmd = "${su_do}${git::params::bin} init ${path}${su_end}"
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
      recurse => true,
    }
  }

  exec {"git_repo_${name}":
    command   => $init_cmd,
    user      => $owner,
    provider  => shell,
    creates   => $creates,
    require   => Package[$git::params::package],
    timeout   => 600,
  }

  # I think tagging works, but it's possible setting a tag and a branch will just fight.
  # It should change branches too...
  if $git_tag {
    exec {"git_${name}_co_tag":
      cwd       => $path,
      provider  => shell,
      command   => "${su_do}${git::params::bin} checkout ${git_tag}${su_end}",
      unless    => "${su_do}${git::params::bin} describe --tag|${git::params::grep_cmd} -P '${git_tag}'${su_end}",
      require   => Exec["git_repo_${name}"],
    }
  } elsif ! $bare {
    exec {"git_${name}_co_branch":
      cwd       => $path,
      provider  => shell,
      command   => "${su_do}${git::params::bin} checkout ${branch}${su_end}",
      unless    => "${su_do}${git::params::bin} branch|${git::params::grep_cmd} -P '\\* ${branch}'${su_end}",
      require   => Exec["git_repo_${name}"],
    }
    if $update {
      exec {"git_${name}_pull":
        cwd       => $path,
        provider  => shell,
        command   => "${su_do}${git::params::bin} reset --hard origin/${branch}${su_end}",
        unless    => "${su_do}${git::params::bin} fetch && ${git::params::bin} diff origin/${branch} --no-color --exit-code${su_end}",
        require   => Exec["git_repo_${name}"],
      }
    }
  }
}
