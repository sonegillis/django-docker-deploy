FROM ubuntu:20.04

# set arguments
ARG MYSQL_ROOT_PASSWORD
ARG APP_DB_USER
ARG APP_DB_PASSWORD
ARG APP_DB_NAME 
ARG DOMAIN_NAME
ARG GIT_BRANCH=main
ARG GIT_REPO
ARG PROJECT_DIR
ARG PROJECT_NAME
# install dependencies
WORKDIR /
RUN apt-get update
RUN apt-get -y install nginx && apt-get -y install git
RUN apt-get -y install mysql-server
RUN /etc/init.d/mysql stop
RUN usermod -d /var/lib/mysql/ mysql
RUN /etc/init.d/mysql start
RUN apt-get -y install libmysqlclient-dev

COPY nginx.conf /etc/nginx/sites-available/$DOMAIN_NAME
RUN ln -s /etc/nginx/sites-available/speedyglobecourier.com /etc/nginx/sites-enabled
RUN rm /etc/nginx/sites-enabled/default

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y install python3.8
RUN apt-get -y install python3-pip
RUN apt-get -y install gunicorn
# create a new user and add to www-data group
RUN useradd -g www-data sonegillis
# clone django project
RUN mkdir /home/apps
WORKDIR /home/apps
RUN git clone -b $GIT_BRANCH $GIT_REPO
WORKDIR /home/apps/$PROJECT_DIR
RUN ls
RUN pwd
RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn

COPY .env $PROJECT_NAME/.env
RUN apt-get -y install expect
COPY mysql-secure.sh mysql-secure.sh
COPY init-db.sh init-db.sh
COPY start.sh start.sh
RUN chmod +x mysql-secure.sh
RUN chmod +x init-db.sh
RUN chmod +x start.sh
RUN ./mysql-secure.sh $MYSQL_ROOT_PASSWORD
RUN ./init-db.sh $MYSQL_ROOT_PASSWORD $APP_DB_USER $APP_DB_PASSWORD $APP_DB_NAME
EXPOSE 80
CMD ["./start.sh"]
