# This Dockerfile describes three build targets:
#
# **[build] Set up dependencies required for contributing to `github/octodns`.**
#
#     docker build --rm --target build -t octodns:build .
#     docker run --rm -it octodns:build
#
# **[dev] Like `build`, but map your local clone of octodns.**
#
#     docker build --rm --target dev -t octodns:dev .
#     docker run --rm -it -v $(realpath .)/octodns:/octodns octodns:dev
#
# **[run] Current release of `github/octodns`. Map your config directory.**
#
#     docker build --rm --target run -t octodns:latest .
#     docker run --rm -it -v $(realpath .)/config:/config octodns


# BUILD : Clones octodns and verifies all build dependencies.
FROM python:2-alpine as build

# Install required packages.
RUN apk update
RUN apk add git bash build-base libffi-dev openssl-dev

# Bootstrap and install octodns.
WORKDIR /
RUN git clone https://github.com/github/octodns.git octodns
WORKDIR /octodns
RUN pip install virtualenv
RUN ./script/bootstrap
RUN source env/bin/activate && pip install .

# Set entry point and environment variables.
ENTRYPOINT ["/bin/sh"]


# DEV : Includes build and test dependencies. Map local octodns clone.
FROM build as dev
RUN rm -rf /octodns

# Set entry point and environment variables.
ENTRYPOINT ["/bin/sh"]
VOLUME ["/octodns"]


# RUN : Includes latest octodns release. Map local config directory.
FROM python:2-alpine as run

# Install required packages.
RUN apk update
RUN apk add git

# Set entry point and environment variables.
ENTRYPOINT ["/bin/sh"]
VOLUME ["/config"]

# Install octodns.
WORKDIR /
RUN git clone https://github.com/github/octodns.git octodns
WORKDIR /octodns
RUN git checkout tags/v0.9.4
RUN pip install virtualenv
RUN virtualenv env
RUN source env/bin/activate
RUN pip install .
