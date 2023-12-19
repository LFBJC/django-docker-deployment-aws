FROM python:3.9-alpine3.13
LABEL maintainer="LuizFelipedeBarrosJordãoCosta"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

# apk add --update --no-cache postgresql-client is the command to install the client for the database
# The command apk add --update --no-cache --virtual .tmp-deps build-base postgresql-dev musl-dev creates a virtual
# temporary package containing the packages build-base postgresql-dev musl-dev that will later be deleted as
# these packages are only needed in order to install the driver (they are needed in order to install psycopg2
# to postgres driver)
# in the last instruction -D = "Disable password" -H = "Don't create home directory"
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
          build-base postgresql-dev musl-dev && \
    apk del .tmp-deps && \
    /py/bin/pip install -r /requirements.txt && \
    adduser -D -H app

ENV PATH="/py/bin:$PATH"

USER app

