#!/bin/bash

npx truffle migrate --network besu-0 --reset && npx truffle migrate --network besu-1 --reset && npx truffle migrate --network besu-2 --reset && npx truffle migrate --network besu-3 --reset
