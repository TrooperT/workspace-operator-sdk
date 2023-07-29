ARG WORKSPACE_GO_VERSION
FROM gitpod/workspace-go:${WORKSPACE_GO_VERSION:-latest}

ARG ARCH
ENV ARCH=${ARCH:-amd64}
ENV OS=linux
ARG OPERATOR_SDK_VERSION
ENV OPERATOR_SDK_VERSION=${OPERATOR_SDK_VERSION:-v1.31.0}
ENV OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/${OPERATOR_SDK_VERSION}

RUN mkdir -p /tmp/osdk && curl -L ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH} -o /tmp/osdk/operator-sdk_${OS}_${ARCH}
RUN curl -L ${OPERATOR_SDK_DL_URL}/checksums.txt -o /tmp/osdk/checksums.txt
RUN curl -L ${OPERATOR_SDK_DL_URL}/checksums.txt.asc -o /tmp/osdk/checksums.txt.asc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 052996E2A20B5C7E
RUN cd /tmp/osdk && gpg -u "Operator SDK (release) <cncf-operator-sdk@cncf.io>" --verify checksums.txt.asc
RUN cd /tmp/osdk && grep operator-sdk_${OS}_${ARCH} checksums.txt | sha256sum -c -
RUN chmod +x /tmp/osdk/operator-sdk_${OS}_${ARCH} 
RUN sudo mv /tmp/osdk/operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk