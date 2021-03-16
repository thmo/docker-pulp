FROM kong/pulp-core:0.0.7

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
