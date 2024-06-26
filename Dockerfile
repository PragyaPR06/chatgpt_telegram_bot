FROM python:3.8-slim

ENV PYTHONFAULTHANDLER=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONHASHSEED=random
ENV PYTHONDONTWRITEBYTECODE 1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

RUN set -x && \
    apt-get -qq update && \
    apt-get -qq install -y build-essential ffmpeg gettext libgettextpo-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /code/bot /code/config
ADD . /code
WORKDIR /code


RUN for lang in en de fr tr; do \
    msgfmt locales/$lang/LC_MESSAGES/base.po -o locales/$lang/LC_MESSAGES/base.mo; \
done

RUN pip install --no-cache-dir -r requirements.txt

VOLUME ./bot:/code/bot
VOLUME ./config:/code/config

CMD ["bash"]