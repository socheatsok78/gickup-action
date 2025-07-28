FROM buddyspencer/gickup:latest AS gickup
FROM hairyhenderson/gomplate:latest AS gomplate

FROM alpine:latest
RUN apk add --no-cache ca-certificates bash
COPY --link --from=gickup /gickup/gickup /usr/local/bin/gickup
COPY --link --from=gomplate /gomplate /usr/local/bin/gomplate
ADD rootfs /
ENTRYPOINT ["/entrypoint.sh"]
