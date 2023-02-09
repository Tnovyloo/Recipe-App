#FROM python:3.9-alpine3.13
#LABEL maintainer="tnovyloo"
#
#ENV PYTHONUNBUFFERED 1
#
#COPY ./requirements.txt /tmp/requirements.txt
#COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#COPY ./app /app
#WORKDIR /app
#EXPOSE 8000
#
#ARG DEV=false
#RUN python -m venv /py && \
#    /py/bin/pip install --upgrade pip && \
#    apk add --update --no-cache postgresql-client && \
#    apk add --udpate --no-cache --virtual .tmp-build-deps \
#        build-base postgresql-dev musl-dev &&\
#    /py/bin/pip install -r /tmp/requirements.txt && \
#    if [ $DEV = "true" ]; \
#      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
#    fi && \
#    rm -rf /tmp && \
#    apk del .tmp-build-deps &&\
#    adduser \
#        --disabled-password \
#        --no-create-home \
#        django-user
#
#ENV PATH="/py/bin:$PATH"
#USER django-user

FROM python:3.9-alpine
MAINTAINER London App Developer Ltd

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
