# Overview

This is a simple demo MCP HTTP server. You can use it with claude.ai or other compatible MCP clients. 

You need protect its access using [Pomerium](https://github.com/pomerium/pomerium). Currently you need to use `main` branch. 


# Config

Note that you do need to set up database persistence, to keep client registrations etc. 

Note that you need pass a domain name as in the `from` of the route. 

You may obtain a test database: https://github.com/jpwhite3/northwind-SQLite3

```yaml
authenticate_service_url: https://authenticate.pomerium.app

autocert: true

runtime_flags:
  mcp: true

databroker_storage_type: postgres
databroker_storage_connection_string: postgresql://postgres:postgres@postgres:5432/pomerium?sslmode=disable

routes:
  - from: https://db-mcp.your-domain.com
    to: http://mcp-sqlite:8080
    preserve_host_header: true
    mcp: {}
    policy:
      - allow:
          or:
            - domain:
                is: your-domain.com
```

```docker
services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: pomerium
      POSTGRES_HOST_AUTH_METHOD: trust
    ports:
      - 5432:5432
    volumes:
      - postgres-data:/var/lib/postgresql/data
  pomerium:
    image: pomerium/pomerium:main
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./config.yaml:/pomerium/config.yaml
      - pomerium-autocert:/data/autocert
  mcp-sqlite:
    build:
      context: mcp-sqlite
      dockerfile: Dockerfile
    volumes:
      - ./db/northwind.db:/northwind.db
    environment:
      PORT: 8080
      DB_FILE: /northwind.db
      BASE_URL: https://db-mcp.your-domain.com
    expose:
      - 8080
volumes:
  postgres-data:
  pomerium-autocert:
```

