#! /bin/sh
set -e

initialize() {
	NODE_DIR=$1

	if [ ! -f "$NODE_DIR/config/genesis.json" ]; then
		echo "Initializing node directory at $NODE_DIR"
		cp -r /mova/mainnet-config/* "$NODE_DIR"
	fi
}


initialize "/mova/node$ID"
cd "/mova/node$ID"
exec supervisord --nodaemon --configuration /etc/supervisor/supervisord.conf
