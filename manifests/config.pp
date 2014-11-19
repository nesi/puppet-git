# This defines a git config statement
define git::config (
  $config   = $name,
  $value    = undef,
  $provider = 'system',
  $user     = undef,
  $repo     = undef,
) {

  if $user {
    $home = getparam(User['git'],'home')
    $environment = ["HOME=${home}"]
  } else {
    $home = undef
    $environemtn = undef
  }

  case $provider {
    'system':{
      $requires = [Package['git']]
      $cwd      = undef
      $context  = 'system'
    }
    'global','user':{
      if $user {
        $requires = [Package['git'],User[$user]]
        $cwd      = $home
        $context  = '--global'
      } else {
        fail("When using the '${provider}' provider the git::config user parameter is required.")
      }
    }
    'local','repo','repository':{
      if $repo {
        if getparam(Vcsrepo[$repo], 'provider') == 'git' {
          $requires = [Package['git'],Vcsrepo[$repo]]
          $cwd = getparam(Vcsrepo[$repo], 'path')
          $context  = '--local'
        } else {
          fail("The target vcsrepo repository '${repo}' must be using the git provider")
        }
      } else {
        fail("When using the '${provider}' provider the git::config repo parameter is required.")
      }
    }
    default: {
      fail("The privider '${provider}' is not known to git::config")
    }
  }

  $config_command = "${git::params::bin} config ${context} ${config} ${value}"
  $config_check   = "${git::params::bin} config ${context} ${config}| ${git::params::grep_cmd} '^${value}$'"

  exec{"git_config_${name}":
    command     => $config_command,
    path        => ['/bin','/usr/bin'],
    user        => $user,
    cwd         => $cwd,
    environment => $environment,
    unless      => $config_check,
    require     => $requires,
  }

}