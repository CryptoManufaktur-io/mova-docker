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

## Metrics

Tendermint's Prometheus exporter is enabled by default (`METRICS_ENABLE=1`, `METRICS_PORT=26660` in `.env`).
`scripts/entrypoint.sh` applies these to `[instrumentation]` in `config.toml` on every start, so it also
covers node data that was initialized earlier. Metrics use the `mova_` prefix and are served at
`/metrics` on the container-internal `METRICS_PORT`; the port is not published to the host. The labels in
`mova.yml` make the central-proxy Prometheus scrape it (requires `ext-network.yml`). Set `METRICS_ENABLE=0`
to disable. Note this is unrelated to the host-side `RPC_PORT` (also `26660` by default).

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
