FROM cronfy/lamp7.0-lik

COPY data/user/id_rsa /var/www/.ssh/
RUN chmod 600 /var/www/.ssh/id_rsa

# mysql db and user
# cronfy/lam supports this
ENV MYSQL_USER_DB=project
ENV MYSQL_USER_NAME=project

# Use default mysql user pass or set one from command line --build-arg
ARG MYSQL_USER_PASS=default0BXwfkL
ENV MYSQL_USER_PASS ${MYSQL_USER_PASS}

