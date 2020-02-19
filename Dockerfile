FROM debian:buster-slim

ENV AZCOPY_VERSION=10.3.4
ENV BLOBFUSE_VERSION=1.1.1


# based on https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt update && \
    apt install -y ca-certificates curl apt-transport-https lsb-release gnupg wget libcurl3-gnutls fuse && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list && \
    apt update && apt install -y azure-cli && \
    apt clean all

# install azcopy
RUN mkdir -p /tmp/azcopy && cd /tmp/azcopy && curl https://azcopyvnext.azureedge.net/release20200124/azcopy_linux_amd64_${AZCOPY_VERSION}.tar.gz -o azcopy.tar.gz && \
    mkdir azcopy && \
    tar -C azcopy -zxf azcopy.tar.gz && \
    cd az*/az* && \
    chmod +x azcopy && \
    mkdir /root/bin && \
    mv azcopy /root/bin && \
    rm -rf /tmp/azcopy

# install blobfuse
RUN wget https://github.com/Azure/azure-storage-fuse/releases/download/v${BLOBFUSE_VERSION}/blobfuse-${BLOBFUSE_VERSION}-stretch.deb && \
    dpkg -i blobfuse-${BLOBFUSE_VERSION}-stretch.deb && \
    rm -f blobfuse-${BLOBFUSE_VERSION}-stretch.deb