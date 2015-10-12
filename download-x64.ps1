# Use this cmd to enable to execute powershell in current session
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# TODO: test it

$wc = New-Object System.Net.WebClient

$file = "atlassian-jira-software-7.0.0-jira-7.0.0-x64.bin"
Write-Host("https://www.atlassian.com/software/jira/downloads/binary/$file")
$wc.DownloadFile("https://www.atlassian.com/software/jira/downloads/binary/$file", ".\downloads\$file")

$file = "atlassian-bitbucket-4.0.2-x64.bin"
$wc.DownloadFile("https://www.atlassian.com/software/stash/downloads/binary/$file", ".\downloads\$file")

$file = "atlassian-confluence-5.8.14-x64.bin"
$wc.DownloadFile("https://www.atlassian.com/software/confluence/downloads/binary/$file", ".\downloads\$file")

$file = "atlassian-bamboo-5.9.4.tar.gz"
$wc.DownloadFile("https://www.atlassian.com/software/bamboo/downloads/binary/$file", ".\downloads\$file")

$file = "jira-portfolio-1.10.5.jar"
$wc.DownloadFile("https://marketplace.atlassian.com/download/plugins/com.radiantminds.roadmaps-jira/version/11050", ".\downloads\$output")
