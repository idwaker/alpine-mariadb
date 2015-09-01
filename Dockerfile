
# obtain latest alpine linux image
FROM alpine

# upgrade
RUN apk update && apk upgrade && \
	apk add --update mariadb mariadb-client && rm -rf /var/cache/apk/* && \
	sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  	echo "mysqld_safe &" > /tmp/config && \
  	echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  	echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  	sh /tmp/config && \
  	rm -f /tmp/config


# create volumes TODO: move to separate file
RUN mkdir -p /var/lib/mysql
 

# define mountable volumes
VOLUME ["/var/lib/mysql"]


# expose port
EXPOSE 3306


# create entry point
ENTRYPOINT ["mysqld_safe"]

