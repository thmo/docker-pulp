ARG FROM_ORG
ARG FROM_TAG=latest
FROM ${FROM_ORG}pulp-core:$FROM_TAG

ADD entrypoint.sh /entrypoint.sh

ADD signing.py /signing.py

ADD sign-metadata.sh /sign-metadata.sh

EXPOSE 24817
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
