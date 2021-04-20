ARG FROM_ORG
ARG FROM_TAG=latest
FROM ${FROM_ORG}pulp-core:$FROM_TAG

ADD entrypoint.sh /entrypoint.sh

COPY signing.py /opt/pulp/lib/register-signing-api.py
COPY sign-metadata.sh /opt/pulp/bin/sign-metadata

EXPOSE 24817
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
