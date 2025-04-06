FROM nginxdemos/hello:plain-text

COPY ./generate-hello-plain-text-conf.sh /docker-entrypoint.d/generate-hello-plain-text-conf.sh
RUN chmod +x /docker-entrypoint.d/generate-hello-plain-text-conf.sh
COPY ./hello-plain-text.conf.template /etc/nginx/hello-plain-text.conf.template

ENV ENVIRONMENT="default"
ENV N5SECRET="source"