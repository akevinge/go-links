FROM python:3.10-bookworm

RUN mkdir -p /usr/src/app
COPY . /usr/src/app

RUN python3.10 -m ensurepip --upgrade
RUN pip3.10 install pipenv

WORKDIR /usr/src/app
RUN pipenv install

CMD [ "pipenv", "run", "python", "server.py" ]