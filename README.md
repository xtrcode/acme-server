This Docker image is based on  [katoni/simple-acme-server](https://github.com/katoni/simple-acme-server) utilizing [smallstep](https://smallstep.com)'s  [step-ca](https://github.com/smallstep/certificates) and [step-cli](https://github.com/smallstep/cli)

# Getting started
```
$ docker build -t acme-server .
$ docker run --name ca --restart unless-stopped -v step:/home/step -d acme-server:latest
```

Download Root/Intermediate CA from container:
```
$ docker cp ca:/home/step/certs/root_ca.crt .
$ docker cp ca:/home/step/certs/intermediate_ca.crt .
```

Inspect Root/Intermediate CA:
```
$  openssl x509 -in root_ca.crt -noout -text
$  openssl x509 -in intermediate_ca.crt -noout -text
```

## Access from another container

Example with Traefik reverse proxy:
```
services:
  traefik:
    image: traefik:v2.8
    command:
      ...
      - --certificatesResolvers.internal.acme.email=your-email@your-domain.org
      - --certificatesResolvers.internal.acme.httpChallenge=true
      - --certificatesResolvers.internal.acme.httpChallenge.entryPoint=http
      - --certificatesResolvers.internal.acme.caServer=https://ca/acme/acme/directory
    volumes:
      ...
      - ./ca.pem:/ca.pem
    environment:
      ...
      LEGO_CA_CERTIFICATES: /ca.pem
```

## LICENSE
MIT
