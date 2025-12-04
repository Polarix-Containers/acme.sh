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

ENV LE_WORKING_DIR=/acmebin

ENV LE_CONFIG_HOME=/acme.sh

ARG AUTO_UPGRADE=0

ENV AUTO_UPGRADE=$AUTO_UPGRADE

#Install
COPY ./acme.sh /install_acme.sh/acme.sh
COPY ./deploy /install_acme.sh/deploy
COPY ./dnsapi /install_acme.sh/dnsapi
COPY ./notify /install_acme.sh/notify

RUN cd /install_acme.sh && ([ -f /install_acme.sh/acme.sh ] && /install_acme.sh/acme.sh --install || curl https://get.acme.sh | sh) && rm -rf /install_acme.sh/


RUN ln -s $LE_WORKING_DIR/acme.sh /usr/local/bin/acme.sh && crontab -l | grep acme.sh | sed 's#> /dev/null#> /proc/1/fd/1 2>/proc/1/fd/2#' | crontab -

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
    printf -- "%b" "#!/usr/bin/env sh\n$LE_WORKING_DIR/acme.sh --${verb} --config-home $LE_CONFIG_HOME \"\$@\"" >/usr/local/bin/--${verb} && chmod +x /usr/local/bin/--${verb} \
  ; done

COPY --chmod=755 entry.sh /
RUN chmod -R o+rwx $LE_WORKING_DIR && chmod -R o+rwx $LE_CONFIG_HOME

RUN apk --no-cache add libstdc++
COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

VOLUME /acme.sh

ENTRYPOINT ["/entry.sh"]
CMD ["--help"]
