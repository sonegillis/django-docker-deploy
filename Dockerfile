FROM ubuntu:20.04

# set arguments
ARG DOMAIN_NAME
ARG GIT_BRANCH=main
ARG GIT_REPO
ARG PROJECT_NAME
ARG SSH_PRIVATE_KEY

# ensure to change the secret key
ENV SECRET_KEY=wl6d^o0u9@xj-7s3u=m^jm095g$yim%8a8%1o1za!8dtl3=)k9
ENV DEBUG=False
ENV DB_NAME=dbname
ENV DB_USER=user
ENV DB_PASSWORD=notsecure
ENV DB_HOST=dbhost
# install dependencies
WORKDIR /
RUN apt-get update
RUN apt-get -y install git


RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y install python3.8
RUN apt-get -y install python3-pip
RUN apt-get -y install gunicorn
# create a new user and add to www-data group
RUN usermod -aG www-data gunicorn 
RUN echo $(cat ${SSH_PRIVATE_KEY}) > ~/.ssh/id_rsa
# clone django project
RUN mkdir /home/apps/${PROJECT_NAME}
WORKDIR /home/apps/$PROJECT_NAME
RUN git clone -b $GIT_BRANCH $GIT_REPO .
RUN ls
RUN pwd
RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn

EXPOSE 80
ENTRYPOINT [ "/usr/bin/gunicorn", "--workers", "3", "--bind", "unix:/home/apps/${PROJECT_NAME}}/${PROJECT_NAME}}.sock", "cargotracking.wsgi:application", "--daemon" ]
