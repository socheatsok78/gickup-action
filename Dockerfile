ARG GICKUP_VERSION=latest
ARG GOMPLATE_VERSION=latest

FROM buddyspencer/gickup:${GICKUP_VERSION} AS gickup
FROM hairyhenderson/gomplate:v${GOMPLATE_VERSION}-alpine AS gomplate

FROM alpine:latest AS base
RUN apk add --no-cache ca-certificates bash
COPY --link --from=gickup /gickup/gickup /usr/local/bin/gickup
COPY --link --from=gomplate /bin/gomplate /usr/local/bin/gomplate
ADD rootfs /

FROM scratch
COPY --from=base --link / /
ENTRYPOINT ["/entrypoint.sh"]
