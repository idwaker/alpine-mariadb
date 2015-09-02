
# obtain latest alpine linux image
FROM alpine

# upgrade
RUN apk update && apk upgrade && \
	apk add --update mariadb mariadb-client && rm -rf /var/cache/apk/* && \
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf

# configure mysql
RUN echo "mysql_install_db --user=mysql" && \
  	echo "mysqld_safe &" > /tmp/config && \
  	echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  	echo "mysqladmin -u root password 'root'" >> /tmp/config && \
  	sh /tmp/config && \
  	rm -f /tmp/config

# define mountable volumes
VOLUME ["/var/lib/mysql"]


# expose port
EXPOSE 3306


# create entry point
CMD ["mysqld_safe"]

