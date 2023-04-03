#django image
FROM python:3.7.3
#set environment variables

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# create and set working directory
RUN mkdir /app
WORKDIR /app
COPY ./app /app

# create user
RUN adduser -D user
USER user

# run django server
CMD python manage.py runserver 0.0.0.0/0

