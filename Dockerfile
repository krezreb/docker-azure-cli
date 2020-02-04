FROM debian:buster-slim

# based on https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt update && \
    apt install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list && \
    apt update && apt install -y azure-cli && \
    apt clean all

# install azcopy
RUN mkdir -p /tmp/azcopy && cd /tmp/azcopy && curl https://azcopyvnext.azureedge.net/release20200124/azcopy_linux_amd64_10.3.4.tar.gz -o azcopy.tar.gz && \
    mkdir azcopy && \
    tar -C azcopy -zxf azcopy.tar.gz && \
    cd az*/az* && \
    chmod +x azcopy && \
    mv azcopy /usr/bin && \
    rm -rf /tmp/azcopy
