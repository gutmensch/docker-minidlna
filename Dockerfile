FROM alpine:3.11 AS runner
# start on qnap with
# docker run -d  --cpus ".2" --memory 256mb --cap-add SYS_NICE --net host -v var-lib-mpd:/var/lib/mpd -v /share/Music:/media/music:ro --device=/dev/snd:/dev/snd --name mpd-1 --restart always gutmensch/mpd:latest

LABEL maintainer="@gutmensch https://github.com/gutmensch"

# install s6 for mpd and ympd
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN adduser -D -g '' dlna

# running as user mpd not possible on qnap because
# /dev/snd rights wrong, audio group missing
RUN apk -q update \
    && apk -q --no-progress add \
	minidlna \
    && rm -rf /var/cache/apk/*

COPY ./manifest/ /

ENTRYPOINT ["/init"]
