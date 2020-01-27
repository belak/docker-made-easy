FROM python:alpine

ENV PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on

COPY pyproject.toml poetry.lock /code/

WORKDIR /code/

RUN apk add --no-cache --virtual .build-deps gcc libc-dev libffi-dev openssl-dev \
    && pip install 'poetry==1.0.2' \
    && poetry install \
    && apk del --no-cache .build-deps gcc libc-dev

COPY . /code/

CMD ["gunicorn", "-b", "0.0.0.0:8000", "mysite.wsgi:application"]
ENTRYPOINT ["poetry", "run"]
