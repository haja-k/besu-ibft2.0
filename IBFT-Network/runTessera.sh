#!/bin/bash

cd Node-1/Tessera
tessera -configfile tessera.conf

cd ../../Node-2/Tessera
tessera -configfile tessera.conf

cd ../../Node-3/Tessera
tessera -configfile tessera.conf

cd ../../Node-4/Tessera
tessera -configfile tessera.conf


