#! /bin/sh
set -e

initialize() {
	NODE_DIR=$1

	if [ ! -f "$NODE_DIR/config/genesis.json" ]; then
		echo "Initializing node directory at $NODE_DIR"
		cp -r /mova/mainnet-config/* "$NODE_DIR"
	fi
}

# Tendermint serves Prometheus metrics only when [instrumentation] is enabled in
# config.toml. The file is seeded once from mainnet-config, so apply the setting on
# every start to also cover node-data that was initialized before this existed.
configure_metrics() {
	CONFIG_TOML=$1/config/config.toml

	if [ "${METRICS_ENABLE:-1}" = "1" ]; then
		METRICS_ENABLED=true
	else
		METRICS_ENABLED=false
	fi
	sed -i \
		-e "s|^prometheus = .*|prometheus = $METRICS_ENABLED|" \
		-e "s|^prometheus_listen_addr = .*|prometheus_listen_addr = \":${METRICS_PORT:-26660}\"|" \
		"$CONFIG_TOML"
}


initialize "/mova/node$ID"
configure_metrics "/mova/node$ID"
cd "/mova/node$ID"
exec supervisord --nodaemon --configuration /etc/supervisor/supervisord.conf
