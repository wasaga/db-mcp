FROM gcr.io/distroless/base-debian12@sha256:27769871031f67460f1545a52dfacead6d18a9f197db77110cfc649ca2a91f44
ENV PORT=8080
COPY ./db-mcp /bin/db-mcp
ENTRYPOINT ["/bin/db-mcp"]
