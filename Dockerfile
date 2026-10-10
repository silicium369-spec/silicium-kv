FROM gcr.io/distroless/cc-debian12:nonroot

WORKDIR /app
COPY bin/silicium_kv_server /app/silicium_kv_server

ENV PORT=6379
EXPOSE 6379

USER nonroot:nonroot
ENTRYPOINT ["/app/silicium_kv_server"]
