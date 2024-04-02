FROM fedora:38

WORKDIR /app

RUN dnf -y downgrade xz xz-*

COPY src/* ./

RUN mkdir /input
RUN mkdir /output

CMD [ "bash", "run.sh" ]
