# Tomcat appliactions bind to url paths and needs to know its' context path
# https://confluence.atlassian.com/display/JIRAKB/Integrating+JIRA+with+Nginx

# This will try to modify configuration files in plase,
# this is work in progress, as bitbucket does recognize those changes 

sudo sed -i~ 's/\(<Connector port="8080"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/jira/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/jira/g' /opt/atlassian/jira/conf/server.xml
sudo /etc/init.d/jira stop
sudo /etc/init.d/jira start

sudo sed -i~ 's/\(<Connector port="8085"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/bamboo/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/bamboo/g' /opt/atlassian/bamboo/conf/server.xml

sudo sed -i~ 's/\(<Connector port="8090"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/confluence/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/confluence/g' /opt/atlassian/confluence/conf/server.xml
sudo /etc/init.d/confluence stop
sudo /etc/init.d/confluence start

sudo sed -i~ 's/\(<Connector port="7990"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
# sudo sed -i 's/\(<Context [:s:]*path="\)/\1\/bitbucket/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
sudo sed -i 's/\(path="\)/\1\/bitbucket/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
sudo /opt/atlassian/bitbucket/4.0.2/bin/stop-bitbucket.sh
sudo /opt/atlassian/bitbucket/4.0.2/bin/start-bitbucket.sh
