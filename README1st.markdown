# blank

This is a blank puppet module.

# Usage

Use this module to start a new blank puppet module with all the required components ready for submitting to Puppet Forge.

## Create a new blank module

1. Clone this repository:

	```
	git clone -o puppet-blank -b master git://github.com/Aethylred/puppet-blank.git /path/to/new/repository
	```
1. Use the `unblank.ps1` script to customise the blank template
1. Delete clean up blank with `cleanup.ps1`
1. Commit changes
1. Add a new `origin` remote:

	```
	git remote add origin git@a.git.repo:reponame.git
	```
1. Push your changes:

	```
	git push origin master
	```

## Windows scripts

Provided are some Powershell scripts that can be used to manage the blank puppet module template.

## Enable execution of unsigned scripts

Powershell will not run unsigned scripts by default, this can be enabled by executing the following command in an Administrator Powershell. This is required before any of the other powershell scripts will run.

1. Click *Start* menu
2. Type "powershell" in the *Search programs and files* box, do not press enter.
3. When *Powershell* shows up in the search results, right click and select *Run as administrator*
4. Windows UAC may ask for permission to run as an administrator, click *Yes*
5. Run the following command in the administrator PowerShell:

	```
	set-executionpolicy remotesigned
	```
6. Press *Enter* again to confirm the policy change

**NOTE:** You may need to repeat this in both PowerShell and PowerShell (x86) on 64-bit systems.

## Change author and module

This updates the author and module name using the `.orig` templates. This script can be re-run, creating new templates. This may not be advisable in later stages of module development.

1. Start Powershell in the blank module directory
2. Run the `unblank.ps1` script:

	```
	.\unblank.ps1 newauthor newmodule
	```
3. Add the newly created files to the git version control:

	```
	git add Modulefile manifests\init.pp tests\init.pp
	```
4. Commit these changes to git:

	```
	git commit -am "Unblanked module with newauthor and newmodule"
	```
5. Add new remote repository:

	```
	git remote add origin git@git.repo.server:repository.git
	```
6. Push changes to origin:

	```
	git push origin master
	```
7. The new module is ready for further development

## Updating puppet-blank

Just merge from the puppet-blank remote, though conflicts will be expected:

```
git pull puppet-blank master
```

## Cleaning up the puppet-blank files
1. Start Powershell in the blank module directory
2. Run the cleanup script:

	```
	.\cleanup.ps1
	```
3. Commit the changes to git:

	```
	git commit -am "Cleaned up with the puppet-blank cleanup script"
	```
4. Push changes to remote:

	```
	git push origin master
	```

**NOTE:** The cleanup script is *destructive* and will delete several files, including itself.

**NOTE:** The puppet-blank remote is read-only, it should not be possible to push to it.

## Prepare a module for submission to Puppet Forge

1. To perform this step, the module will need to be cloned to a Linux server where puppet has been installed, and that the `UNKNOWN` entries in the `Modulefile` have been corrected.
2. in the parent directory to the module, build the module metadata where the module is in the directory `puppet-module`:

	```
	puppet module build puppet-module
	```
3. Submit the resulting tarball to Puppet Forge as per [their instructions]
(http://docs.puppetlabs.com/puppet/2.7/reference/modules_publishing.html)

# Frequently Asked Questions

More like questions that should be asked.

## Why not use the puppet module generator?

This module started with the standard module generation using

	```
	puppet module generate author-blank
	```
...so why not continue to use it?

This module is intended for:

1. Writing a module in an environment where puppet is not or can not be installed
2. Use as a starting point for a collection of modules and prepopulated with things like licensing, boiler plate, pictures of cats, etc. etc.
3. Writing a module in an environment where `puppet module generate` doesn't work, i.e. Windows.

## Why Windows powershell scripts?

My `$work` environment is restricted to using Windows 7, so I required scripts that run under Windows 7. I used Powershell because it has Perl-like regular expressions, which made this much easier than `.bat` batch files.