#!/bin/bash
################################################################################
# Proton tools 
#
# Created by CryptoLions.io
#
# https://github.com/ProtonProtocol/proton.start
# 
#
###############################################################################


NODEOSBINDIR="/opt/bin/bin"
DATADIR="/opt/ProtonMainNet/protonNode"

$DATADIR/stop.sh
echo -e "Starting Nodeos \n";

ulimit -n 65535
ulimit -s 64000


$NODEOSBINDIR/nodeos --data-dir $DATADIR --config-dir $DATADIR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/nodeos.pid

