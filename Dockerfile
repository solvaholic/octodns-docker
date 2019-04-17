# docker build --rm -t octodns:dev .

# docker run --rm -d -v $(realpath .)/config:/config \
# -e KEY=VALUE octodns:dev /bin/sh

# docker run --rm -it -v $(realpath .)/config:/config \
# -e KEY=VALUE --entrypoint /bin/sh octodns:dev

FROM python:2-alpine

# Install some tools.
RUN apk update
RUN apk add git bash build-base libffi-dev openssl-dev

# Install octodns.
WORKDIR /
RUN git clone https://github.com/github/octodns.git octodns
WORKDIR /octodns
RUN git checkout tags/v0.9.4
RUN pip install . boto3 virtualenv
RUN ./script/bootstrap

# Set entry point and environment variables.
ENTRYPOINT ["/bin/sh"]
