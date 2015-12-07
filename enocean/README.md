# Environment Variables

## First shoot : 

docker run --name compile-enocean -v /todo:/root/.ssh jeedom/compilation-enocean

## Relaunch 
docker start compile-enocean
docker logs compile-enocean
