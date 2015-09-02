
# obtain latest alpine linux image
FROM alpine:latest

# upgrade
RUN apk add --update mariadb mariadb-client \
	&& rm -fr /var/lib/apk/* \
	&& rm -fr /var/cache/apk/* \
	&& sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
	&& echo "bind-address = 0.0.0.0\nskip-host-cache\nskip-name-resolve" > /tmp/mycnf \
	&& echo "" >> /tmp/mycnf \
	&& cat /tmp/mycnf | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
	&& mv /tmp/my.cnf /etc/mysql/my.cnf \
	&& rm -f /tmp/my.cnf && rm -f /tmp/mycnf \
	&& echo "mysql_install_db --user=mysql" > /tmp/config \
  	&& echo "mysqld_safe &" >> /tmp/config \
  	&& echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
  	&& echo "mysqladmin -u root password 'root'" >> /tmp/config \
  	&& sh /tmp/config \
  	&& rm -f /tmp/config

# define mountable volumes
VOLUME ["/var/lib/mysql"]

# expose port
EXPOSE 3306

# create entry point
CMD ["mysqld_safe"]

