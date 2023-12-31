FROM python:3.9-alpine3.13
LABEL maintainer="LuizFelipedeBarrosJordãoCosta"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app
COPY ./scripts /scripts

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
    apk add --update --no-cache --virtual .tmp-deps build-base postgresql-dev musl-dev linux-headers && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser -D -H app && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER app

CMD ["run.sh"]