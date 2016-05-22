#/bin/bash

releaseDataPath=/var/data/
dockerPath=$releaseDataPath/docker
databasePath=$releaseDataPath/db

echo "Starting database docker"
docker start moveatis-db 2>&1
# Read if there is a error; database image might not be yet installed 
if [ $? -ne 0 ]; then
    # Zero equals "no error", so if output was something else than zero, there was an error 
    # and most likely error is that there was no database image yet
    docker create -p 5432:5432 --name moveatis-db -v $databasePath:/var/lib/postgresql/data -e 'DB_USER=moveatis' -e 'DB_PASS=lotas' -e 'DB_NAME=moveatisdb' centos/postgresql 2>&1
    # image installed, lets try starting again 
    docker start moveatis-db 2>&1
fi
echo "Database docker running"

echo "Starting Wildfly docker"
docker start -a -i moveatis-wildfly 2>/dev/null 
# Same as before; read if there is an error and create docker image, if there wasn't already one existing 
if [ $? -ne 0 ]; then
    docker create --privileged=true -it -p 25:25 -p 8009:8009 --name moveatis-wildfly --link moveatis-db:lotasdb -v $dockerPath:/opt/wildfly/standalone/deployments moveatis/moveatis-release 2>/dev/null
    if [ $? -eq 0 ]; then
    	docker start -a -i moveatis-wildfly 2>/dev/null
    fi
fi

