FROM alpine:latest

LABEL maintainer="Thien Tran contact@tommytran.io"

RUN apk --no-cache add -f \
  openssl \
  openssh-client \
  coreutils \
  bind-tools \
  curl \
  sed \
  socat \
  tzdata \
  oath-toolkit-oathtool \
  tar \
  libidn \
  jq \
  cronie

ENV LE_CONFIG_HOME=/acme.sh

ENV AUTO_UPGRADE=0

#Install
RUN mkdir -p /install_acme.sh/ /root/.cache/crontab
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/refs/heads/master/acme.sh \
    https://github.com/acmesh-official/acme.sh.git:deploy \
    https://github.com/acmesh-official/acme.sh.git:dnsapi \
    https://github.com/acmesh-official/acme.sh.git:notify /install_acme.sh/
RUN cd /install_acme.sh && ([ -f /install_acme.sh/acme.sh ] && /install_acme.sh/acme.sh --install || curl https://get.acme.sh | sh) && rm -rf /install_acme.sh/


RUN ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh && crontab -l | grep acme.sh | sed 's#> /dev/null#> /proc/1/fd/1 2>/proc/1/fd/2#' | crontab -

RUN for verb in help \
  version \
  install \
  uninstall \
  upgrade \
  issue \
  signcsr \
  deploy \
  install-cert \
  renew \
  renew-all \
  revoke \
  remove \
  list \
  info \
  showcsr \
  install-cronjob \
  uninstall-cronjob \
  cron \
  toPkcs \
  toPkcs8 \
  update-account \
  register-account \
  create-account-key \
  create-domain-key \
  createCSR \
  deactivate \
  deactivate-account \
  set-notify \
  set-default-ca \
  set-default-chain \
  ; do \
    printf -- "%b" "#!/usr/bin/env sh\n/root/.acme.sh/acme.sh --${verb} --config-home /acme.sh \"\$@\"" >/usr/local/bin/--${verb} && chmod +x /usr/local/bin/--${verb} \
  ; done

COPY --chmod=755 entry.sh /

RUN apk --no-cache add libstdc++
COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

VOLUME /acme.sh

ENTRYPOINT ["/entry.sh"]
CMD ["--help"]
