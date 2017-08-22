FROM centos:7

ENV GITEA_VERSION 1.1.2
ENV GITEA_APP_DIR=/opt/app/gitea

EXPOSE 22 3000


VOLUME ["/gitea/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]


USER root
RUN mkdir -p /gitea/data/gitea
RUN mkdir -p ${GITEA_APP_DIR}
RUN chgrp -R 0 /gitea/data
RUN chmod -R g+rw /gitea/data
RUN mkdir -p ${GITEA_APP_DIR}
RUN chgrp -R 0 ${GITEA_APP_DIR}
RUN chmod -R g+rw ${GITEA_APP_DIR}

ENV GITEA_CUSTOM /gitea/data/gitea

RUN cd / && \
  curl -LO https://github.com/go-gitea/gitea/releases/download/v${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64 > ${GITEA_APP_DIR}/gitea

USER root
RUN chgrp -R 0 ${GITEA_APP_DIR}
RUN chmod -R g+rw ${GITEA_APP_DIR}
RUN chmod g+x ${GITEA_APP_DIR}/gitea


ENV GODEBUG=netdns=go


ADD docker-entrypoint /usr/bin/docker-entrypoint
ADD app.ini /tmp/app.ini

CMD ["/bin/bash","/usr/bin/docker-entrypoint"]
ENTRYPOINT []
