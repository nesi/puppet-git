# puppet-git
============

[![Build Status](https://travis-ci.org/nesi/puppet-git.png?branch=master)](https://travis-ci.org/nesi/puppet-git)

A puppet module for managing the installation and configuration of [git](http://git-scm.com/) so that it is available by use by the Puppetlabs `vcsrepo` module. This includes installing, configuring and the installation of git, the configuration of git specific settings, executing git commands, and eventually the management of git hook scripts.

**WARNING** The use of this module to manage git repositories is being depreciated and will soon become obsolete. It is recommended that the [Puppetlabs vcsrepo module](https://github.com/puppetlabs/puppetlabs-vcsrepo) is used manage repositories.

#### Implemented Features:
* Installs git from packages
* Optionally installs git-svn from packages (defaults installed)
* Optionally installs git-gui from packages (defaults not installed)

#### Features not yet updated
* Initialising user accounts with git configurations
* Configure global and local git configurations
* Executing git commands not provided by the Puppetlabs vcsrepo module.
* Injecting hook scripts into git repositories.

# Classes

## `git`

This class installs and manages the git package.

A basic install with the defaults would be:  
```puppet
include git
```

Otherwise using the parametrs:  
```puppet
class{git:
  svn => 'installed',
  gui => 'installed',
}
```

### Parameters

* **ensure**: Sets the ensure parameter passed to the git package. The default is `installed`.
* **svn**: Sets the ensure paramater passed to the git-svn package. The default is `installed`.
* **gui**: Sets the ensure parameter passed to the git-gui package. The default is `absent`.
* **package**: Specifies a custom package. The default is `git`, except for older versions of Debian and Ubuntu where the default is `git-core`.
* **git_root**: Currently does nothing, it's functionality is to be reviewed.

# Resources

## `git::user`

This basically sets the users name and email by configuring the git global variables as that user, and should allow them to use git without warnings about these values being unset. The user name should be a valid user account that has been previously defined in Puppet.

With default settings just use:  
```puppet
git::user{'username':}
```

Otherwise using parameters:  
```puppet
git::user{'username':
 user_name  => 'Some User',
 user_email => 'someuser@example.org',
}
```

### Parameters

* *user_name* sets the user's name to the specified string, and not the default of `${name} on ${fqdn}`, where fqdn is the fully qualified domain name as discovered by facter.
* *user_email* sets the user's email address to the specified string, and not the default of `${name}@${fqdn}`, where fqdn is the fully qualified domain name as discovered by facter.

## `git::config`

This resource allows puppet to manage git configurations at the system (setting defaults for all usage), global (setting defaults for all a user's repositories), and local (setting defaults for a repository). These contexts are represented by the `provider` parameter.

When setting a global config value a user is required:
```puppet
git::config{'git_core_autocrlf':
  config   => 'core.autocrlf',
  value    => 'input',
  provider => 'global',
  user     => $user
}
```

When setting a local config value a `vcsrepo` repository is required:
```puppet
git::config{'git_core_autocrlf':
  config   => 'core.autocrlf',
  value    => 'input',
  provider => 'local',
  repo     => 'reponame'
}
```

## `git::repo` 

**Using the `git::repo` class is depreciated and `vcsrepo` should be considered instead.**

This will clone a git repository from a vaild git URI to a specified path on the target server. It is **strongly** recommended that *read-only* git URIs are used. If no source is given, the target path will simply be initialised as a git repository.

With minimum parameters, should create the directory `/usr/src/repo` and run `git init` in it:  
```puppet
git::repo{'repo_name':
  path => '/usr/src/repo',
}
```

With minimum parameters to clone from a remote source:  
```puppet
git::repo{'repo_name':
 path   => '/usr/src/repo',
 source => 'git://example.org/example/repo.git'
}
```

### Parameters

* *path* sets the path where the git repository is created or cloned to
* *source* sets the git URI from which the git repository is cloned from
* *branch* this string sets a specific branch to check out
* *git_tag* this string sets a specific tag to check out
* *update* if set to true, when puppet runs it will revert any local changes and pull the current branch from the source if there is any difference between the local repository and the source repository.
*  *bare* if set to true, it creates a bare repository

**Note:** I am uncertain on how it will behave if both *tag* and *branch* are set, but *tag* should override *branch*.

# Dependencies

* [stdlib][1]
* [vcsrepo][2]

[1]:https://github.com/puppetlabs/puppetlabs-stdlib
[2]:https://github.com/puppetlabs/puppetlabs-vcsrepo

# Attribution

## puppet-blank

This module is derived from the puppet-blank module by Aaron Hicks (aethylred@gmail.com)

* https://github.com/Aethylred/puppet-blank

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

# Gnu General Public License

This file is part of the git Puppet module.

The git Puppet module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The git Puppet module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the git Puppet module.  If not, see <http://www.gnu.org/licenses/>.
