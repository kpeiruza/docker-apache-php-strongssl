FROM library/debian
MAINTAINER Kenneth Peiruza <kenneth@floss.cat>

RUN \
  apt-get update && \
  apt-get -y install \
          libapache2-mod-php5 php5-mysql php5-gd php5-xmlrpc php5-intl php5-mcrypt php5-pgsql php5-imap php5-ldap php5-adodb && \
  rm /var/www/html/index.html && \
  rm -rf /var/lib/apt/lists/*
