# Container image that runs your code
FROM alt:p11

RUN apt-get update \
&& apt-get install -y rpm-build gear ldb-tools \
&& useradd -ms /bin/bash builder && mkdir /app && chown root:builder /app

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY script/build.sh /build.sh

USER builder
WORKDIR /home/builder

# Code file to execute when the docker container starts up (`build.sh`)
ENTRYPOINT ["/build.sh"]