FROM centos:7

ENV GITEA_VERSION 1.1.2

EXPOSE 22 3000


VOLUME ["/gitea/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY passwd.template /tmp/passwd.template

USER root
RUN mkdir -p /gitea/data/gitea
RUN mkdir -p /gitea/app/gitea
RUN chgrp -R 0 /gitea/data
RUN chmod -R g+rw /gitea/data
RUN chgrp -R 0 /gitea/app/gitea
RUN chmod -R g+rw /gitea/app/gitea

ENV GITEA_CUSTOM /gitea/data/gitea

RUN cd / && \
  curl -LO https://github.com/go-gitea/gitea/releases/download/v${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64

USER root
RUN chgrp -R 0 /gitea
RUN chmod -R g+rw /gitea
RUN chmod g+x /gitea
RUN mv /gitea-${GITEA_VERSION}-linux-amd64 /gitea/app/gitea/gitea



ENV GODEBUG=netdns=go


ADD docker-entrypoint /usr/bin/docker-entrypoint
ADD app.ini /tmp/app.ini

CMD ["/bin/bash","/usr/bin/docker-entrypoint"]
ENTRYPOINT []
