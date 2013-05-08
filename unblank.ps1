Param($author,$module)
if ($author -match "^\w+$") {
  if ($module -match "^\w+$") {
    echo "Update Modulefile..."
    $modulefile = Get-Content Modulefile.orig
    $modulefile = Foreach-Object {$modulefile -replace "aethylred", $author}
    $modulefile = Foreach-Object {$modulefile -replace "blank", $module}
    Set-Content Modulefile $modulefile
    echo "Modulefile updated."

    echo "Update manifests/init.pp..."
    $initfile = Get-Content manifests/init.pp.orig
    $initfile = Foreach-Object {$initfile -replace "blank", $module}
    Set-Content manifests/init.pp $initfile
    echo "manifests/init.pp updated."

    echo "Update tests\init.pp..."
    $testfile = Get-Content tests/init.pp.orig
    $testfile = Foreach-Object {$testfile -replace "blank", $module}
    Set-Content tests/init.pp $testfile
    echo "tests/init.pp updated."

    echo "Update .fixtures.yml..."
    $modulefile = Get-Content .fixtures.yml.orig
    $modulefile = Foreach-Object {$modulefile -replace "aethylred", $author}
    $modulefile = Foreach-Object {$modulefile -replace "blank", $module}
    Set-Content .fixtures.yml $modulefile
    echo ".fixtures.yml updated."

  } else {
    throw "ERROR: Bad module parameter '$module', must be a single word made up of word caracters [a-zA-Z_0-9]"
  }
} else {
  throw "ERROR: Bad author parameter '$author', must be a single word made up of word caracters [a-zA-Z_0-9]"
}