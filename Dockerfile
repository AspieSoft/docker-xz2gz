FROM debian:10

WORKDIR /app

RUN apt -y update
RUN apt -y install xz-utils

COPY src/* ./

RUN mkdir /input
RUN mkdir /output

CMD [ "bash", "run.sh" ]
