# NeSI git module
#
# Somewhat derived from https://github.com/theforeman/puppet-git
class git(
	$gui = false,
	$svn = true
){
	case $operatingsystem  {
		CentOS,Ubuntu:{
			class{'git::install':
				gui		=> $gui,
				svn		=> $svn,
			}
		}
		default:{
			warning("git is not configured for $operatingsystem on $fqdn")
		}
	}
}