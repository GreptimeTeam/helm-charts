FROM ubuntu:22.04

RUN ARCH=$(dpkg --print-architecture) && echo "Using architecture: $ARCH"

# supporting command install
RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    curl \
    unzip \
    tar \
    net-tools \
    iproute2 \
    telnet \
    make \
    gcc \
    mysql-client \
    postgresql-client \
    jq

# etcdctl cli install
RUN wget "https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-${ARCH}.tar.gz" && \
    tar zxvf "etcd-v3.5.0-linux-${ARCH}.tar.gz" && \
    sudo mv etcd-v3.5.0-linux-${ARCH}/etcdctl /usr/local/bin/ && \
    rm -rf etcd-v3.5.0-linux-${ARCH}*

# aws cli install
RUN if [ "$ARCH" = "amd64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    else \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm awscliv2.zip

# aliyun cli install
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aliyun/aliyun-cli/HEAD/install.sh)"

# gcloud cli install
RUN if [ "$ARCH" = "amd64" ]; then \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz; \
    else \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-arm.tar.gz; \
    fi && \
    tar zxvf google-cloud-cli-linux-* && \
    ./google-cloud-sdk/install.sh && \
    rm -rf google-cloud-cli-linux-*

# kubectl cli install
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" \
    && curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && kubectl version --client

CMD ["tail", "-f", "/dev/null"]
