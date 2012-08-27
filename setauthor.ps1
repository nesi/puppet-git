Param($author)
if ($author -match "^\w+$") {
	echo "Replacing author with $author..."
	Get-Content Modulefile.orig | Foreach-Object {$_ -replace "aethylred", $author} | Set-Content Modulefile
	echo "New Modulefile created"
} else {
  echo "Bad author '$author', must be a single word made up of word caracters [a-zA-Z_0-9]"
}