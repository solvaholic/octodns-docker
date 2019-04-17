# octodns Docker image

This Dockerfile describes three build targets:

**[build] Set up dependencies required for contributing to `github/octodns`.**

    docker build --rm --target build -t octodns:build .
    docker run --rm -it octodns:build

**[dev] Like `build`, but map your local clone of octodns.**

    docker build --rm --target dev -t octodns:dev .
    docker run --rm -it -v $(realpath .)/octodns:/octodns octodns:dev

**[run] Current release of `github/octodns`. Map your config directory.**

    docker build --rm --target run -t octodns:latest .
    docker run --rm -it -v $(realpath .)/config:/config octodns
