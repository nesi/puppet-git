echo "Cleaning up template..."
if ((Test-Path 'Modulefile') -and (Test-Path 'manifests/init.pp') -and (Test-Path 'tests/init.pp')){
	echo "Deleting .orig templates..."
	Remove-Item 'Modulefile.orig'
	Remove-Item 'manifests/init.pp.orig'
	Remove-Item 'tests/init.pp.orig'
	Remove-Item 'README1st.markdown'
	Remove-Item 'unblank.ps1'
	Remove-Item 'cleanup.ps1'
} else {
	throw "ERROR: Cannot find required files, have you run unblank.ps1?"
}