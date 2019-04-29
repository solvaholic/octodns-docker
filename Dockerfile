# This Dockerfile describes two build targets:
#
# **[run] Python for running your octodns clone and config.**
#
#     docker build --rm --target run -t octodns:latest .
#
# This image expects you to mount your clone of `github/octodns` and your
# config directory. Remember to define PIP_EXTRAS and any environment
# variables your sources and providers require:
#
#     cd ~/repos/dns
#     myconfig="$(realpath .)/config"
#     myoctodns="$(realpath .)/../octodns"
#     myenv=".env"
#     docker run -it --rm --env-file="${myenv}" -v "${myconfig}":/config:ro \
#       -v "${myoctodns}":/octodns octodns:latest
#
# **[build] Include dependencies required for contributing to `github/octodns`.**
#
#     docker build --rm --target build -t octodns:build .
#
# This image expects you to mount your clone of `github/octodns` and your
# config directory. Remember to define PIP_EXTRAS and any environment
# variables your sources and providers require:
#
#     cd ~/repos/octodns
#     myoctodns="$(realpath .)"
#     docker run -it --rm -v "${myoctodns}":/octodns octodns:build


# RUN : Map your octodns clone and your config directory.
FROM python:2-slim as run

# Install virtualenv.
WORKDIR /
RUN pip install virtualenv
RUN virtualenv /env

# Set entry point and environment variables.
ENV VENV_NAME /env
VOLUME ["/config"]
VOLUME ["/octodns"]
ENTRYPOINT ["/bin/bash"]

# Running this container will pip install /octodns and ${PIP_EXTRAS}.
CMD ["-c", "source /env/bin/activate && pip install /octodns ${PIP_EXTRAS} && /bin/bash"]


# BUILD : Map your octodns clone.
FROM run as build

# Running this container runs octodns/script/bootstrap.
CMD ["-c", "source /env/bin/activate && /octodns/script/bootstrap && /bin/bash"]
