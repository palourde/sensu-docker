# sensu-docker

**For testing purposes only!**

### Build
```
export SENSU_VERSION=0.27.1-2
docker build --build-arg VERSION=$SENSU_VERSION -t palourde/sensu:$SENSU_VERSION .
```

### Run
```
docker run -d -p 4567:4567 -p 5672:5672 palourde/sensu:$SENSU_VERSION
```
