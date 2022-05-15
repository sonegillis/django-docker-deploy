FROM ubuntu:20.04

# set arguments
ARG GIT_BRANCH=main
ARG GIT_REPO
ARG PROJECT_NAME
ARG SSH_PRIVATE_KEY
ARG DEBIAN_FRONTEND=noninteractive

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
RUN apt-get install -y libmysqlclient-dev
# create a new user and add to www-data group
RUN useradd -g www-data gunicorn
RUN mkdir /root/.ssh && touch /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
# clone django project
RUN mkdir /home/apps/${PROJECT_NAME}
WORKDIR /home/apps/$PROJECT_NAME
RUN git clone $GIT_REPO . -b $GIT_BRANCH
RUN ls
RUN pwd
RUN pip3 install -r requirements.txt
RUN python3 manage.py collectstatic
RUN pip3 install gunicorn
EXPOSE 8000
ENTRYPOINT [ "sh", "-c",  "/usr/bin/gunicorn --workers 3 --bind :8000 $PROJECT_NAME.wsgi:application" ]
