# jira-sandbox

Playground sandbox for atlassian applications with automated server setup with [vagrant](https://www.vagrantup.com)

Please download Atlassian software installaction files before running [vagrnat up](https://docs.vagrantup.com/v2/getting-started/index.html). See the [sofware-x64download-files.sh](download-files.sh) file.

## Domain mapping on host system

To use this sandbox you'll need to map few domains to localhost. You'll need admin privileges to do this.

On Windows host edit `%SystemRoot%\System32\drivers\etc\hosts` file:

On Linux host edit `/etc/hosts` file:

…and place this mapping there:

    127.0.0.1  localhost dev.example.com jira.example.com bamboo.example.com confluence.example.com bitbucket.example.com

### Run on one domain with context paths

To run services on one domain you'll need to modify Tomcat configuration files on installes services. See the [attlasian-in-context.sh](attlasian-in-context.sh) for examples.

Nginx configuration for this setup is in [atlassian.conf](atlassian.conf).

Please bare in mind that you'll problaby run into issues with Bitbucket as [cookies can be overwritten by different services](https://confluence.atlassian.com/display/BitbucketServerKB/XSRF+Security+Token+Missing).
