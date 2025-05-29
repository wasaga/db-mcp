FROM golang:1.24-bookworm AS build
WORKDIR /go
COPY go.mod go.sum ./
RUN go mod download
COPY . . 
RUN go build .


FROM gcr.io/distroless/base-debian12@sha256:27769871031f67460f1545a52dfacead6d18a9f197db77110cfc649ca2a91f44
ENV PORT=8080
COPY --from=build /go/db-mcp /bin/db-mcp
COPY ./northwind.db /northwind.db
ENTRYPOINT ["/bin/db-mcp"]
