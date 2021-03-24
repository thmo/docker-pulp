FROM kong/pulp-core:0.0.6

ADD entrypoint.sh /entrypoint.sh

EXPOSE 24817
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
