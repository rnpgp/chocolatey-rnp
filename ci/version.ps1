$Namespace = @{nuspec = "http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd"}
$Path = "${env:GITHUB_WORKSPACE}/rnp/rnp.nuspec"
$node = Select-Xml -Path $Path -Namespace $Namespace -XPath "//nuspec:package/nuspec:metadata/nuspec:version"
$version = $node.Node.InnerText
Write-Output "Determined RNP version to build: $version"
$env:VERSION = $version
