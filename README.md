# Overview

Docker Compose for [Mova Mainnet](https://scan.movan.movachain.com) ("movan", ChainID `61901`) —
a full EVM-compatible node, syncing from genesis.

Meant to be used with [central-proxy-docker](https://github.com/CryptoManufaktur-io/central-proxy-docker) for traefik
and Prometheus remote write; use `:ext-network.yml` in `COMPOSE_FILE` inside `.env` in that case.

If you want the RPC/WS ports exposed locally, use `rpc-shared.yml` in `COMPOSE_FILE` inside `.env`.

> **Note:** the container's internal RPC/WS ports are fixed at `9545`/`9546` regardless of what
> `RPC_PORT`/`WS_PORT` you set on the host side in `.env` — see the comments in `mova.yml`.

## Quick Start

`cp default.env .env`

`nano .env` and adjust variables as needed, particularly `DOMAIN` and `RPC_HOST`/`WS_HOST` if this
server is one of several Mova nodes behind the same traefik.

`./movad up`

Monitor sync:

```bash
./movad logs -f movan-syncnode
```

## Verify the node

Check block height is non-zero and increasing:

```bash
curl -X POST -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' \
  http://127.0.0.1:${RPC_PORT:-26660}
```

Cross-check the returned block height/hash against [scan.movan.movachain.com](https://scan.movan.movachain.com).

## Software update

To update the software, run `./movad update` and then `./movad up`

## Version

This is Mova Docker v1.0.0
