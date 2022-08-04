FROM smallstep/step-ca:latest AS ca 

FROM smallstep/step-cli:latest

USER root

RUN apk --update --no-cache add jq

ENV CONFIG_FILE="/home/step/config/ca.json"
ENV PASSWORD_FILE="/home/step/secrets/password"

COPY entrypoint.sh /usr/local/src/entrypoint.sh
RUN chmod +x /usr/local/src/entrypoint.sh

COPY --chown=step:step --from=ca /usr/local/bin/step-ca /usr/local/bin/step-ca

ENTRYPOINT ["/usr/local/src/entrypoint.sh"]

CMD exec /bin/sh -c "/usr/local/bin/step-ca --password-file $PASSWORD_FILE $CONFIG_FILE"
