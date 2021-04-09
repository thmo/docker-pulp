ARG FROM_ORG
ARG FROM_TAG=latest
FROM ${FROM_ORG}pulp-core:$FROM_TAG

ADD entrypoint.sh /entrypoint.sh

EXPOSE 24816
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
