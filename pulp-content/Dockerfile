FROM kong/pulp-core:0.0.12

ADD entrypoint.sh /entrypoint.sh

EXPOSE 24816
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
