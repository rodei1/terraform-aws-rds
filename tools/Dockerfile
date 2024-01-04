FROM python:slim

RUN apt update && \
    apt install -y curl libpq-dev less jq tar unzip


# Adding  GitHub public SSH key to known hosts
RUN ssh -T -o "StrictHostKeyChecking no" -o "PubkeyAuthentication no" git@github.com || true

# ========================================
# TERRAFORM DOCS
# ========================================
ENV TERRAFORM_DOCS_VERSION=0.17.0
RUN export BUILD_ARCHITECTURE=$(uname -m); \
    if [ "$BUILD_ARCHITECTURE" = "x86_64" ]; then export BUILD_ARCHITECTURE_ARCH=amd64; fi; \
    if [ "$BUILD_ARCHITECTURE" = "aarch64" ]; then export BUILD_ARCHITECTURE_ARCH=arm64; fi; \
    curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${BUILD_ARCHITECTURE_ARCH}.tar.gz
RUN tar -xzf terraform-docs.tar.gz
RUN chmod +x terraform-docs
RUN mv terraform-docs /usr/local/bin/

# ========================================
# TERRAFORM
# ========================================

ENV TERRAFORM_VERSION=1.4.6

RUN export BUILD_ARCHITECTURE=$(uname -m); \
    if [ "$BUILD_ARCHITECTURE" = "x86_64" ]; then export BUILD_ARCHITECTURE_ARCH=amd64; fi; \
    if [ "$BUILD_ARCHITECTURE" = "aarch64" ]; then export BUILD_ARCHITECTURE_ARCH=arm64; fi; \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${BUILD_ARCHITECTURE_ARCH}.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_${BUILD_ARCHITECTURE_ARCH}.zip \
    && mv terraform /usr/local/bin/ \
    && terraform -install-autocomplete


COPY scaffolding/scripts /scripts
COPY scaffolding/templates /templates

ENTRYPOINT [ "bash", "/scripts/entrypoint.sh"]
