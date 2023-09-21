# NGINX container custom images

## _Custom nginx images for development and production_

Exploring docker by creating custom nginx images for development 
and production, seprately as well as usinga  multi-stage build

## NGINX Configurations :gear:

The Nginx images under this repository are all using default configurations.

## Docker :hammer_and_wrench:
By default, the Docker will expose ports 80/tcp and 443/tcp, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd docker-nginx-exploring
#create logs directory since it is mounted to the container
mkdir logs

#developement image build
docker build . -t cs-nginx-dev -f Dockerfile.dev 

#developement image build multi-stage
docker build . -t cs-nginx-dev-multistage -f Dockerfile --target dev

#production image build
docker build . -t cs-nginx-prod -f Dockerfile.prod 

#production image build multi-stage
docker build . -t cs-nginx-prod-multistage -f Dockerfile --target prod
```

This will create the custom nginx image and pull-in/install the necessary dependencies.

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8080 of the host to
port 80 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
#developement container
docker run -p 8080:80 --restart=always -itd  --name nginx-dev --mount type=bind,source=./logs/,destination=/var/log/nginx/ --mount type=bind,source=./src/,destination=/var/www/html --mount type=bind,source=./configurations/sites-enabled/,destination=/etc/nginx/sites-enabled cs-nginx-dev

#developement container multi-stage
docker run -p 8080:80 --restart=always -itd  --name nginx-dev-multistage --mount type=bind,source=./logs/,destination=/var/log/nginx/ --mount type=bind,source=./src/,destination=/var/www/html --mount type=bind,source=./configurations/sites-enabled/,destination=/etc/nginx/sites-enabled cs-nginx-dev-multistage

#production container
docker run -p 8080:80 --restart=always -itd  --name nginx-prod --mount type=bind,source=./logs/,destination=/var/log/nginx/ cs-nginx-prod

#production container multi-stage
docker run -p 8080:80 --restart=always -itd  --name nginx-prod-multistage --mount type=bind,source=./logs/,destination=/var/log/nginx/ cs-nginx-prod-multistage
```

Verify the deployment by navigating to your server address in
your preferred browser.

```sh
127.0.0.1:8080
```

