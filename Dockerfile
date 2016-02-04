FROM library/debian
MAINTAINER Kenneth Peiruza <kenneth@floss.cat>
# PHP Packages selected from top 20 Debian Package Popularity Contest: http://popcon.debian.org
# I will probably remove suhosin. I fear it could block normal execution of many popular PHP+MySQL apps...
RUN \
  apt-get update && \
  apt-get -y install \
          libapache2-mod-php5 php5-common php5-cli php5-mysql php5-gd php5-mcrypt php5-json php5-curl php5-readline php5-ldap php5-cgi php5-pgsql php5-sqlite php5-intl php5-imap php5-suhosin php5-imagick php5-xsl php5-xmlrpc && \
  rm /var/www/html/index.html && \
  rm -rf /var/lib/apt/lists/*
