FROM  cgr.dev/chainguard/atlantis:latest-dev
USER root 
RUN  apk update && apk add aws-cli efs-utils ca-certificates 
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.55.18/terragrunt_linux_amd64
ADD ./certs/code/code.crt /usr/local/share/ca-certificates/code.crt
ADD ./certs/ca/EntrustPrivateTrustSSLCAPrivSSL1.crt /usr/local/share/ca-certificates/EntrustPrivateTrustSSLCAPrivSSL1.crt
ADD ./certs/ca/EntrustRootCertificationAuthorityG3.crt /usr/local/share/ca-certificates/EntrustRootCertificationAuthorityG3.crt
RUN update-ca-certificates
RUN mkdir -p /config
RUN adduser -S -u 100 -g 1000 -h /home/atlantis atlantis
RUN chown atlantis:root /home/atlantis/ && \
    chmod u+rwx /home/atlantis/
#ADD $PWD/atlantis.yaml /config/atlantis.yaml
COPY aws_credentials /home/atlantis/.aws/credentials
RUN chown -R 100:1000 /config
RUN chown -R 100:1000 /home/atlantis/.aws
RUN chown -R 100:1000 /usr/bin/atlantis 
RUN chmod -R 775 /home/atlantis/.aws
USER 100:1000
CMD ["server"]