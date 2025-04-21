FROM ubuntu:22.04

# Supporting Command Install
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    sudo \
    curl \
    unzip \
    net-tools \
    iproute2 \
    telnet \
    make \
    gcc \
    mysql-client \
    postgresql-client \
    jq \
    python3 \
    python3-pip \
    curl \
    telnet \
    netcat-openbsd \
    fio \
    iperf3

# ETCD CLI Install
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-${ARCH}.tar.gz" && \
    tar zxvf "etcd-v3.5.0-linux-${ARCH}.tar.gz" && \
    sudo mv etcd-v3.5.0-linux-${ARCH}/etcdctl /usr/local/bin/ && \
    rm -rf etcd-v3.5.0-linux-${ARCH}*

# AWS CLI Install
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    else \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/

# AliCloud CLI Install
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aliyun/aliyun-cli/HEAD/install.sh)" && \
    rm aliyun-cli-linux-latest-*

# Google Cloud CLI Install
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz; \
    else \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-arm.tar.gz; \
    fi && \
    tar zxvf google-cloud-cli-linux-* && \
    ./google-cloud-sdk/install.sh && \
    rm -rf google-cloud-cli-linux-*

# s5cmd cli Install
RUN wget https://github.com/peak/s5cmd/releases/download/v2.3.0/s5cmd_2.3.0_Linux-64bit.tar.gz && \
    tar -xzf s5cmd_2.3.0_Linux-64bit.tar.gz && \
    sudo mv s5cmd /usr/local/bin/ && \
    sudo chmod +x /usr/local/bin/s5cmd && \
    rm s5cmd_2.3.0_Linux-64bit.tar.gz

# Kubectl CLI Install
RUN ARCH=$(dpkg --print-architecture) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
    && curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && kubectl version --client

CMD ["tail", "-f", "/dev/null"]
