FROM library/debian
MAINTAINER Kenneth Peiruza <kenneth@floss.cat>
# PHP Packages selected from top 25 Debian Package Popularity Contest: http://popcon.debian.org
# 
RUN \
  sed -i "s/main$/\0 contrib/" /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install \
          libapache2-mod-php5 php5-common php5-cli php5-mysql php5-gd php5-mcrypt php5-json php5-curl php5-readline \
          php5-ldap php5-cgi php5-pgsql php5-sqlite php5-intl php5-imap php5-imagick php5-xsl php5-xmlrpc php-pear && \
  echo "Yes, do as I say!"  | apt-get --force-yes -y purge gcc-4.8-base e2fsprogs ncurses-bin rename && \
  apt-get clean && apt-get autoclean && \
  rm /var/www/html/index.html && \
  rm -rf /var/lib/apt/lists/* && \
  a2enmod headers rewrite ssl && a2dismod status && \
  a2disconf serve-cgi-bin && \
  sed -i -e "s/^ServerTokens .*/ServerTokens Prod/" \
  -e "s/ServerSignature On/ServerSignature Off/" \
  -e "s/^#Header/Header/" \
  -e "s:^#\(</\?DirectoryMatch\):\1:" \
  -e "s/^#\(.*Require all \)/\1/i" /etc/apache2/conf-available/security.conf && \
  sed -i -e "s/MaxConnectionsPerChild.*/MaxConnectionsPerChild   150/" /etc/apache2/mods-available/mpm_prefork.conf && \ 
  sed -i -e "s/Options Indexes/Options/" \
  -e "s/^Timeout 300/Timeout 20/" \
  -e "s/Indexes FollowSymLinks/FollowSymLinks/"  /etc/apache2/apache2.conf && \
  echo '<FilesMatch "\.(old|kk|bak|sql|~)$">
        Require all denied
</FilesMatch>
# Block CVS-alike directory access
<DirectoryMatch "/CVS">
	Require all denied
</Directory>

<DirectoryMatch "/\.git">
   Require all denied
</DirectoryMatch>
# Based on Mozilla https config generator, with tweaked CipherSuite to get stronger levels without loosing compatibility
# Mozilla tool: https://mozilla.github.io/server-side-tls/ssl-config-generator/ 

# intermediate configuration, tweak to your needs
SSLProtocol             all -SSLv3
SSLCipherSuite   ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DES-CBC3-SHA:!DHE:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
SSLHonorCipherOrder     on
SSLCompression          off

# OCSP Stapling, only in httpd 2.3.3 and later
SSLUseStapling          on
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
SSLStaplingCache        shmcb:/var/run/ocsp(128000)

# Feel free to fork/add/suggest
' > /etc/apache2/conf-available/strong-security.conf && \
  a2enconf strong-security
#  rm -rf /usr/share/doc/* && \
#  rm -rf /usr/share/man/* && \
