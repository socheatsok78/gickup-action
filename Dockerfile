FROM buddyspencer/gickup:latest AS gickup

FROM alpine:latest
COPY --link --from=gickup /gickup/gickup /usr/bin/gickup

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
