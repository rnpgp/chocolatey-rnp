$node = Select-Xml -XPath "/package/metadata/version" -Path ${env:GITHUB_WORKSPACE}/rnp/rnp.nuspec
$version = $node.Node.InnerText
Write-Output "Determined RNP version to build: $version"
$Env:VERSION = $version
