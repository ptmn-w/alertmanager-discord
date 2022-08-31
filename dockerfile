#get dependancies
RUN go get -d -v
#build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/alertmanager-discord


# STEP 2 build a small image
# start from scratch
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
# Copy our static executable
COPY --from=builder /go/bin/alertmanager-discord /go/bin/alertmanager-discord

ENV LISTEN_ADDRESS=0.0.0.0:9094
EXPOSE 9094
USER appuser
ENTRYPOINT ["/go/bin/alertmanager-discord"]
ENV DISCORD_WEBHOOK=
