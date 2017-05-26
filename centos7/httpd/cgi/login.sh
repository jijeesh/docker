NAME=$(docker-compose ps | sed -n 3p | awk '{print $1}')
docker exec -it $NAME /bin/bash