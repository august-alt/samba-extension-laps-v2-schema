# Container image that runs your code
FROM alt:p11

ARG USER_ID
ARG GROUP_ID

RUN apt-get update \
    && apt-get install -y rpm-build gear ldb-tools rpm-build-python3 \
    && export CURRENT_PWD=`pwd` \
    && groupadd --gid $GROUP_ID builder2 \
    && useradd --uid $USER_ID --gid $GROUP_ID -ms /bin/bash builder2 \
    && groupadd sudo \
    && usermod -aG rpm builder2 \
    && usermod -aG sudo root \
    && usermod -aG sudo builder2 \
    && echo "root ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers \
    && echo "builder2 ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers \
    && mkdir /app \
    && chown root:builder2 /app

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY script/build.sh /build.sh

USER builder2
WORKDIR /home/builder2

# Code file to execute when the docker container starts up (`build.sh`)
ENTRYPOINT ["/build.sh"]