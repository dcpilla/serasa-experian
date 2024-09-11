FROM python:3.8-slim-buster

RUN useradd demo && mkdir /home/demo && chown -R demo /home/demo

WORKDIR /home/demo/app
USER demo

COPY src/requirements.txt requirements.txt

# the thrusted-host parameters are used to execute berind proxy
RUN pip3 install \
    --trusted-host files.pythonhosted.org \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --no-cache-dir -r requirements.txt

COPY src/. .

ENV FLASK_APP="main.py"

CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0" ]
