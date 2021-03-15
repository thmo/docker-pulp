To update the requirements txt file...

```
docker build --target build -t pulp-core-build .
docker run --rm pulp-core-build /opt/pulp/bin/pip freeze --all -l -r /opt/pulp/pulp-requirements.txt > requirements.txt
docker rmi pulp-core-build
```

Note that
