FROM kong/pulp-core:0.0.12

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
